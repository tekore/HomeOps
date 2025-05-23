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

variable "openwrt-inject-files" {
  type        = map(string)
  description = "Files to inject into the OpenWRT Image"
}
