terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.76.1"
    }
  }
}

provider "proxmox" {
  endpoint = var.access.endpoint
  username = var.access.username
  password = var.access.password
  insecure = true
  ssh {
    node {
      name    = "axis"
      address = var.access.address
      port = var.access.port      
    }
    agent = true
  }
}

data "proxmox_virtual_environment_node" "node" {
  node_name = "axis"
}
