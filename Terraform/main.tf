terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.76.1"
    }
  }
}

provider "proxmox" {
  endpoint = var.axis-access.endpoint
  username = var.axis-access.username
  password = var.axis-access.password
  insecure = true
  ssh {
    node {
      name    = "axis"
      address = var.axis-access.address
      port = var.axis-access.port      
    }
    agent = true
  }
}

data "proxmox_virtual_environment_node" "node" {
  node_name = "axis"
}
