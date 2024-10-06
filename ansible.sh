#!/bin/bash

set -e

install_ansible_debian() {
    echo "Updating package lists..."
    sudo apt update
    echo "Installing Ansible..."
    sudo apt install -y ansible
}

install_ansible_redhat() {
    echo "Installing EPEL repository..."
    sudo yum install -y epel-release
    echo "Installing Ansible..."
    sudo yum install -y ansible
}

install_ansible_macos() {
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo "Installing Ansible using Homebrew..."
    brew install ansible
}

install_ansible_pip() {
    echo "Installing Ansible using pip..."
    pip install ansible
}

# Detect the operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
            install_ansible_debian
        elif [[ "$ID" == "centos" || "$ID" == "rhel" || "$ID" == "fedora" ]]; then
            install_ansible_redhat
        else
            echo "Unsupported Linux distribution. Trying to install with pip..."
            install_ansible_pip
        fi
    else
        echo "Unable to determine Linux distribution. Trying to install with pip..."
        install_ansible_pip
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_ansible_macos
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

# Verify installation
if command -v ansible &> /dev/null; then
    echo "Ansible has been successfully installed."
    ansible --version
else
    echo "Ansible installation failed."
    exit 1
fi
