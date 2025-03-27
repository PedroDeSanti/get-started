#!/usr/bin/env bash

flutter_deps=(
    curl git unzip xz-utils zip libglu1-mesa
    libc6:amd64 libstdc++6:amd64 lib32z1 libbz2-1.0:amd64
    libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
)

install_flutter() {
    show_message "Installing Flutter..."
    
    apt_install "${flutter_deps[@]}" || return

    snap_install android-studio flutter || return

    # Configure Flutter
    flutter config --android-studio-dir=/snap/android-studio/current/android-studio
    flutter doctor --android-licenses --accept
    flutter doctor

    show_message "Flutter installation complete!"
    show_message "Remember to install Android SDK Command-line Tools in Android Studio:"
    show_message "1. Open Android Studio"
    show_message "2. Go to Configure > SDK Manager"
    show_message "3. Under SDK Tools, check 'Android SDK Command-line Tools'"
    show_message "4. Click Apply to install"
}