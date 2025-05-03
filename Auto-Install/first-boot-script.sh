#!/bin/bash

set -e

# === Variables ===
VM_ID=$((100 + RANDOM % 899))
VM_NAME="GitHub_Runner"
BRIDGE="vmbr0"
STORAGE="local-zfs"
CLOUD_IMAGE_URL="https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
USER="runner"
PASSWORD="Changeme123"
SSH_KEY_PATH="$HOME/.ssh/id_rsa.pub"
ANSIBLE_REPO_URL="https://github.com/tekore/HomeOps.git"
ANSIBLE_REPO_PLAYBOOK="Ansible/configure-runner.yml"
CLOUDINIT_DIR="/var/lib/vz/template"
CLOUDINIT_FILE="${CLOUDINIT_DIR}/${VM_NAME}-${VM_ID}-cloudinit.yaml"

# === Search for the required USB drive/file===
echo "🔎 Searching for USB drive.."
found_usb=0

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
            yaml_data+=$'\n'
            yaml_data+="$(cat "$yaml_file")"
          fi
        done
  fi
done

if [[ $found_usb -eq 0 ]]; then
  echo "❌ No USB drives detected!"
  exit 1
fi

# === Download the Ubuntu cloud image ===
wget -O ubuntu_cloud.img "$CLOUD_IMAGE_URL"
echo "✅ Downloaded ubuntu Cloud Image"
# === CREATE VM ===
qm create $VM_ID --name $VM_NAME --memory 2048 --net0 virtio,bridge=$BRIDGE

# === Import the disk ===
qm importdisk $VM_ID ubuntu_cloud.img $STORAGE
qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-${VM_ID}-disk-0

# === Configure the cloud-init drive ===
qm set $VM_ID --ide2 $STORAGE:cloudinit
qm set $VM_ID --boot order=scsi0
qm set $VM_ID --serial0 socket --vga serial0

# TODO: After testing, remove the runner_secrets.yml out of /tmp
# === Create the cloud-init file ===
mkdir -p "$CLOUDINIT_DIR"
cat > "$CLOUDINIT_FILE" <<EOF
#cloud-config
package_update: true
write_files:
  - path: /tmp/runner_secrets.yml
    content: |
      $yaml_data
    owner: 'root:root'
    permissions: '0644'
packages:
  - ansible
runcmd:
  - ansible-pull -U $ANSIBLE_REPO_URL -i localhost --purge $ANSIBLE_REPO_PLAYBOOK --extra-vars "@runner_secrets.yml"
EOF

# === Apple cloud-init settings ===
qm set $VM_ID --ciuser $USER --cipassword "$PASSWORD" --ipconfig0 ip=dhcp
qm set $VM_ID --sshkey "$SSH_KEY_PATH"
qm set $VM_ID --cicustom "user=local:template/$(basename $CLOUDINIT_FILE)"

# === START VM ===
qm start $VM_ID
echo "✅ VM $VM_ID ($VM_NAME) created and started with Ansible pull."
