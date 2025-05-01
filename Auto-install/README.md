## Proxmox Auto Install

## Contents
- [Prerequisites](#Prerequisits)
- [How-To](#How-To)

## Prerequisites
- You have a USB of atleast 8GB in size
- A Linux host you can use to create the USB (Commands may vary slightly if not Ubuntu 24.04)

## How-To
1. Add the repo for the 'proxmox-auto-install-assistant' tool (if applicable)
```sh
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
```

2. Install the package 'proxmox-auto-install-assistant'
```sh
sudo apt install proxmox-auto-install-assistant -y 
```

3. Customise the answer.toml file
[answer.toml](https://github.com/tekore/HomeOps/blob/main/auto-install/answer.toml)

4. Customise the first-boot-script.sh file
[first-boot-script.sh](https://github.com/tekore/HomeOps/blob/main/auto-install/first-boot-script.sh)

5. Validate your answer.toml file
```sh
proxmox-auto-install-assistant validate-answer answer.toml
```

6. Download the Proxmox-VE ISO
[Proxmox_Download](https://www.proxmox.com/en/downloads)

7. Build your custom ISO
```sh
proxmox-auto-install-assistant prepare-iso ./proxmox-ve*.iso --fetch-from iso --answer-file ./answer.toml --on-first-boot ./first-boot-script.sh
```

8. Now burn the newly created ISO image to a USB (using a tool such as 'balenaEtcher') and boot from it.
