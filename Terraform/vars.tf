//vms.tf
variable "access" {
  type = map(string)
  default = {
   endpoint = ""
    address = ""
    port = ""
    username = ""
    password = ""
  }
}
