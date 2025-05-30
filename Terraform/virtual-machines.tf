// Ubuntu Image Upload
resource "proxmox_virtual_environment_download_file" "latest_ubuntu_24_noble_qcow2_img" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = data.proxmox_virtual_environment_node.node.node_name
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

#// Bastion Virtual Machine
#module "bastion_virtual_machine" {
#  source = "./modules/proxmox-vm"  
#  vm_name     = "Bastion"
#  vm_tags     = ["Terraform", "Ubuntu", "Bastion"]
#  node_name   = data.proxmox_virtual_environment_node.node.node_name
#  vm_id       = 1010
#  disk_file_id = proxmox_virtual_environment_download_file.latest_ubuntu_24_noble_qcow2_img.id
#  password    = "changemepls"
#  ssh-key = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1UYC+NU9ck8UO3p3VCpxCMiR8hax7UG1AYJuX6kztoR1q9D4GpBxM42Yu2A4WsKeEz9nBt7SyKSWuToykbYzL5hZTGL0clSQhfb0GbcmYJSniqEefFKb6xagpggZvfeMj0iMCv5aHQ17oGwcT3PaiSqjyDPsanIPBDqaoC+YRtot1LPnX9EvCcRp/s9cg0Sh7eBp+4bBv0CxXt0dCpUNNxEROSp1nyTK6PcpFXxhfvrbWuiL2ROIOM+qWjRzWZUHFuouYzdaQTtAJz9+SO+crQldTTToJpslYdrv+ehU0b+dVko3M2YDoMtUD9J7yaksijvPFviWpN8N2Dg6VQ4N/9hoC9q07pO8Ii0D/0HPjyGArv2zEJBFQsAukvFtiWix2HADjXEcd+rtJGJ9od7se1uJUFawmXRJbdmNPlfMeZ6IEd7tlKTCs00/DJ0jl/oY8Tqpp5+WnexiH0OgXmRT5psV0epeQeYWgkQs202LirpKhaocPD7IviRihRfdJcSpItU0LWz4YaSl/RDZyii9wpArv4B7F4Hz5rILo2enzLxDaY9Rzn7MxdS/pVD+MkyQaCzbrVcbu/o8D1xjKaI+Syc1R2uT5N2oZLN4SLX5DBj3QFbe/cvIYkauHVoI/KovNw6teYp2HNS06lhAVuhktj5nmSNmwBk/YidgGZC3Zsw=="]
#}

// Router Virtual Machine
module "router_virtual_machine" {
  source = "./modules/proxmox-vm"  
  vm_name     = "Router"
  vm_tags     = ["Terraform", "Ubuntu", "Router"]
  node_name   = data.proxmox_virtual_environment_node.node.node_name
  vm_id       = 9000
  disk_file_id = proxmox_virtual_environment_download_file.latest_ubuntu_24_noble_qcow2_img.id
  password    = "changemepls"
  ssh-key = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1UYC+NU9ck8UO3p3VCpxCMiR8hax7UG1AYJuX6kztoR1q9D4GpBxM42Yu2A4WsKeEz9nBt7SyKSWuToykbYzL5hZTGL0clSQhfb0GbcmYJSniqEefFKb6xagpggZvfeMj0iMCv5aHQ17oGwcT3PaiSqjyDPsanIPBDqaoC+YRtot1LPnX9EvCcRp/s9cg0Sh7eBp+4bBv0CxXt0dCpUNNxEROSp1nyTK6PcpFXxhfvrbWuiL2ROIOM+qWjRzWZUHFuouYzdaQTtAJz9+SO+crQldTTToJpslYdrv+ehU0b+dVko3M2YDoMtUD9J7yaksijvPFviWpN8N2Dg6VQ4N/9hoC9q07pO8Ii0D/0HPjyGArv2zEJBFQsAukvFtiWix2HADjXEcd+rtJGJ9od7se1uJUFawmXRJbdmNPlfMeZ6IEd7tlKTCs00/DJ0jl/oY8Tqpp5+WnexiH0OgXmRT5psV0epeQeYWgkQs202LirpKhaocPD7IviRihRfdJcSpItU0LWz4YaSl/RDZyii9wpArv4B7F4Hz5rILo2enzLxDaY9Rzn7MxdS/pVD+MkyQaCzbrVcbu/o8D1xjKaI+Syc1R2uT5N2oZLN4SLX5DBj3QFbe/cvIYkauHVoI/KovNw6teYp2HNS06lhAVuhktj5nmSNmwBk/YidgGZC3Zsw=="]
  host_pci_device =  {
    device = "hostpci1"
    id = "03:00.0"
  }
}
