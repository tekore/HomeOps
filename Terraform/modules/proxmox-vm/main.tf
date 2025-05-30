resource "proxmox_virtual_environment_vm" "virtual_machine" {
  name        = var.vm_name
  description = var.vm_description
  tags        = var.vm_tags
  node_name = var.node_name
  vm_id     = var.vm_id

  agent {
    enabled = var.agent_enabled
  }
  
  stop_on_destroy = var.stop_on_destroy

  startup {
    order      = var.startup_order
    up_delay   = var.startup_up_delay
    down_delay = var.startup_down_delay
  }

  cpu {
    cores = var.cpu_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory_dedicated
    floating  = var.memory_floating
  }

  disk {
    datastore_id = var.datastore_id
    file_id      = var.disk_file_id
    interface    = var.disk_interface
  }

  dynamic "hostpci" {
    for_each = var.host_pci_device != null ? [var.host_pci_device] : []
    content {
      device   = hostpci.value.device
      id       = hostpci.value.id
      mapping  = hostpci.value.mapping
      mdev     = hostpci.value.mdev
      pcie     = hostpci.value.pcie
      rombar   = hostpci.value.rombar
      rom_file = hostpci.value.rom_file
      xvga     = hostpci.value.xvga
    }
  }

  initialization {
    datastore_id = var.datastore_id
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }

    user_account {
      password = var.password
      username = var.username
      keys = var.ssh-key
    }
  }

  network_device {
    bridge = var.network_bridge
  }

  operating_system {
    type = var.os_type
  }

  serial_device {}
}
