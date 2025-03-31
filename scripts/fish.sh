#!/usr/bin/env bash

_install_starship() {
    run_with_loading "Installing Starship..." \
        "curl -fsSL https://starship.rs/install.sh | sh -s -- -y" || {
        log_error "Failed to install Starship"
        return 1
    }
    log_success "Installed Starship"
}

_set_fish_as_default_shell() {
    if ! grep -q "$(which fish)" /etc/shells; then
        echo "$(which fish)" | sudo tee -a /etc/shells 2>&1 | log_output
    fi
    
    elevate_privileges
    sudo chsh -s "$(which fish)" "$USER" 2>&1 | log_output || {
        log_warning "Failed to set Fish as default shell"
        return 1
    }
    log_success "Set Fish as default shell"
}

_install_fundle() {
    run_with_loading "Installing Fundle..." \
        "curl -fsSL https://git.io/fundle-install | fish" || {
        log_error "Failed to install Fundle"
        return 1
    }
    log_success "Installed Fundle"
}

_setup_fish_config() {
    mkdir -p ~/.config/fish
}

install_fish() {
    show_message "Installing Fish shell..."
    
    add_apt_repository ppa:fish-shell/release-3 || return
    apt_update && apt_install fish || return

    _set_fish_as_default_shell
    _install_starship
    _setup_fish_config
    _install_fundle

    log_success "Fish shell installed"
}