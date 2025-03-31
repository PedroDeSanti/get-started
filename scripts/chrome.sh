#!/usr/bin/env bash

install_chrome() {
    show_message "Installing Google Chrome..."

    run_with_loading "Downloading Google Chrome..." \
        "wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" || {
        log_error "Failed to download Google Chrome"
        return
    }

    apt_install ./google-chrome-stable_current_amd64.deb || return

    rm google-chrome-stable_current_amd64.deb
}