#!/usr/bin/env bash

dependencies=("sudo" "curl" "wget" "gpg")

# @Brief: Checks if dependencies are installed
# @Return: Exit code 1 if failed to install dependencies
_check_dependencies() {
    local missing=()

    for dep in "${dependencies[@]}"; do
        if ! check_command "$dep"; then
            missing+=("$dep")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_info "Installing missing dependencies: ${missing[*]}"
        sudo apt-get -q update -y >> "$LOG_FILE" 2>&1 && \
        sudo apt-get -q install -y "${missing[@]}" >> "$LOG_FILE" 2>&1 || {
            log_error "Failed to install dependencies. Please install them manually and run the script again."
            exit 1
        }
    fi
}

# @Brief: Installs Gum
# @Return: Exit code 1 if failed to install Gum
_install_gum() {
    log_info "Installing Gum..."

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list > /dev/null
    
    sudo apt-get -q update -y >> "$LOG_FILE" 2>&1 && \
    sudo apt-get -q install -y gum >> "$LOG_FILE" 2>&1 || {
        log_error "Failed to install Gum"
        exit 1
    }
    
    log_success "Gum installed"
}

# @Brief: Initializes the script by installing all dependencies
initialize() {
    _check_dependencies

    if ! check_command gum; then
        _install_gum
    fi

    show_message "Updating system..."
    apt_update && apt_upgrade
}
