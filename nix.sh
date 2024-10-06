#!/bin/bash

set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Nix
install_nix() {
    echo "Installing Nix..."
    if command_exists nix; then
        echo "Nix is already installed."
    else
        sh <(curl -L https://nixos.org/nix/install) --daemon
        # Source nix
        . ~/.nix-profile/etc/profile.d/nix.sh
    fi
}

# Install Ansible using Nix
install_ansible_with_nix() {
    echo "Installing Ansible using Nix..."
    nix-env -iA nixpkgs.ansible
}

# Main execution
main() {
    install_nix
    install_ansible_with_nix
    
    # Verify installation
    if command_exists ansible; then
        echo "Ansible has been successfully installed using Nix."
        ansible --version
    else
        echo "Ansible installation failed."
        exit 1
    fi
}

# Run the main function
main
