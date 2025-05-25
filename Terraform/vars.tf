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
