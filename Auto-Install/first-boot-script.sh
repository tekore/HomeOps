#!/bin/bash

set -e

# === Variables ===
VM_ID=$((100 + RANDOM % 899))
VM_NAME="GitHub-Runner"
BRIDGE="vmbr0"
STORAGE="local-zfs"
CLOUD_IMAGE_URL="https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
USER="runner"
PASSWORD="Changeme123"
SSH_KEY_PATH="/root/.ssh/id_rsa.pub"
ANSIBLE_REPO_URL="https://github.com/tekore/HomeOps.git"
ANSIBLE_REPO_PLAYBOOK="Ansible/configure-runner.yml"

# === Search for the required USB drive/file ===
echo "🔎 Searching for USB drive.."
found_usb=0
yaml_data=""

for DEV in /dev/sd?; do
  if [[ ! -b $DEV ]]; then
    continue
  fi
  if udevadm info --query=property --name="$DEV" | grep -q "ID_BUS=usb"; then
    found_usb=1
    echo "✅ Found USB drive $DEV"
    mount $DEV /mnt
    for yaml_file in /mnt/*.yml; do
      if [[ -f "$yaml_file" ]]; then
        echo "✅ Found YAML file: $yaml_file"
        while IFS= read -r line; do
          yaml_data+=$'\n        '
          yaml_data+="$line"
        done < "$yaml_file"
      fi
    done
  fi
done

if [[ $found_usb -eq 0 ]]; then
  echo "❌ No USB drives detected!"
  exit 1
fi

# === Create the cloud-init file ===
mkdir -p "/var/lib/vz/snippets"
cat > "/var/lib/vz/snippets/cloudinit.yml" <<EOF
#cloud-config
write_files:
  - path: /tmp/runner_secrets.yml
    content: |
        $yaml_data
    owner: 'root:root'
    permissions: '0644'
ssh_pwauth: true
disable_root: false
chpasswd:
  list: |
    $USER:$PASSWORD
  expire: false
users:
  - name: $USER
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    lock_passwd: false
runcmd:
  - sleep 10
  - dhclient -v
  - apt-get update
  - apt-get upgrade -y
  - apt-get install -y ansible openssh-server
  - ansible-pull -U $ANSIBLE_REPO_URL -i localhost --purge $ANSIBLE_REPO_PLAYBOOK --extra-vars "@/tmp/runner_secrets.yml"
EOF

# === Print cloud-init file for debugging purposes ===
echo "=== Cloud-init Configuration ==="
cat /var/lib/vz/snippets/cloudinit.yml
echo "==============================="

# === Download the Ubuntu cloud image ===
wget -O ubuntu_cloud.img "$CLOUD_IMAGE_URL"
echo "✅ Downloaded ubuntu Cloud Image"

# === Create the virtual machine ===
qm create $VM_ID --name $VM_NAME --memory 4096 --net0 virtio,bridge=$BRIDGE

# === Import the disk ===
qm importdisk $VM_ID ubuntu_cloud.img $STORAGE
qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-${VM_ID}-disk-0
qm resize $VM_ID scsi0 +15G

# === Configure the cloud-init drive ===
qm set $VM_ID --ide2 $STORAGE:cloudinit
qm set $VM_ID --boot order=scsi0
qm set $VM_ID --serial0 socket --vga serial0

# === Enable snippets on the storage ===
CURRENT_CONTENT=$(grep -A10 "^dir:" /etc/pve/storage.cfg | grep content | head -1 | cut -d' ' -f2)
pvesm set local --content $CURRENT_CONTENT,snippets

# === Apply cloud-init settings ===
qm set $VM_ID --cicustom "user=local:snippets/cloudinit.yml"

# === Start the virtual machine ===
qm start $VM_ID
echo "✅ VM $VM_ID ($VM_NAME) created and started with Ansible pull."