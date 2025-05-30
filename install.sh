#!/usr/bin/env bash

# File: install.sh
# Brief: This script installs basic packages and configures the system
# Author: Pedro De Santi
# Date: 04/2025
# Version: 2.0

readonly REPO_URL="https://raw.githubusercontent.com/PedroDeSanti/get-started/main/scripts/"

TEMP_DIR=$(mktemp -d)
readonly TEMP_DIR

# Exit immediately if a command exits with a non-zero status
# set -euo pipefail 

source_scripts=(
    utils/logger.sh
    utils/utils.sh
    utils/installers.sh
    utils/initialize.sh
    basic_packages.sh
    chrome.sh
    dracula.sh
    fish.sh
    flutter.sh
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
        mkdir -p "$TEMP_DIR/$(dirname "$script")"
        wget -q -O "$TEMP_DIR/$script" "$REPO_URL/$script"
        printf "Sourcing %s\n" "$script"
        # shellcheck disable=SC1090
        source "$TEMP_DIR/$script"
    done
}

cleanup() {
    rm -rf "$TEMP_DIR"
    if [[ $ERROR_COUNT -eq 0 ]]; then
        rm -f "$LOG_FILE"
    fi
}
trap cleanup EXIT

# Main function
main() {
    download_and_source_scripts
    elevate_privileges
    initialize

    show_title "Welcome to the Get Started setup script!"
    
    local choices
    select_options choices \
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
        "Install Chrome" \
        "Install Spotify" \
        "Install Flutter"

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
    [[ $choices == *"Install Chrome"*               ]] && install_chrome
    [[ $choices == *"Install Spotify"*              ]] && install_spotify
    [[ $choices == *"Install Flutter"*              ]] && install_flutter

    if [[ $ERROR_COUNT -gt 0 ]]; then
        log_error "Installation completed with $ERROR_COUNT errors."
        log_info "Check the log file for details: $LOG_FILE"
    else
        log_success "Installation completed successfully!"
    fi
}

main "$@"