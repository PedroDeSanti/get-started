
_install_dracula_gtk() {
    show_message "Installing GTK Dracula Theme..."

    curl -o Dracula.zip -fL https://github.com/dracula/gtk/archive/master.zip
    unzip -qq Dracula.zip
    mkdir -p ~/.themes/Dracula
    cp -r gtk-master/* ~/.themes/Dracula
    rm -rf gtk-master
    rm -f Dracula.zip

    gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
    gsettings set org.gnome.desktop.wm.preferences theme "Dracula"

    log_success "GTK Dracula Theme installed"
}

_install_dracula_icon_theme() {
    show_message "Installing Icon Dracula Theme..."

    curl -sSfLO https://github.com/dracula/gtk/files/5214870/Dracula.zip

    unzip -qq Dracula.zip
    mkdir -p ~/.icons/Dracula
    cp -r Dracula/* ~/.icons/Dracula
    rm -rf Dracula
    rm -f Dracula.zip

    gsettings set org.gnome.desktop.interface icon-theme "Dracula"

    log_success "Icon Dracula Theme installed"
}

_install_gnome_terminal_dracula_theme() {
    show_message "Installing Gnome Terminal Dracula Theme..."

    git clone https://github.com/dracula/gnome-terminal
    cd gnome-terminal
    ./install.sh #-s Dracula -p default
    cd ..
    rm -rf gnome-terminal

    log_success "Gnome Terminal Dracula Theme installed"
}

_install_gedit_dracula_theme() {
    show_message "Installing Gedit Dracula Theme..."
    
    wget -q https://raw.githubusercontent.com/dracula/gedit/master/dracula.xml
    mkdir -p $HOME/.local/share/gedit/styles/
    mv dracula.xml $HOME/.local/share/gedit/styles/

    show_message "Gedit Dracula Theme installed! Activate in Gedit's preferences dialog."

    log_success "Gedit Dracula Theme installed"
}

_install_tela_circle_icons() {
    show_message "Installing Tela Circle Icons Theme..."
    
    git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git >> "$LOG_FILE" 2>&1
    cd Tela-circle-icon-theme
    ./install.sh
    cd ..
    rm -rf Tela-circle-icon-theme

    log_success "Tela Circle Icons Theme installed"
}

install_dracula_theme() {
    show_message "Installing Dracula theme..."

    if prompt_yes_no "Install GTK Dracula Theme?"; then
        _install_dracula_gtk
    fi

    if prompt_yes_no "Install Icon Dracula Theme?"; then
        _install_dracula_icon_theme
    fi

    if prompt_yes_no "Install Gnome Terminal Dracula Theme?"; then
        _install_gnome_terminal_dracula_theme
    fi

    if prompt_yes_no "Install Gedit Dracula Theme?"; then
        _install_gedit_dracula_theme
    fi

    if prompt_yes_no "Install Tela Circle Icons Theme?"; then
        _install_tela_circle_icons
    fi
}