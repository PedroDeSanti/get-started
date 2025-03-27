#!/usr/bin/env bash

install_nerd_fonts() {
    show_message "Installing Nerd Fonts..."
    
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts
    curl -sSfLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Bold/FiraCodeNerdFontMono-Bold.ttf
    curl -sSfLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Light/FiraCodeNerdFontMono-Light.ttf
    curl -sSfLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Medium/FiraCodeNerdFontMono-Medium.ttf
    curl -sSfLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFontMono-Regular.ttf
    curl -sSfLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Retina/FiraCodeNerdFontMono-Retina.ttf
    curl -sSfLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/SemiBold/FiraCodeNerdFontMono-SemiBold.ttf

    # Update font cache
    fc-cache -fv >> "$LOG_FILE" 2>&1 || {
        log_warning "Failed to update font cache"
    }

    log_success "Nerd Fonts installed"
}
