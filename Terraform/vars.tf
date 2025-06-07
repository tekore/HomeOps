//main.tf
variable "axis-access" {
  type = map(string)
  default = {
   endpoint = ""
    address = ""
    port = ""
    username = ""
    password = ""
  }
}

variable "mac-addresses" {
  type = map(string)
  default = {
    router-wan = ""
    router-lan1 = ""
  }
}

variable "ip-addresses" {
  type = map(string)
  default = {
    gateway = ""
    router-wan = ""
    router-lan1 = ""
  }
}

variable "pci-devices" {
  type = map(string)
  default = {
    router = ""
  }
}

variable "cloud-init" {
  type = map(string)
  default = {
    hostname = ""
    timezone = ""
    password-hash = ""
    ssh-key = ""
  }
}