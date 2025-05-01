#!/bin/bash

# Exit on error
set -e

# Remove the enterprise repositories
rm -f /etc/apt/sources.list.d/*list

# Install required packages
apt-get update
apt-get install -y ansible git

# Create ansible-pull directory if it doesn't exist
mkdir -p /opt/ansible-pull

ansible-pull -U https://github.com/tekore/HomeOps.git -d /opt/ansible-pull --purge Ansible/Configure_Runner.yml
