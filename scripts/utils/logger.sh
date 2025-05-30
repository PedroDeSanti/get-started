#!/usr/bin/env bash

# Constants
readonly ERROR_COLOR='\033[0;31m'
readonly SUCCESS_COLOR='\033[0;32m'
readonly WARNING_COLOR='\033[0;33m'
readonly INFO_COLOR='\033[0;34m'
readonly NO_COLOR='\033[0m'

LOG_FILE="$(pwd)/install_log_$(date +%Y%m%d_%H%M%S).txt"
readonly LOG_FILE

# Initialize error count
ERROR_COUNT=0

# Create log file
: > "$LOG_FILE"

# @Brief: Logs a message to the console and a log file
# @Param: $1 - Message to log
log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# @Brief: Logs an info message
# @Param: $1 - Message to log
log_info() {
    log "${INFO_COLOR}[INFO]\t$1${NO_COLOR}"
}

# @Brief: Logs a success message
# @Param: $1 - Message to log
log_success() {
    log "${SUCCESS_COLOR}[SUCCESS]\t$1${NO_COLOR}"
}

# @Brief: Logs a warning message
# @Param: $1 - Message to log
log_warning() {
    log "${WARNING_COLOR}[WARNING]\t$1${NO_COLOR}" >&2
}

# @Brief: Logs an error message
# @Param: $1 - Message to log
log_error() {
    log "${ERROR_COLOR}[ERROR]\t$1${NO_COLOR}" >&2
    ERROR_COUNT=$((ERROR_COUNT + 1))
}

# @brief Logs the stdout of a command to a log file
# @details This function is designed to be used in a pipeline. It appends the stdout
#          of the previous command to the specified log file. To also log stderr,
#          you must redirect stderr to stdout using `2>&1` before the pipe
log_output() {
    sudo tee -a "$LOG_FILE" > /dev/null
}

# @Brief: Shows the last error message
show_last_error(){
    log_error "$(grep -i "error\|E:" "$LOG_FILE" | tail -1)"
}
