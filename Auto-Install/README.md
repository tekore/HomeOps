## Proxmox Auto Install (with a GitHub Actions runner install)

## Contents
- [Prerequisites](##Prerequisits)

## Prerequisites
- You have two USB drives (one of atleast 8GB in capacity)
- A Linux host you can use to create the bootable USB (Commands may vary slightly if you're not using Ubuntu 24.04)

## How-To
1. Add the repo for the 'proxmox-auto-install-assistant' tool (if applicable)
```sh
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
```

2. Install the package 'proxmox-auto-install-assistant'
```sh
sudo apt install proxmox-auto-install-assistant -y 
```

3. Customise the answer.toml file values (Change the url unless you want to use my script)
[answer.toml](https://github.com/tekore/HomeOps/blob/main/Auto-Install/answer.toml)

4. Customise the variables in the first-boot-script.sh file (Change ANSIBLE_REPO_URL and ANSIBLE_REPO_PLAYBOOK unless you want to use my playbook)
[first-boot-script.sh](https://github.com/tekore/HomeOps/blob/main/Auto-Install/first-boot-script.sh)

5. Validate your answer.toml file
```sh
proxmox-auto-install-assistant validate-answer answer.toml
```

6. Download the Proxmox-VE_8 ISO
[Proxmox_Download](https://enterprise.proxmox.com/iso/proxmox-ve_8.4-1.iso)

7. Build your custom ISO
```sh
proxmox-auto-install-assistant prepare-iso ./proxmox-ve*.iso --fetch-from iso --answer-file ./answer.toml
```

8. Now burn the newly created ISO image to a USB (using a tool such as 'balenaEtcher')
[balenaEtcher_Download](https://etcher.balena.io/#download-etcher)

#### (If you don't want to install a GitHub Actions runner you can stop at this stage, just boot from the aforementioned USB)
9. Customise the runner_secrets.yml and copy it onto the second USB
[runner_secrets_example.yml](https://github.com/tekore/HomeOps/blob/main/Auto-Install/runner_secrets_example.yml)
###### Note: The GitHub runner token expires within one hour

10. Plug both USB drives into the server and boot from the one used in step 8.\
Once the install is complete, remove the boot USB (as you will be prompted to do so) but leave the second USB plugged in.