#!/usr/bin/env bash

# @Brief: Installs a list of packages using the specified command
# @Param: $1 - Command to run to install the packages
# @Param: $2 - List of packages to install
# @Return: 0 if all packages were installed successfully, 1 otherwise
_install() {
    local install_command=$1
    local packages=("${@:2}")
    local failed=()

    for pkg in "${packages[@]}"; do
        if run_with_loading "Installing $pkg" "$install_command $pkg"; then
            log_success "Installed $pkg"
        else
            show_last_error
            log_error "Failed to install $pkg"
            failed+=("$pkg")
        fi
    done

    if [[ ${#failed[@]} -gt 0 ]]; then
        log_warning "Failed to install: ${failed[*]}"
        return 1
    fi
}

# @Brief: Installs a list of packages using apt-get
# @Param: $@ - List of packages to install
apt_install() {
    elevate_privileges
    _install "sudo apt-get -q install -y" "$@"
}

# @Brief: Installs a list of packages using snap
# @Param: $@ - List of packages to install
snap_install() {
    elevate_privileges
    _install "sudo snap install" "$@"
}

# @Brief: Installs a list of packages using flatpak
# @Param: $@ - List of packages to install
flatpak_install() {
    _install "flatpak install -y flathub" "$@"
}

# @Brief: Adds a remote to flatpak
# @Param: $1 - Remote to add
# @Return: 0 if the remote was added successfully, 1 otherwise
flatpak_remote_add() {
    if run_with_loading "Adding remote $1..." "flatpak remote-add --if-not-exists flathub $1"; then
        log_success "Remote added: $1"
    else
        log_error "Failed to add remote: $1"
        return 1
    fi
}

# @Brief: Adds a apt repository
# @Param: $1 - Repository to add
# @Return: 0 if the repository was added successfully, 1 otherwise
add_apt_repository() {
    elevate_privileges
    if run_with_loading "Adding repository $1..." "sudo add-apt-repository -y $1"; then
        log_success "Added repository: $1"
    else
        log_error "Failed to add repository: $1"
        return 1
    fi
}

# @Brief: Updates the package list
# @Return: 0 if the package list was updated successfully, 1 otherwise
apt_update() {
    elevate_privileges
    if run_with_loading "Updating package list..." "sudo apt-get -q update -y"; then
        log_success "Package list updated"
    else
        log_error "Failed to update package list"
        return 1
    fi
}

# @Brief: Upgrades the installed packages
# @Return: 0 if the packages were upgraded successfully, 1 otherwise
apt_upgrade() {
    elevate_privileges
    if run_with_loading "Upgrading packages..." "sudo apt-get -q upgrade -y"; then
        log_success "Packages upgraded"
    else
        log_error "Failed to upgrade packages"
        return 1
    fi
}
