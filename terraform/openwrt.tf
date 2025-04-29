// Image download
resource "null_resource" "openwrt_image_download" {
  provisioner "local-exec" {
    command = "wget https://downloads.openwrt.org/releases/24.10.1/targets/x86/64/openwrt-24.10.1-x86-64-generic-squashfs-combined-efi.img.gz"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ./openwrt*.img*"
  }
}

// Unzip the Image
resource "null_resource" "unzip_openwrt_image" {
  provisioner "local-exec" {
    command = "gzip -q -d ${path.module}/openwrt-24.10.1-x86-64-generic-squashfs-combined-efi.img.gz 2>/dev/null || true"
  }
  depends_on = [null_resource.openwrt_image_download]
}

// Image upload
resource "proxmox_virtual_environment_file" "openwrt_image_upload" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "axis"
  source_file {
    path = "${path.module}/openwrt-24.10.1-x86-64-generic-squashfs-combined-efi.img"
  }
  depends_on = [null_resource.unzip_openwrt_image]
}



// Cloud-init user-data
#resource "local_file" "" {
#  content = <<EOT
#	      EOT
#  filename = "${path.module}/"
#  file_permission = 777
#}

// Cloud-init meta-data
#resource "local_file" "" {
#  content = ""
#  filename = "${path.module}/"
#  file_permission = 777
#}

// Openwrt Virtual Machine
resource "proxmox_virtual_environment_vm" "openwrt_vm" {
  name        = "openwrt"
  description = "Managed by Terraform"
  tags        = ["Terraform", "OpenWRT"]

  node_name = "axis"
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

  #cdrom {
  #  file_id = proxmox_virtual_environment_file.vyos_custom_iso_upload.id
  #}

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
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  serial_device {

  }
  depends_on = [proxmox_virtual_environment_file.openwrt_image_upload]
}
