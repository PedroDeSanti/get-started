#!/usr/bin/env bash

# File: install.sh
# Brief: This script installs basic packages and configures the system
# Author: Pedro De Santi
# Date: 09/2024
# Version: 2.0

readonly REPO_URL="https://raw.githubusercontent.com/PedroDeSanti/get-started/refs/heads/newscript/scripts/"
readonly TMP_DIR=$(mktemp -d)

# Exit immediately if a command exits with a non-zero status
set -euo pipefail 

# Cleanup function
cleanup() {
    rm -rf "$TEMP_DIR"
    if [[ $ERROR_COUNT -eq 0 ]]; then
        rm -f "$LOG_FILE"
    fi
}
trap cleanup EXIT

source_scripts=(
    utils/utils.sh
    utils/logger.sh
    utils/installer.sh
    utils/initialize.sh
    basic_packages.sh
    dracula.sh
    fish.sh
    git_setup.sh
    gnome_packages.sh
    jlink.sh
    kitty.sh
    nerdfonts.sh
    spotify.sh
    touchegg.sh
    vscode.sh
)

download_and_source_scripts() {
    for script in "${source_scripts[@]}"; do
        curl -fsSL "$REPO_URL/$script" -o "$TMP_DIR/$script"
        source "$TMP_DIR/$script"
    done
}

# Main function
main() {
    download_and_source_scripts

    initialize

    show_message "Welcome to the Get Started setup script!"
    
    local choices=$(
        select_options \
        "Install basic packages" \
        "Configure Git" \
        "Install VSCode" \
        "Install GNOME packages" \
        "Install GTK Dracula theme" \
        "Install Touchegg" \
        "Install Kitty terminal" \
        "Install Fish shell" \
        "Install Nerd Fonts" \
        "Install J-Link" \
        "Install Spotify" \
        "Install Flutter"
    )

    # Process choices
    [[ $choices == *"Install basic packages"*       ]] && install_basic_packages
    [[ $choices == *"Configure Git"*                ]] && configure_git
    [[ $choices == *"Install VSCode"*               ]] && install_vscode
    [[ $choices == *"Install GNOME packages"*       ]] && install_gnome_packages
    [[ $choices == *"Install GTK Dracula theme"*    ]] && install_dracula_theme
    [[ $choices == *"Install Touchegg"*             ]] && install_touchegg
    [[ $choices == *"Install Kitty terminal"*       ]] && install_kitty
    [[ $choices == *"Install Fish shell"*           ]] && install_fish
    [[ $choices == *"Install Nerd Fonts"*           ]] && install_nerd_fonts
    [[ $choices == *"Install J-Link"*               ]] && install_jlink
    [[ $choices == *"Install Spotify"*              ]] && install_spotify
    [[ $choices == *"Install Flutter"*              ]] && install_flutter

    # Summary
    if [[ $ERROR_COUNT -gt 0 ]]; then
        log_error "Installation completed with $ERROR_COUNT errors."
        log_info "Check the log file for details: $LOG_FILE"
    else
        log_success "Installation completed successfully!"
    fi
}

main "$@"