// tekore
resource "proxmox_virtual_environment_user" "tekore" {
  comment  = "Managed by Terraform"
  password = var.passwords.tekore
  user_id  = "tekore@pve"
  lifecycle {
    ignore_changes = [acl]
  }
}

resource "proxmox_virtual_environment_acl" "tekore_acl" {
  user_id = proxmox_virtual_environment_user.tekore.user_id
  role_id = "PVEAdmin"
  path      = "/"
  propagate = true
  depends_on = [ proxmox_virtual_environment_user.tekore ]
}

// valraevn
resource "proxmox_virtual_environment_user" "valraevn" {
  comment  = "Managed by Terraform"
  password = var.passwords.valraevn
  user_id  = "valraevn@pve"
  lifecycle {
    ignore_changes = [acl]
  }
}

resource "proxmox_virtual_environment_acl" "valraevn_acl" {
  user_id = proxmox_virtual_environment_user.valraevn.user_id
  role_id = "PVEAdmin"
  path      = "/"
  propagate = true
  depends_on = [ proxmox_virtual_environment_user.valraevn ]
}