# Ansible Automation Project

This repository contains Ansible playbooks and scripts for automating various system administration tasks. Our goal is to simplify the process of setting up and maintaining consistent environments across multiple machines.

## Table of Contents

- [Ansible Automation Project](#ansible-automation-project)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Quick Start](#quick-start)
  - [Available Playbooks](#available-playbooks)
    - [wg.yml](#wgyml)
    - [docker.yml](#dockeryml)
    - [wg\_dashboard.yml](#wg_dashboardyml)
    - [wg\_dashboard\_with\_wg.yml](#wg_dashboard_with_wgyml)
    - [udp2raw\_tunnel.yml](#udp2raw_tunnelyml)
  - [Usage](#usage)
    - [Setting Up Inventory](#setting-up-inventory)
    - [Running Playbooks](#running-playbooks)
    - [One-line Remote Execution](#one-line-remote-execution)
  - [Contributing](#contributing)
  - [Support](#support)

## Prerequisites

Before using these playbooks, ensure you have:

- Basic understanding of Ansible and YAML
- SSH access to target machines (for remote execution)
- Sudo privileges on target machines

## Quick Start

To quickly set up Nix and Ansible on your system, use this one-liner:

```bash
curl -sSL https://raw.githubusercontent.com/reloadlife/ansible/main/nix_ansible.sh | bash
```

This command downloads and executes our setup script, which installs Nix and Ansible. Always review the script content before running it on your system.

## Available Playbooks

Here's a list of available playbooks and their purposes:

### wg.yml

- **Purpose**: Installs and configures WireGuard VPN
- **Supported OS**: Ubuntu, Debian, CentOS, RHEL, Fedora
- **Usage**: `ansible-playbook wg.yml`
- **One-liner**:
  ```bash
  ansible-playbook -b https://raw.githubusercontent.com/reloadlife/ansible/main/wg.yml
  ```

### docker.yml

- **Purpose**: Installs Docker and sets up basic configurations
- **Supported OS**: Ubuntu, Debian, CentOS, RHEL, Fedora, macOS
- **Usage**: `ansible-playbook docker.yml`
- **One-liner**:
  ```bash
  ansible-playbook -b https://raw.githubusercontent.com/reloadlife/ansible/main/docker.yml
  ```

### wg_dashboard.yml

- **REQUIREMENT**: Download the template file:
  ```bash
  curl https://raw.githubusercontent.com/reloadlife/ansible/main/wg-dashboard.ini.j2 -o ~/.ansible/templates/wg-dashboard.ini.j2
  ```
- **Purpose**: Installs [WireGuard Dashboard](https://github.com/donaldzou/WGDashboard)
- **Supported OS**: Ubuntu, Debian, CentOS, RHEL, Fedora, macOS
- **Usage**: `ansible-playbook wg_dashboard.yml`
- **One-liner**:
  ```bash
  ansible-playbook -b https://raw.githubusercontent.com/reloadlife/ansible/main/wg_dashboard.yml
  ```

### wg_dashboard_with_wg.yml

- **REQUIREMENT**: Download the template file:
  ```bash
  curl https://raw.githubusercontent.com/reloadlife/ansible/main/wg-dashboard.ini.j2 -o ~/.ansible/templates/wg-dashboard.ini.j2
  ```
- **Purpose**: Installs [WireGuard Dashboard](https://github.com/donaldzou/WGDashboard) bundled with WireGuard
- **Supported OS**: Ubuntu, Debian, CentOS, RHEL, Fedora, macOS
- **Usage**: `ansible-playbook wg_dashboard_with_wg.yml`
- **One-liner**:
  ```bash
  ansible-playbook -b https://raw.githubusercontent.com/reloadlife/ansible/main/wg_dashboard_with_wg.yml
  ```
- **Example with custom port**:
  ```bash
  ansible-playbook -b -e "{'dashboard_port':9090}" https://raw.githubusercontent.com/reloadlife/ansible/main/wg_dashboard_with_wg.yml
  ```

### udp2raw_tunnel.yml

- **Purpose**: Sets up a UDP2RAW ICMP tunnel over a 4to6 tunnel between two servers
- **Supported OS**: Ubuntu, Debian (may work on other Linux distributions with minimal modifications)
- **Usage**: `ansible-playbook udp2raw_tunnel.yml`
- **One-liner**:
  ```bash
  ansible-playbook -i inventory.ini udp2raw_tunnel.yml
  ```
- **Example with custom IPs**:
  ```bash
  ansible-playbook -i inventory.ini udp2raw_tunnel.yml -e "server1_ipv4=3.3.3.3 server2_ipv4=4.4.4.4"
  ```

## Usage

### Setting Up Inventory

1. Create an inventory file named `inventory.ini` in the project root.
2. Add your target hosts:
   ```ini
   [servers]
   server1 ansible_host=192.168.1.10
   server2 ansible_host=192.168.1.11
   ```
3. If you're only managing your local machine, you can skip this step.

### Running Playbooks

To run a playbook on your inventory:

```bash
ansible-playbook -i inventory.ini <playbook_name>.yml
```

For example, to install Docker:

```bash
ansible-playbook -i inventory.ini docker.yml
```

### One-line Remote Execution

You can also run these playbooks directly without cloning the repository:

```bash
# Install WireGuard
ansible-playbook -i "localhost," -c local -b https://raw.githubusercontent.com/reloadlife/ansible/main/wg.yml

# Install Docker
ansible-playbook -i "localhost," -c local -b https://raw.githubusercontent.com/reloadlife/ansible/main/docker.yml

# Set up UDP2RAW tunnel
ansible-playbook -i inventory.ini https://raw.githubusercontent.com/reloadlife/ansible/main/udp2raw_tunnel.yml
```

## Contributing

We welcome contributions! Here's how you can contribute:

1. Fork the repository
2. Create a new branch for your feature
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

When adding a new playbook:

1. Create your playbook (e.g., `new_feature.yml`)
2. Update this README following the template in the [Available Playbooks](#available-playbooks) section
3. Test your playbook thoroughly
4. Submit a pull request with your changes

## Support

If you encounter any issues or have questions:

1. Check the existing issues in the repository
2. If your issue isn't already listed, create a new issue with a detailed description

---

Remember to always review playbooks and scripts before running them, especially from public repositories. Test in a safe environment before applying to production systems.
