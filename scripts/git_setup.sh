#!/usr/bin/env bash

# @Brief: Configures Git with the user's credentials
configure_git() {
    show_message "Configuring Git..."
    
    local git_username git_email

    git_username=$(gum input --prompt "Enter Git username: " --placeholder "Your GitHub username")
    git_email=$(gum input --prompt "Enter Git email: " --placeholder "Your GitHub email")

    git config --global user.name "$git_username"
    git config --global user.email "$git_email"

    if prompt_yes_no "Do you want to configure SSH for Git?"; then
        _configure_ssh "$git_email"
    fi

    log_success "Git configured"
}

# @Brief: Configures SSH for Git and copies the public key to the clipboard
_configure_ssh(){
    local git_email=$1

    show_message "Configuring SSH..."
    
    ssh-keygen -t ed25519 -C "$git_email" -f ~/.ssh/id_ed25519 -N "" || {
        log_error "Key generation failed"
        return
    }

    eval "$(ssh-agent -s)" >> "$LOG_FILE" 2>&1
    ssh-add ~/.ssh/id_ed25519 >> "$LOG_FILE" 2>&1 || {
        log_error "Failed to add SSH key to agent"
        return
    }

    xclip -sel clip < ~/.ssh/id_ed25519.pub

    show_message "SSH configured successfully! The SSH public key was copied to the clipboard!"
    cat ~/.ssh/id_ed25519.pub
}