#!/usr/bin/env bash

# @Brief: Creates a new profile in GNOME Terminal
# @Param: $1 - Profile name
# @Return: UUID of the new profile
# @Note: https://askubuntu.com/questions/270469/how-can-i-create-a-new-profile-for-gnome-terminal-via-command-line
_create_gnome_terminal_profile() {
    local dconfdir=/org/gnome/terminal/legacy/profiles:
    local command_deps=(dconf gnome-terminal uuidgen grep)
    local profile_name="$1"
    require_apt_packages "${command_deps[@]}"

    local profile_ids=()
    mapfile -t profile_ids < <(dconf list "$dconfdir/" | grep ^: | sed 's/\///g' | sed 's/://g')

    local profile_ids_old
    profile_ids_old="$(dconf read "$dconfdir"/list | tr -d "]")"

    local profile_id
    profile_id="$(uuidgen)"

    [ -z "$profile_ids_old" ] && local profile_ids_old="["  # if there's no `list` key
    [ ${#profile_ids[@]} -gt 0 ] && local delimiter=,  # if the list is empty

    dconf write $dconfdir/list "${profile_ids_old}${delimiter} '$profile_id']"
    dconf write "$dconfdir/:$profile_id"/visible-name "'$profile_name'"
    echo "$profile_id"
}

# @Brief: Sets the default GNOME Terminal profile
# @Param: $1 - Profile UUID
# @Note: https://askubuntu.com/questions/270469/how-can-i-create-a-new-profile-for-gnome-terminal-via-command-line
_set_gnome_terminal_profile_default() {
    local profile_id="$1"
    dconf write /org/gnome/terminal/legacy/profiles:/default "'$profile_id'"
}

_install_dracula_gtk() {
    show_message "Installing GTK Dracula Theme..."

    curl -o Dracula.zip -sSfL https://github.com/dracula/gtk/archive/master.zip
    unzip -qq Dracula.zip
    mkdir -p ~/.themes/Dracula
    cp -r gtk-master/* ~/.themes/Dracula
    rm -rf gtk-master
    rm -f Dracula.zip

    gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
    gsettings set org.gnome.desktop.wm.preferences theme "Dracula"

    log_success "GTK Dracula Theme installed"
}

_install_gnome_terminal_dracula_theme() {
    show_message "Installing Gnome Terminal Dracula Theme..."

    git clone https://github.com/dracula/gnome-terminal >> "$LOG_FILE" 2>&1
    cd gnome-terminal || return

    local profile_id
    profile_id=$(_create_gnome_terminal_profile "Dracula")
    ./install.sh -s Dracula -p Dracula --skip-dircolor
    _set_gnome_terminal_profile_default "$profile_id"

    cd ..
    rm -rf gnome-terminal

    log_success "Gnome Terminal Dracula Theme installed"
}

_install_gedit_dracula_theme() {
    show_message "Installing Gedit Dracula Theme..."
    
    wget -q https://raw.githubusercontent.com/dracula/gedit/master/dracula.xml
    mkdir -p "$HOME"/.local/share/gedit/styles/
    mv dracula.xml "$HOME"/.local/share/gedit/styles/

    show_message "Gedit Dracula Theme installed! Activate in Gedit's preferences dialog."

    log_success "Gedit Dracula Theme installed"
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

_install_tela_circle_icons() {
    show_message "Installing Tela Circle Icons Theme..."
    
    git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git >> "$LOG_FILE" 2>&1
    cd Tela-circle-icon-theme || return
    ./install.sh >> "$LOG_FILE" 2>&1
    cd ..
    rm -rf Tela-circle-icon-theme

    gsettings set org.gnome.desktop.interface icon-theme "Tela-circle"

    log_success "Tela Circle Icons Theme installed"
}

install_dracula_theme() {
    show_message "Installing Dracula theme..."

    if prompt_yes_no "Install GTK Dracula Theme?"; then
        _install_dracula_gtk
    fi

    if prompt_yes_no "Install Gnome Terminal Dracula Theme?"; then
        _install_gnome_terminal_dracula_theme
    fi

    if prompt_yes_no "Install Gedit Dracula Theme?"; then
        _install_gedit_dracula_theme
    fi

    if prompt_yes_no "Install Icon Theme?"; then
        local icon_theme_choice
        icon_theme_choice=$(select_options "Dracula" "Tela Circle Icons")

        case $icon_theme_choice in
            "Dracula")
                _install_dracula_icon_theme
                ;;
            "Tela Circle Icons")
                _install_tela_circle_icons
                ;;
            *)
                log_warning "No icon theme selected"
                return 1
                ;;
        esac
    fi
}