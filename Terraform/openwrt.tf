// Image download
resource "null_resource" "openwrt_image_download" {
  provisioner "local-exec" {
    command = "curl --output openwrt.img.gz https://downloads.openwrt.org/releases/24.10.1/targets/x86/64/openwrt-24.10.1-x86-64-generic-squashfs-combined-efi.img.gz"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ./openwrt*.img*"
  }
  lifecycle {
    replace_triggered_by = [ proxmox_virtual_environment_vm.openwrt_vm.id ]
  }
}

// Unzip the Image
resource "null_resource" "unzip_openwrt_image" {
  provisioner "local-exec" {
    command = "gzip -q -d ${path.module}/openwrt.img.gz 2>/dev/null || true"
  }
  lifecycle {
    replace_triggered_by = [ proxmox_virtual_environment_vm.openwrt_vm.id ]
  }
  depends_on = [null_resource.openwrt_image_download]
}

############################
# Template the file here 
## Example ##
#templatefile("${path.module}/backends.tftpl", { port = 8080, ip_addrs = ["10.0.0.1", "10.0.0.2"] })
## Example ##
##########################
# Create the mount point directory
# Mount the openwrt img
# inject the files
# Unmount the image
##########################

// Image upload
resource "proxmox_virtual_environment_file" "openwrt_image_upload" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = data.proxmox_virtual_environment_node.node.node_name
  source_file {
    path = "${path.module}/openwrt.img"
  }
  lifecycle {
    replace_triggered_by = [ proxmox_virtual_environment_vm.unzip_openwrt_image.id ]
  }
  depends_on = [ null_resource.unzip_openwrt_image ]
}

// Openwrt Virtual Machine
resource "proxmox_virtual_environment_vm" "openwrt_vm" {
  name        = "openwrt"
  description = "Managed by Terraform"
  tags        = ["Terraform", "OpenWRT"]

  node_name = data.proxmox_virtual_environment_node.node.node_name
  vm_id     = 9000

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }
  # if agent is not enabled, the VM may not be able to shutdown properly, and may need to be forced off
  stop_on_destroy = true

  startup {
    order      = "3"
    up_delay   = "10"
    down_delay = "10"
  }

  cpu {
    cores        = 1
    type         = "x86-64-v2-AES"  # recommended for modern CPUs
  }

  memory {
    dedicated = 1024
    floating  = 1024 # set equal to dedicated to enable ballooning
  }

  disk {
    datastore_id = "local-zfs"
    file_id      = proxmox_virtual_environment_file.openwrt_image_upload.id
    interface    = "scsi0"
  }

  hostpci {
    device = "hostpci1"
    id = "04:00.0"
  }

  initialization {
    datastore_id = "local-zfs"
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      password = "changemepls"
      username = "ubuntu"
    }

  }

  network_device {
    bridge = proxmox_virtual_environment_network_linux_bridge.vmbr99.name
  }

  operating_system {
    type = "l26"
  }

  serial_device {

  }
  depends_on = [proxmox_virtual_environment_file.openwrt_image_upload]
}
