// Isolated network
resource "proxmox_virtual_environment_network_linux_bridge" "vmbr99" {
  node_name = data.proxmox_virtual_environment_node.node.node_name
  name      = "vmbr99"
  address = "10.10.10.1/24"
  comment = "Isolated network"
}

resource "proxmox_virtual_environment_network_linux_bridge" "vmbr101" {
  node_name = data.proxmox_virtual_environment_node.node.node_name
  name      = "vmbr101"
  address = "192.168.101.100/24"
  gateway = "192.168.101.1"
  vlan_aware = true
  ports = [ proxmox_virtual_environment_network_linux_vlan.vlan101.name ]
  depends_on = [ proxmox_virtual_environment_network_linux_vlan.vlan101 ]
}

resource "proxmox_virtual_environment_network_linux_vlan" "vlan101" {
  node_name = data.proxmox_virtual_environment_node.node.node_name
  name      = "eno1.101"
  interface = "eno1"
  vlan      = 101
}