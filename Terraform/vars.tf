//main.tf
variable "axis-access" {
  type = object({
    endpoint = string
    address = string
    port = string
    username = string
    password = string
  })
}

variable "macaddresses" {
  type = object({
    routerwan = string
    routerlan1 = string
  })
}

variable "ipaddresses" {
  type = object({
    gateway = string
    routerwan = string
    routerlan1 = string
  })
}

variable "pci-devices" {
  type = object({
    router = string
  })
}

variable "cloudinit" {
  type = object({
    hostname = string
    timezone = string
    passwordhash = string
    sshkey = string
  })
}