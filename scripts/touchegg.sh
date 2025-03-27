#!/usr/bin/env bash

install_touchegg() {
    show_message "Installing Touchegg..."
    
    add_apt_repository ppa:touchegg/stable || return
    apt_update && apt_install touchegg || return
}

