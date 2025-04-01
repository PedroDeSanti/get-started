#!/usr/bin/env bash

install_spotify() {
    show_message "Installing Spotify..."

    snap_install spotify || return
}

