#!/bin/bash

set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect the operating system
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        OS=$DISTRIB_ID
    elif [ -f /etc/debian_version ]; then
        OS=Debian
    else
        OS=$(uname -s)
    fi
}

# Install Nix
install_nix() {
    echo "Installing Nix..."
    if command_exists nix; then
        echo "Nix is already installed."
    else
        sh <(curl -L https://nixos.org/nix/install) --daemon
        
        # Source nix
        if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
            . ~/.nix-profile/etc/profile.d/nix.sh
        elif [ -e /etc/profile.d/nix.sh ]; then
            . /etc/profile.d/nix.sh
        fi
        
        # Add Nix to shell configuration
        if [ -f ~/.bashrc ]; then
            echo '. ~/.nix-profile/etc/profile.d/nix.sh' >> ~/.bashrc
        fi
        if [ -f ~/.bash_profile ]; then
            echo '. ~/.nix-profile/etc/profile.d/nix.sh' >> ~/.bash_profile
        fi
        if [ -f ~/.zshrc ]; then
            echo '. ~/.nix-profile/etc/profile.d/nix.sh' >> ~/.zshrc
        fi
    fi
}

# Install Ansible using Nix
install_ansible_with_nix() {
    echo "Installing Ansible using Nix..."
    nix-env -iA nixpkgs.ansible
    nix-env -iA nixpkgs.python3Packages.pip
}

# Install additional Ansible requirements
install_ansible_requirements() {
    echo "Installing Ansible requirements..."
    pip3 install --user ansible-core
    ansible-galaxy collection install community.general
}

# Set up Ansible configuration
setup_ansible_config() {
    echo "Setting up Ansible configuration..."
    mkdir -p ~/.ansible
    cat <<EOF > ~/.ansible/ansible.cfg
[defaults]
inventory = ~/.ansible/hosts
remote_user = $(whoami)
host_key_checking = False

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False
EOF

    echo "Creating a sample inventory file..."
    cat <<EOF > ~/.ansible/hosts
[local]
localhost ansible_connection=local

[servers]
# Add your server IP addresses or hostnames here
# example_server ansible_host=192.168.1.10
EOF
}

# Main execution
main() {
    detect_os
    echo "Detected OS: $OS"
    
    install_nix
    install_ansible_with_nix
    install_ansible_requirements
    setup_ansible_config
    
    # Verify installations
    if command_exists nix; then
        echo "Nix has been successfully installed."
        nix --version
    else
        echo "Nix installation failed."
        exit 1
    fi

    if command_exists ansible; then
        echo "Ansible has been successfully installed."
        ansible --version
    else
        echo "Ansible installation failed."
        exit 1
    fi

    echo "Installation complete. Please log out and log back in, or source your shell configuration file to use Nix and Ansible."
    echo "Don't forget to edit ~/.ansible/hosts to add your target servers."
}

# Run the main function
main
