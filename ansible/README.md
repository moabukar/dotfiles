# Ansible Server Setup

Automated server configuration for DevOps environments.

## Quick Start

```bash
# Install Ansible (if not already installed)
brew install ansible

# Test connection
ansible all -i inventories/production.yml -m ping

# Run full setup
ansible-playbook -i inventories/production.yml playbook.yml

# Run specific roles
ansible-playbook -i inventories/production.yml playbook.yml --tags docker
ansible-playbook -i inventories/production.yml playbook.yml --tags k8s
```

## What Gets Configured

- ✅ System updates and security
- ✅ Essential packages
- ✅ Docker & Docker Compose
- ✅ Kubernetes tools (kubectl, helm, k9s)
- ✅ Monitoring (node_exporter, promtail)
- ✅ UFW firewall
- ✅ Fail2ban
- ✅ User setup with sudo
- ✅ SSH hardening
- ✅ Swap configuration
- ✅ Timezone & NTP

## Inventory

Edit `inventories/production.yml` to add your servers:

```yaml
all:
  hosts:
    server1:
      ansible_host: 192.168.1.10
    server2:
      ansible_host: 192.168.1.11
  vars:
    ansible_user: ubuntu
    ansible_ssh_private_key_file: ~/.ssh/id_ed25519
```

## Variables

Edit `group_vars/all.yml` to customize:
- User accounts
- SSH ports
- Firewall rules
- Tool versions

## Tags

Run specific parts:
```bash
--tags system      # System setup only
--tags security    # Security hardening
--tags docker      # Docker installation
--tags k8s         # Kubernetes tools
--tags monitoring  # Monitoring setup
```

## Testing

Test in a local VM:
```bash
# Using multipass
multipass launch --name test-server ubuntu
ansible-playbook -i inventories/test.yml playbook.yml --check --diff
```
