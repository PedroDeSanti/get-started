#!/usr/bin/env bash

install_kitty() {
    show_message "Installing Kitty terminal..."
    
    curl -fsSL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin >> "$LOG_FILE" 2>&1 || {
        log_error "Failed to install Kitty"
        return
    }

    mkdir -p ~/.local/share/applications
    cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
    
    sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
    
    sudo ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten /usr/bin/
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 50

    log_success "Kitty terminal installed"
}