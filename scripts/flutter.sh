#!/usr/bin/env bash

flutter_deps=(
    curl git unzip xz-utils zip libglu1-mesa
)

install_flutter() {
    show_message "Installing Flutter..."
    
    require_apt_packages "${flutter_deps[@]}" || return

    snap_install "android-studio --classic" || return
    snap_install "flutter --classic" || return

    # Configure Flutter
    flutter sdk-path
    flutter config --android-studio-dir=/snap/android-studio/current/android-studio
    flutter doctor --android-licenses
    flutter doctor

    show_message "Flutter installation complete!"
    show_message "Remember to install Android SDK Command-line Tools in Android Studio:"
    show_message "1. Open Android Studio"
    show_message "2. Go to Configure > SDK Manager"
    show_message "3. Under SDK Tools, check 'Android SDK Command-line Tools'"
    show_message "4. Click Apply to install"
}