#!/bin/bash

# iTerm
install_zip_app "$ITERM_APP_URL" "$ITERM_APP_NAME"

# App Cleaner
install_zip_app "$APP_CLEANER_APP_URL" "$APP_CLEANER_APP_NAME"

# BetterTouch
install_zip_app "$BETTERTOUCH_APP_URL" "$BETTERTOUCH_APP_NAME"
defaults write com.hegenberg.BetterTouchTool launchOnStartup 1

# Sublime Text
install_dmg_app "$SUBLIME_TEXT_APP_URL" "Sublime Text" "$SUBLIME_TEXT_APP_NAME"

# Google Chrome
install_dmg_app "$CHROME_APP_URL" "Google Chrome" "$CHROME_APP_NAME"

# Sequel Pro
install_dmg_app "$SEQUEL_PRO_APP_URL" "Sequel Pro 1.0.2" "$SEQUEL_PRO_APP_NAME"

# VLC
install_dmg_app "$VLC_APP_URL" "vlc-2.2.1" "$VLC_APP_NAME"

printf "\033[1;31mInstall:\033[0;32m MPlayerX\033[1;31m from:\033[0;32m http://mplayerx.org/\033[0m\n"
printf "\033[1;31mInstall:\033[0;32m XCode, The Unarchiver, CleanMyDrive, Microsoft Remote Desktop\033[1;31m from the App Store \033[0m\n"
