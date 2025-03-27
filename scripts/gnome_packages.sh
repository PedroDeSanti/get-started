#!/usr/bin/env bash

gnome_packages=(
    gnome-shell
    gnome-tweaks
    gnome-shell-extensions
    chrome-gnome-shell
    dconf-editor
    dconf-cli
)

# @Brief: Installs GNOME packages
install_gnome_packages() {
    show_message "Installing GNOME packages..."
    
    apt_install "${gnome_packages[@]}" || return

    flatpak_install com.mattjakeman.ExtensionManager || return

    log_success "GNOME packages installed"
}