// Ubuntu Image Upload
resource "proxmox_virtual_environment_download_file" "latest_ubuntu_24_noble_qcow2_img" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = data.proxmox_virtual_environment_node.node.node_name
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

// Bastion Virtual Machine
#module "bastion_virtual_machine" {
#  source = "./modules/proxmox-vm"  
#  vm_name     = "Bastion"
#  vm_tags     = ["Terraform", "Ubuntu", "Bastion"]
#  node_name   = data.proxmox_virtual_environment_node.node.node_name
#  vm_id       = 1010
#  disk_file_id = proxmox_virtual_environment_download_file.latest_ubuntu_24_noble_qcow2_img.id
#  network_bridge = "vmbr99"
#  user_data = proxmox_virtual_environment_file.router_user_data.id
#  network_data = proxmox_virtual_environment_file.router_network_data.id
#}

// Axis Router Virtual Machine
module "router_virtual_machine" {
  source = "./modules/proxmox-vm"  
  vm_name     = "AxisRouter"
  vm_tags     = ["Terraform", "Ubuntu", "Router"]
  node_name   = data.proxmox_virtual_environment_node.node.node_name
  vm_id       = 9000
  disk_file_id = proxmox_virtual_environment_download_file.latest_ubuntu_24_noble_qcow2_img.id
  host_pci_device =  {
    device = "hostpci1"
    id = var.pci-devices.router
  }
  network_bridge = "vmbr99"
  mac_address = var.macaddresses.routerlan1
  user_data = proxmox_virtual_environment_file.router_user_data.id
  network_data = proxmox_virtual_environment_file.router_network_data.id
}
