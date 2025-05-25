variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "vm_description" {
  description = "Description of the virtual machine"
  type        = string
  default     = "Managed by Terraform"
}

variable "vm_tags" {
  description = "Tags to apply to the virtual machine"
  type        = list(string)
  default     = ["Terraform"]
}

variable "node_name" {
  description = "Proxmox node name where the VM will be created"
  type        = string
}

variable "vm_id" {
  description = "VM ID number"
  type        = number
}

variable "host_pci_device" {
  description = "PCI device to pass through"
  type = object({
    device  = string
    id = string
    mapping = optional(string)
    mdev    = optional(string)
    pcie    = optional(bool)
    rombar  = optional(bool)
    rom_file = optional(string)
    xvga    = optional(bool)
  })
  default = null
}

variable "agent_enabled" {
  description = "Enable QEMU guest agent"
  type        = bool
  default     = false
}

variable "stop_on_destroy" {
  description = "Stop VM on destroy"
  type        = bool
  default     = true
}

variable "startup_order" {
  description = "VM startup order"
  type        = string
  default     = "3"
}

variable "startup_up_delay" {
  description = "Delay before starting VM"
  type        = string
  default     = "10"
}

variable "startup_down_delay" {
  description = "Delay before stopping VM"
  type        = string
  default     = "10"
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 6
}

variable "cpu_type" {
  description = "CPU type"
  type        = string
  default     = "x86-64-v2-AES"
}

variable "memory_dedicated" {
  description = "Dedicated memory in MB"
  type        = number
  default     = 2048
}

variable "memory_floating" {
  description = "Floating memory in MB"
  type        = number
  default     = 2048
}

variable "datastore_id" {
  description = "Datastore ID for VM disk and initialization"
  type        = string
  default     = "local-zfs"
}

variable "disk_file_id" {
  description = "File ID for the VM disk image"
  type        = string
}

variable "disk_interface" {
  description = "Disk interface type"
  type        = string
  default     = "scsi0"
}

variable "ip_address" {
  description = "IP address configuration (use 'dhcp' for DHCP)"
  type        = string
  default     = "dhcp"
}

variable "username" {
  description = "Username for the VM user account"
  type        = string
  default     = "ubuntu"
}

variable "password" {
  description = "Password for the VM user account"
  type        = string
  sensitive   = true
}

variable "network_bridge" {
  description = "Network bridge for VM"
  type        = string
  default     = "vmbr0"
}

variable "os_type" {
  description = "Operating system type"
  type        = string
  default     = "l26"
}