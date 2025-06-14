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
  description = "Virtual machine tags"
  type        = list(string)
  default     = ["Terraform"]
}

variable "node_name" {
  description = "Proxmox node"
  type        = string
}

variable "vm_id" {
  description = "VM ID"
  type        = number
}

variable "host_pci_device" {
  description = "PCI device"
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
  description = "Stop on destroy"
  type        = bool
  default     = true
}

variable "startup_order" {
  description = "Startup order"
  type        = string
  default     = "3"
}

variable "startup_up_delay" {
  description = "Delay before starting VM"
  type        = string
  default     = "1"
}

variable "startup_down_delay" {
  description = "Delay before stopping VM"
  type        = string
  default     = "1"
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "cpu_type" {
  description = "CPU type"
  type        = string
  default     = "x86-64-v2-AES"
}

variable "memory_dedicated" {
  description = "Dedicated RAM in MB"
  type        = number
  default     = 2048
}

variable "memory_floating" {
  description = "Floating RAM in MB (for balooning)"
  type        = number
  default     = 0
}

variable "datastore_id" {
  description = "Datastore ID"
  type        = string
  default     = "local-zfs"
}

variable "disk_file_id" {
  description = "File ID for disk"
  type        = string
}

variable "disk_interface" {
  description = "Disk interface type"
  type        = string
  default     = "scsi0"
}

variable "disk_size" {
  description = "Disk size"
  type        = string
  default     = "10"
}

variable "network_bridge" {
  description = "Virtual machine network"
  type        = string
  default     = "vmbr0"
}

variable "mac_address" {
  description = "Mac address for the LAN interface"
  type        = string
  default = null
}

variable "os_type" {
  description = "OS type"
  type        = string
  default     = "l26"
}

variable "user_data" {
  description = "user_data file for cloudinit"
  type        = string
}

variable "network_data" {
  description = "network_data file for cloudinit"
  type        = string
}
