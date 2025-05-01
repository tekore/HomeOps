#!/bin/bash

# Exit on error
set -e

# Install required packages
apt-get update
apt-get install -y ansible git

# Create ansible-pull directory if it doesn't exist
mkdir -p /opt/ansible-pull

ansible-pull -U https://github.com/tekore/Ansible.git roles/microk8s/mk8s.yml

# Run ansible-pull to fetch and apply configuration
#ansible-pull -U https://github.com/YOUR_GITHUB_USERNAME/YOUR_ANSIBLE_REPO.git -d /opt/ansible-pull --purge -i localhost, playbook.yml