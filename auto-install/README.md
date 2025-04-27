## Proxmox Auto Install

## Contents
- [Prerequisites](#Prerequisits)
- [How-To](#How-To)

## Prerequisites
- You have a USB of atleast 8GB in size
- A Linux host you can plug the formentioned USB into (Commands may vary slightly if not Ubuntu 24.04)

## How-To
1. Add the repo for the 'proxmox-auto-install-assistant' tool (if applicable)
```sh
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
```

2. Install the package 'proxmox-auto-install-assistant'
```sh
sudo apt install proxmox-auto-install-assistant -y 
```

3. Customise your answer.toml file
[answers.toml](https://github.com/tekore/HomeOps/tree/main/auto-install/answers.toml)

4. Validate your answer.toml file
```sh
proxmox-auto-install-assistant validate-answer answer.toml
```

5. Download the Proxmox-VE ISO
[Proxmox_Download](https://www.proxmox.com/en/downloads)

6. Build your custom ISO
```sh
proxmox-auto-install-assistant prepare-iso ./proxmox-ve*.iso --fetch-from iso --answer-file ./answer.toml
```

7. Now burn the newly created ISO image to a USB (using a tool such as 'balenaEtcher') and boot from it.
