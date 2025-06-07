resource "proxmox_virtual_environment_file" "router_user_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = data.proxmox_virtual_environment_node.node.node_name

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: ${var.cloudinit.hostname}
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
            macaddress: ${var.macaddresses.routerwan}
          set-name: wan0
          addresses:
            - ${var.ipaddresses.routerwan}
          routes:
          - to: default
            via: ${var.ipaddresses.gateway}
          nameservers:
            addresses: [8.8.8.8, 8.8.4.4]
          dhcp4: false
          dhcp6: false

        # LAN interface
        lan:
          match:
            macaddress: ${var.macaddresses.routerlan1}
          set-name: lan0
          addresses:
            - ${var.ipaddresses.routerlan1}
          dhcp4: false
          dhcp6: false
    EOF

    file_name = "router-network-data.yaml"
  }
}