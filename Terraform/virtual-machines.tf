// Ubuntu Image Upload
resource "proxmox_virtual_environment_download_file" "latest_ubuntu_24_noble_qcow2_img" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = data.proxmox_virtual_environment_node.node.node_name
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

// Axis Router Virtual Machine
module "router_virtual_machine" {
  source = "./modules/proxmox-vm"  
  vm_name     = "AxisRouter"
  cpu_cores = 1
  memory_dedicated = 2048
  disk_size = 20
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

// Bastion Virtual Machine
module "bastion_virtual_machine" {
  source = "./modules/proxmox-vm"  
  vm_name     = "Bastion"
  cpu_cores = 1
  memory_dedicated = 2048
  disk_size = 20
  vm_tags     = ["Terraform", "Ubuntu", "Bastion"]
  node_name   = data.proxmox_virtual_environment_node.node.node_name
  vm_id       = 1010
  disk_file_id = proxmox_virtual_environment_download_file.latest_ubuntu_24_noble_qcow2_img.id
  network_bridge = "vmbr99"
  user_data = proxmox_virtual_environment_file.generic_user_data.id
  network_data = proxmox_virtual_environment_file.generic_network_data.id
}

// Kubernetes Virtual Machines (Production)
module "kubernetes_production_virtual_machine" {
  count = 5
  source = "./modules/proxmox-vm"
  vm_name     = "Kubernetes-prod-${count.index + 1}"
  cpu_cores = 2
  memory_dedicated = 8092
  disk_size = 30
  vm_tags     = ["Terraform", "Ubuntu", "Kubernetes-prod-${count.index + 1}"]
  node_name   = data.proxmox_virtual_environment_node.node.node_name
  vm_id       = 200 + count.index
  disk_file_id = proxmox_virtual_environment_download_file.latest_ubuntu_24_noble_qcow2_img.id
  network_bridge = "vmbr99"
  user_data = proxmox_virtual_environment_file.generic_user_data.id
  network_data = proxmox_virtual_environment_file.generic_network_data.id
}

// Kubernetes Virtual Machines (Test)
module "kubernetes_test_virtual_machine" {
  count = 5
  source = "./modules/proxmox-vm"  
  vm_name     = "Kubernetes-test-${count.index + 1}"
  cpu_cores = 2
  memory_dedicated = 8092
  disk_size = 30
  vm_tags     = ["Terraform", "Ubuntu", "Kubernetes-test-${count.index + 1}"]
  node_name   = data.proxmox_virtual_environment_node.node.node_name
  vm_id       = 210 + count.index
  disk_file_id = proxmox_virtual_environment_download_file.latest_ubuntu_24_noble_qcow2_img.id
  network_bridge = "vmbr99"
  user_data = proxmox_virtual_environment_file.generic_user_data.id
  network_data = proxmox_virtual_environment_file.generic_network_data.id
}