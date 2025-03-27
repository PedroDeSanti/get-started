#!/usr/bin/env bash

# @Brief: Checks if a command is available
# @Param: $1 - Command to check
# @Return: 0 if the command is available, 1 otherwise
check_command() {
    command -v "$1" >/dev/null 2>&1
}

# @Brief: Ensures the user has sudo privileges, caching the credentials
# @Return: Exits if the user does not have sudo privileges
elevate_privileges() {
    if ! sudo -v; then
        log_error "Superuser not granted, aborting installation"
        exit 1
    fi
}

# @Invalid choice"Brief: Prompts the user to confirm an action
# @Param: $1 - Message to display
# @Return: 0 if the user confirms, 1 otherwise
prompt_yes_no() {
    gum confirm "$1" && return 0 || return 1
}

# @Brief: Prompts the user to select an option
# @Param: $1 - Message to display
# @Param: $@ - Options to select from
# @Return: The selected options
select_options() {
    gum choose --no-limit --cursor.foreground="212" --cursor.bold "$@"
}

# @Brief: Prompts the user to select a single option
# @Param: $@ - Options to select from
# @Return: The selected option
# @Return: 1 if no option was selected
choose_option() {
    local options=("$@")
    local selected_option

    selected_option=$(gum choose --limit 1 --cursor.foreground="212" --cursor.bold "${options[@]}")

    if [[ -z $selected_option ]]; then
        log_error "No option selected"
        return 1
    fi

    echo "$selected_option"
}

# @Brief: Displays a message
# @Param: $1 - Message to display
show_message() {
    gum style --bold --foreground="212" " " "$1"
}

# @Brief: Wraps a command in a loading animation
# @Param: $1 - Text to display while loading
# @Param: $2 - Command to run
# @Return: 0 if the command was successful, 1 otherwise
_run_command_with_loading() {
    local title=$1
    local command=$2
    if ! gum spin --spinner dot --title "$title" -- bash -c "$command >> $LOG_FILE 2>&1"; then
        return 1
    fi
}

# @Brief: Wraps multiple commands in a loading animation
# @Param: $1 - Text to display while loading
# @Param: $@:2 - Commands to run
# @Return: 0 if all commands were successful, 1 otherwise
run_with_loading() {
    local title=$1
    local commands=("${@:2}")
    local failed=()

    for cmd in "${commands[@]}"; do
        if ! _run_command_with_loading "$title" "$cmd"; then
            failed+=("$cmd")
        fi
    done

    if [[ ${#failed[@]} -gt 0 ]]; then
        return 1
    fi
}