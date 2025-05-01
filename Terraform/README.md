![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

## Terraform Automation
Terraform files for virtual resource configuration 


## Instalation notes
The OpenWRT image sets the LAN interface with a default ip of 192.168.1.1, this is a common IP for most home network routers so will conflict with the existing router. If this is the case, either create a custom OpenWRT image or enter the OpenWRT console and manually change the IP (/etc/config/network). This needs to be resolved before the ansible configuration.


## Maintainers
[@Tekore](https://github.com/tekore)
