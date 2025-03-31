#!/usr/bin/env bash

install_kitty() {
    show_message "Installing Kitty terminal..."
    
    run_with_loading "Downloading and running Kitty installer..." \
        "curl -fsSL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin" || {
        log_error "Failed to download and run Kitty installer"
        return
    }

    mkdir -p ~/.local/share/applications
    cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
    
    sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
    
    sudo ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten /usr/bin/
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 50 2>&1 | log_output || {
        log_error "Failed to set Kitty as default terminal"
        return
    }

    log_success "Kitty terminal installed"
}