resource "proxmox_virtual_environment_file" "desktop_user_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = data.proxmox_virtual_environment_node.node.node_name

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: AxisDesktop
    timezone: ${var.cloudinit.timezone}
    users:
      - default
      - name: tekore
        groups:
          - sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        lock_passwd: false
        passwd: ${var.cloudinit.passwordhash}
        ssh_authorized_keys:
          - ${var.cloudinit.sshkey}
          - ${var.cloudinit.sshkey2}
      - name: valraevn
        groups:
          - sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        lock_passwd: false
        passwd: ${var.cloudinit.valraevnpasswordhash}
    package_update: true
    package_upgrade: true
    packages:
      - ansible
      - openssh-server
      - vim
      - wget
      - snapd
      - ubuntu-gnome-desktop
    runcmd:
      - wget ${var.cloudinit.desktopsoftware}
      - dpkg -i *terminal-server_9.0*.deb
      - snap install code --classic
      - snap install snap-store
      - systemctl daemon-reload
    EOF

    file_name = "desktop-user-data.yaml"
  }
}

resource "proxmox_virtual_environment_file" "kubernetes_user_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = data.proxmox_virtual_environment_node.node.node_name

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: Kubernetes-Node
    timezone: ${var.cloudinit.timezone}
    users:
      - default
      - name: tekore
        groups:
          - sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        lock_passwd: false
        passwd: ${var.cloudinit.passwordhash}
        ssh_authorized_keys:
          - ${var.cloudinit.sshkey}
          - ${var.cloudinit.sshkey2}
    package_update: true
    package_upgrade: true
    packages:
      - ansible
      - openssh-server
      - vim
    runcmd:
      - systemctl enable --now ssh
      - ansible-pull -U "https://github.com/tekore/HomeOps.git" -i localhost --purge "Ansible/configure-kubernetes-prerequisites.yml"
      - sleep 60
      - touch /etc/cloud/cloud-init.disabled
    EOF

    file_name = "kubernetes-user-data.yaml"
  }
}