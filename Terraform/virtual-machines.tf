// Ubuntu Image Upload
resource "proxmox_virtual_environment_download_file" "latest_ubuntu_24_noble_qcow2_img" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = data.proxmox_virtual_environment_node.node.node_name
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

// Axis Router Virtual Machine
resource "proxmox_virtual_environment_vm" "router_virtual_machine" {
  name        = "AxisRouter"
  description = "Managed by Terraform"
  tags        = ["Terraform", "Ubuntu"]
  node_name = data.proxmox_virtual_environment_node.node.node_name
  vm_id     = 9000
  agent { enabled = false }
  stop_on_destroy = true
  cpu {
    cores = 1
    type  = "x86-64-v2-AES"
  }
  memory {
    dedicated = 3072
    floating  = 3072
  }
  disk {
    datastore_id = "local-zfs"
    file_id      = proxmox_virtual_environment_download_file.latest_ubuntu_24_noble_qcow2_img.id
    interface    = "scsi0"
    size         = 20
  }
  hostpci {
    device = "hostpci1"
    id = var.pci-devices.router
  }
  network_device {
    bridge = "vmbr99"
    mac_address = var.macaddresses.routerlan1
  }
  initialization {
    datastore_id = "local-zfs"
    user_data_file_id = proxmox_virtual_environment_file.router_user_data.id
    network_data_file_id = proxmox_virtual_environment_file.router_network_data.id
  }
  operating_system { type = "l26" }
  serial_device {}
  vga { type = "serial0" }
  depends_on = [ proxmox_virtual_environment_network_linux_bridge.vmbr99 ]
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
  ip_address = "192.168.1.101/24"
  gateway = var.ipaddresses.gateway
  depends_on = [ proxmox_virtual_environment_network_linux_bridge.vmbr99 ]
}

// Kubernetes Virtual Machines (Production)
module "kubernetes_production_virtual_machine" {
  count = 3
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
  network_bridge = "vmbr99"
  user_data = proxmox_virtual_environment_file.kubernetes_user_data.id
  ip_address = "10.10.1.${100 + count.index}/24"
  gateway = var.ipaddresses.internalgateway
  depends_on = [ proxmox_virtual_environment_network_linux_bridge.vmbr99 ]
}

// Kubernetes Virtual Machines (Test)
module "kubernetes_test_virtual_machine" {
  count = 3
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
  network_bridge = "vmbr99"
  user_data = proxmox_virtual_environment_file.kubernetes_user_data.id
  ip_address = "10.10.1.${200 + count.index}/24"
  gateway = var.ipaddresses.internalgateway
  depends_on = [ proxmox_virtual_environment_network_linux_bridge.vmbr99 ]
}