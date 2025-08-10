// Ubuntu Image Upload
resource "proxmox_virtual_environment_download_file" "latest_ubuntu_24_noble_qcow2_img" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = data.proxmox_virtual_environment_node.node.node_name
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

// Axis Remote Desktop Virtual Machine
module "desktop_virtual_machine" {
  source = "./modules/proxmox-vm"  
  vm_name     = "AxisDesktop"
  cpu_cores = 8
  memory_dedicated = 32768
  memory_floating = 32768
  disk_size = 60
  vm_tags     = ["Terraform", "Ubuntu", "Desktop", "nx"]
  node_name   = data.proxmox_virtual_environment_node.node.node_name
  vm_id       = 8999
  disk_file_id = proxmox_virtual_environment_download_file.latest_ubuntu_24_noble_qcow2_img.id
  network_bridge = "vmbr0"
  user_data = proxmox_virtual_environment_file.desktop_user_data.id
  ip_address = "192.168.100.101/24"
  gateway = var.ipaddresses.gateway
  depends_on = [ proxmox_virtual_environment_network_linux_bridge.vmbr99 ]
}

// Kubernetes Virtual Machines (Production)
module "kubernetes_production_virtual_machine" {
  count = 5
  source = "./modules/proxmox-vm"
  vm_name     = "Kubernetes-prod-${count.index + 1}"
  cpu_cores = 2
  memory_dedicated = 8192
  memory_floating = 8192
  disk_size = 30
  vm_tags     = ["Terraform", "Ubuntu", "Kubernetes-prod-${count.index + 1}"]
  node_name   = data.proxmox_virtual_environment_node.node.node_name
  vm_id       = 200 + count.index
  disk_file_id = proxmox_virtual_environment_download_file.latest_ubuntu_24_noble_qcow2_img.id
  network_bridge = "vmbr101"
  user_data = proxmox_virtual_environment_file.kubernetes_user_data.id
  ip_address = "192.168.101.${110 + count.index}/24"
  gateway = "192.168.101.1"
  depends_on = [ proxmox_virtual_environment_network_linux_bridge.vmbr101 ]
}

// Kubernetes Virtual Machines (Test)
module "kubernetes_test_virtual_machine" {
  count = 5
  source = "./modules/proxmox-vm"  
  vm_name     = "Kubernetes-test-${count.index + 1}"
  cpu_cores = 2
  memory_dedicated = 8192
  memory_floating = 8192
  disk_size = 30
  vm_tags     = ["Terraform", "Ubuntu", "Kubernetes-test-${count.index + 1}"]
  node_name   = data.proxmox_virtual_environment_node.node.node_name
  vm_id       = 210 + count.index
  disk_file_id = proxmox_virtual_environment_download_file.latest_ubuntu_24_noble_qcow2_img.id
  network_bridge = "vmbr101"
  user_data = proxmox_virtual_environment_file.kubernetes_user_data.id
  ip_address = "192.168.101.${120 + count.index}/24"
  gateway = "192.168.101.1"
  depends_on = [ proxmox_virtual_environment_network_linux_bridge.vmbr101 ]
}