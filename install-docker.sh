#!/bin/bash
#
# This bash script is used to download and configure docker on Linux
#
# Author: Cavoq
#
# Usage: sudo ./docker.sh

update_system() {
    echo "Updating system..."
    if ! sudo apt update; then
        echo "Failed to update system..."
        exit 1
    fi
    echo "System updated successfully..."
}

install_deps() {
    echo "Installing dependencies..."
    if ! sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release; then
        echo "Failed to install dependencies..."
        exit 1
    fi
    echo "Dependencies installed successfully..."
}

add_gpg_key() {
    echo "Adding Docker's official GPG key..."
    if ! curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg; then
        echo "Failed to add Docker's official GPG key..."
        exit 1
    fi
    echo "Docker's official GPG key added successfully..."
}

setup_repo() {
    echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

check_docker_installed() {
    if ! command -v docker &> /dev/null; then
        return 1
    fi
    return 0
}

install_docker() {
    echo "Installing Docker..."
    if ! sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y; then
        echo "Failed to install docker..."
        exit 1
    fi
    echo "Docker installed successfully..."
}

configure_docker() {
    echo "Configuring Docker..."
    if ! sudo usermod -aG docker "$USER"; then
        echo "Failed to add user to the 'docker' group..."
        exit 1
    fi
    echo "Docker configured successfully..."
}

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root..."
    exit 1
fi

echo "Starting Docker installation and configuration..."

if check_docker_installed; then
    echo "Docker is already installed on this system..."
    exit 0
fi

update_system
install_deps
add_gpg_key
setup_repo
install_docker
configure_docker

echo "Docker installation and configuration completed successfully..."
