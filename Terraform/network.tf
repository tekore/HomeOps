// Isolated network
resource "proxmox_virtual_environment_network_linux_bridge" "vmbr99" {
  node_name = data.proxmox_virtual_environment_node.node.node_name
  name      = "vmbr99"
  address = "10.10.10.1/24"
  comment = "Isolated network"
}
