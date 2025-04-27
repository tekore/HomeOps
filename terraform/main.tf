terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.76.1"
    }
  }
}

provider "proxmox" {
  insecure = true
  ssh {
    node {
      name    = "axis"
      address = var.PROXMOX_ADDRESS
      port = var.PROXMOX_SSH_PORT
    }
    agent = true
  }
}
