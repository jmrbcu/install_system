# set hostname
    sudo scutil --set ComputerName $SYSTEM_LABEL
    sudo scutil --set HostName $SYSTEM_NAME
    sudo scutil --set LocalHostName $SYSTEM_NAME
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $SYSTEM_NAME

    # install command line tools
    echo -n  -e "\033[1;31mInstalling: \033[0;32mXCode Command Line Tools\033[0m"
    xcode-select --install