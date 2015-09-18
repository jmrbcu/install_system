#!/bin/bash

# set hostname
sudo scutil --set ComputerName $SYSTEM_LABEL
sudo scutil --set HostName $SYSTEM_NAME
sudo scutil --set LocalHostName $SYSTEM_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $SYSTEM_NAME

# install command line tools
echo -n  -e "\033[1;31mInstalling: \033[0;32mXCode Command Line Tools\033[0m"
xcode-select --install

# tell the Finder to show the folders first (HACK)
if [ /System/Library/CoreServices/Finder.app/Contents/Resources/English.lproj ]; then
  cd /System/Library/CoreServices/Finder.app/Contents/Resources/English.lproj
  sudo mv /System/Library/CoreServices/Finder.app/Contents/Resources/English.lproj/InfoPlist.strings /System/Library/CoreServices/Finder.app/Contents/Resources/English.lproj/InfoPlist.strings.save
  sudo plutil -replace Folder -string " Folder" /System/Library/CoreServices/Finder.app/Contents/Resources/English.lproj/InfoPlist.strings
  sudo find / -name ".DS_Store"  -exec rm {} \;
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
  defaults write com.apple.finder NewWindowTarget PfHm
  defaults write com.apple.finder FXPreferredViewStyle icnv
  defaults write com.apple.finder FXPreferredGroupBy None
  defaults write com.apple.finder FXArrangeGroupViewBy Name
  sudo killall Finder
fi
