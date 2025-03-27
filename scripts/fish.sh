#!/usr/bin/env bash

_install_starship() {
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y >> "$LOG_FILE" 2>&1 || {
        log_error "Failed to install Starship"
        return 1
    }
    log_success "Installed Starship"
}

_set_fish_as_default_shell() {
    if ! grep -q "$(which fish)" /etc/shells; then
        echo "$(which fish)" | sudo tee -a /etc/shells >> "$LOG_FILE" 2>&1
    fi
    
    elevate_privileges
    sudo chsh -s "$(which fish)" "$USER" >> "$LOG_FILE" 2>&1 || {
        log_warning "Failed to set Fish as default shell"
    }
}

_install_fundle() {
    curl -fsSL https://git.io/fundle-install | fish >> "$LOG_FILE" 2>&1 || {
        log_error "Failed to install Fundle"
    }
    log_success "Installed Fundle"
}

_setup_fish_config() {
    mkdir -p ~/.config/fish
    echo "starship init fish | source" >> ~/.config/fish/config.fish
    echo "zoxide init fish | source" >> ~/.config/fish/config.fish
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