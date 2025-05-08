![Proxmox](https://img.shields.io/badge/proxmox-proxmox?style=for-the-badge&logo=proxmox&logoColor=%23E57000&labelColor=%232b2a33&color=%232b2a33) ![Bash Script](https://img.shields.io/badge/bash_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white) ![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white) ![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white) ![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white) ![Openwrt](https://img.shields.io/badge/OpenWRT-00B5E2?style=for-the-badge&logo=OpenWrt&logoColor=white) ![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white) ![Unraid](https://img.shields.io/badge/unraid-%23F15A2C.svg?style=for-the-badge&logo=unraid&logoColor=white)

# All-In-One Home Server Automation
Here you'll find automation from the baremetal proxmox install to the Kubernetes ConfigMaps.

## Goal
To automate the installation and configuration of my home infrastructure. This is a complete solution, from a blank bare metal state to a fully function Proxmox install including self hosted GitHub Actions runners, Kubernetes clusters, OpenWRT routers and more. The only manual step is plugging the two USB drives into the target server.
## Components
- [Auto-Install](https://github.com/tekore/HomeOps/tree/main/Auto-Install)
- [Ansible](https://github.com/tekore/HomeOps/tree/main/Ansible)
- [Terraform](https://github.com/tekore/HomeOps/tree/main/Terraform)

## Technical Overview
```mermaid
graph TD;
    Boot-From-USB-->Proxmox-Installs;
    Proxmox-Installs-->Firstboot-Script-runs;
    Firstboot-Script-runs-->GitHub-Actions-VM-Created;
    GitHub-Actions-VM-Created-->Actions-VM-Pulls-Playbook;
    Actions-VM-Pulls-Playbook-->Actions-Container-installed;
    Actions-Container-installed-->Container-self-registers;
    Container-self-registers-->Pipeline-triggered;
    Pipeline-triggered-->Terraform-Build;
    Terraform-Build-->VMs-Ansible-Pull;
```

## Common Pitfalls
- When installing the GitHub runner, if the GitHub token is more than an hour old it will be expired. This will prevent the container from registering itself with GitHub. To 're-do' this step, update the file on the GitHub runner Virtual machine in '/tmp/runner_secrets.yml', killoff the old container and then pull the playbook again
```sh
docker stop github-runner
docker rm github-runner
ansible-pull -U $ANSIBLE_REPO_URL -i localhost --purge $ANSIBLE_REPO_PLAYBOOK --extra-vars "@/tmp/runner_secrets.yml"
```
###### Note: These variables are defined in the first-boot-script.sh, for me the values are "https://github.com/tekore/HomeOps.git" and "Ansible/configure-runner.yml"

## Maintainers
[@Tekore](https://github.com/tekore)
