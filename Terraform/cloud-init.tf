resource "proxmox_virtual_environment_file" "router_user_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = data.proxmox_virtual_environment_node.node.node_name

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: test-ubuntu-fuk
    timezone: America/Toronto
    users:
      - default
      - name: ubuntu
        groups:
          - sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
    package_update: true
    packages:
      - qemu-guest-agent
      - net-tools
      - curl
    runcmd:
      - echo "done" > /tmp/cloud-config.done
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
        # WAN interface (match by MAC address)
        wan:
          match:
            macaddress: "80:61:5f:06:1b:40"
          set-name: wan0
          addresses:
            - 192.168.1.111/24  # Static IP for WAN
          gateway4: 192.168.1.254  # WAN gateway
          nameservers:
            addresses:
              - 8.8.8.8
              - 8.8.4.4
          dhcp4: false
          dhcp6: false

        # LAN interface (match by MAC address)
        lan:
          match:
            macaddress: "a1:10:ce:34:ee:ff"
          set-name: lan0
          addresses:
            - 10.0.0.1/24  # Static IP for LAN
          dhcp4: false
          dhcp6: false
    EOF

    file_name = "router-network-data.yaml"
  }
}