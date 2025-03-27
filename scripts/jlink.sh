#!/usr/bin/env bash

install_jlink() {
    show_message "Installing J-Link..."
    
    curl -fsSLO -d 'accept_license_agreement=accepted&submit=Download+software' \
        https://www.segger.com/downloads/jlink/JLink_Linux_x86_64.deb || {
        log_error "Failed to download J-Link"
        return
    }

    apt_install ./JLink_Linux_x86_64.deb || return
    
    rm JLink_Linux_x86_64.deb

    log_success "J-Link installed"
}