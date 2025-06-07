resource "proxmox_virtual_environment_file" "router_user_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = data.proxmox_virtual_environment_node.node.node_name

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: ${var.cloud-init.hostname}
    timezone: ${var.cloud-init.timezone}
    users:
      - default
      - name: tekore
        groups:
          - sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        lock_passwd: false
        passwd: ${var.cloud-init.password-hash}
        ssh_authorized_keys:
          - ${var.cloud-init.ssh-key}
    package_update: true
    packages:
      - ansible
      - openssh-server
      - vim
    runcmd:
      - ansible-pull -U "https://github.com/tekore/HomeOps.git" -i localhost --purge "Ansible/configure-router.yml"
    EOF

    file_name = "router-user-data.yaml"
  }
}

resource "proxmox_virtual_environment_file" "router_network_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = data.proxmox_virtual_environment_node.node.node_name

  source_raw {
    data = <<-EOF
    #cloud-config
    network:
      version: 2
      ethernets:
        wan:
          match:
            macaddress: {var.mac-addresses.router-wan}
          set-name: wan0
          addresses:
            - ${var.ip-addresses.router-wan}
          routes:
          - to: default
            via: ${var.ip-addresses.gateway}
          nameservers:
            addresses: [8.8.8.8, 8.8.4.4]
          dhcp4: false
          dhcp6: false

        # LAN interface
        lan:
          match:
            macaddress: ${var.mac-addresses.router-lan1}
          set-name: lan0
          addresses:
            - ${var.ip-addresses.router-lan1}
          dhcp4: false
          dhcp6: false
    EOF

    file_name = "router-network-data.yaml"
  }
}