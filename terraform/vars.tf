variable "PROXMOX_ADDRESS" {
   description = "SSH Address for Proxmox Node"
   type        = string
   sensitive   = true
}

variable "PROXMOX_SSH_PORT" {
   description = "SSH port for Proxmox Node"
   type        = string
   sensitive   = true
}
