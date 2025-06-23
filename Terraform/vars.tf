//main.tf
variable "axis-access" {
  type = object({
    endpoint = string
    address = string
    port = string
    username = string
    password = string
  })
  sensitive = true
}

variable "passwords" {
  type = object({
    tekore = string
    valraevn = string
  })
  sensitive = true
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
    internalgateway = string
    routerwan = string
    routerlan1 = string
    bastion = string
  })
}

variable "pci-devices" {
  type = object({
    router = string
  })
}

variable "cloudinit" {
  type = object({
    timezone = string
    passwordhash = string
    valraevnpasswordhash = string
    sshkey = string
    sshkey2 = string
    desktopsoftware = string
  })
  sensitive = true
}