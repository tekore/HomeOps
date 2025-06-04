resource "proxmox_virtual_environment_file" "router_user_data" {
  content_type = "snippets"
  datastore_id = "local-zfs"
  node_name    = data.proxmox_virtual_environment_node.node.node_name

  source_raw {
    data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
    - ansible
    - git
    - openssh-server
    users:
    - name: tekore
        groups: sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        ssh_authorized_keys:
        - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1UYC+NU9ck8UO3p3VCpxCMiR8hax7UG1AYJuX6kztoR1q9D4GpBxM42Yu2A4WsKeEz9nBt7SyKSWuToykbYzL5hZTGL0clSQhfb0GbcmYJSniqEefFKb6xagpggZvfeMj0iMCv5aHQ17oGwcT3PaiSqjyDPsanIPBDqaoC+YRtot1LPnX9EvCcRp/s9cg0Sh7eBp+4bBv0CxXt0dCpUNNxEROSp1nyTK6PcpFXxhfvrbWuiL2ROIOM+qWjRzWZUHFuouYzdaQTtAJz9+SO+crQldTTToJpslYdrv+ehU0b+dVko3M2YDoMtUD9J7yaksijvPFviWpN8N2Dg6VQ4N/9hoC9q07pO8Ii0D/0HPjyGArv2zEJBFQsAukvFtiWix2HADjXEcd+rtJGJ9od7se1uJUFawmXRJbdmNPlfMeZ6IEd7tlKTCs00/DJ0jl/oY8Tqpp5+WnexiH0OgXmRT5psV0epeQeYWgkQs202LirpKhaocPD7IviRihRfdJcSpItU0LWz4YaSl/RDZyii9wpArv4B7F4Hz5rILo2enzLxDaY9Rzn7MxdS/pVD+MkyQaCzbrVcbu/o8D1xjKaI+Syc1R2uT5N2oZLN4SLX5DBj3QFbe/cvIYkauHVoI/KovNw6teYp2HNS06lhAVuhktj5nmSNmwBk/YidgGZC3Zsw==
    runcmd:
    - ansible-pull -U "https://github.com/tekore/HomeOps" -i localhost --purge Ansible/configure-router.yml"
    EOF

    file_name = "router-user-data.yaml"
  }
}

resource "proxmox_virtual_environment_file" "router_network_data" {
  content_type = "snippets"
  datastore_id = "local-zfs"
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
            macaddress: "00:11:22:33:44:55"  # Replace with actual WAN interface MAC
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
            macaddress: "aa:bb:cc:dd:ee:ff"  # Replace with actual LAN interface MAC
        set-name: lan0
        addresses:
            - 10.0.0.1/24  # Static IP for LAN
        dhcp4: false
        dhcp6: false
    EOF

    file_name = "router-network-data.yaml"
  }
}