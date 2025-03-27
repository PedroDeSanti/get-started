#!/usr/bin/env bash

basic_packages=(
    build-essential
    cmake
    python3
    python3-pip
    python-is-python3
    git
    uncrustify
    curl
    libusb-1.0-0-dev
    xclip
    neofetch
    cmatrix
    snapd
    zip
    unzip
    gdb-multiarch
    vim
    openocd
    bat
    eza
    tree
    fzf
    fd-find
    btop
    stlink-tools
    gcc-arm-none-eabi
    flatpak
    nala
    tldr
    thunar
    ripgrep
    wget
    htop
)

_install_zoxide() {
    show_message "Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash >> "$LOG_FILE" 2>&1 || {
        log_error "Failed to install zoxide"
    }
}

_install_eza() {
    show_message "Installing eza..."
    
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >> "$LOG_FILE" 2>&1
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list

    apt_update && apt_install eza || return   
}

install_basic_packages() {
    show_message "Installing basic packages..."
    
    apt_install "${basic_packages[@]}" || return
    _install_zoxide
    _install_eza

    flatpak_remote_add https://dl.flathub.org/repo/flathub.flatpakrepo

    log_success "Basic packages installed"
}