#!/usr/bin/env bash

flutter_deps=(
    curl git unzip xz-utils zip libglu1-mesa
)

install_flutter() {
    show_message "Installing Flutter..."

    local warnings=0
    
    require_apt_packages "${flutter_deps[@]}" || return

    snap_install "android-studio --classic" || return
    snap_install "flutter --classic" || return

    log_info "Launching Android Studio to install the Android SDK..."
    log_info "Please follow the instructions in Android Studio to install the Android SDK.\n \
              \t\t\t1. Follow the setup wizard and wait for the installation to complete\n \
              \t\t\t2. Go to More Actions > SDK Manager\n \
              \t\t\t4. Under SDK Tools, check 'Android SDK Command-line Tools' and click Apply\n \
              \t\t\t5. Wait for the installation to complete\n \
              \t\t\t6. Close Android Studio to proceed with script execution"


    android-studio 2>&1 | log_output

    show_message "Android Studio closed. Proceeding with Flutter setup..."

    run_with_loading "Configuring Flutter with Android SDK" \
        "flutter config --android-sdk $HOME/Android/Sdk" || {
        warnings=$((warnings + 1))
        log_warning "Failed to configure Flutter with Android SDK"
    }

    run_with_loading "Accepting Android licenses" \
        "yes | flutter doctor --android-licenses" || {
        warnings=$((warnings + 1))
        log_warning "Failed to accept Android licenses"
    }

    flutter doctor

    if [[ $warnings -gt 0 ]]; then
        log_warning "Flutter setup completed with $warnings warnings"
    else
        log_success "Flutter setup completed successfully"
    fi
}