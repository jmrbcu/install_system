#!/bin/bash

# USAGE
# ./run.sh OPTION

if [ "$(uname)" == "Darwin" ]; then
    # SETTINGS
    source settings.sh

    # LIBRARY
    source functions.sh

    # Process option selection.
    # Parameters:
    # $1 = The option to process.
    process_option() {
      case $1 in
        'b')
          printf "\033[1;31mInstalling: \033[0;32mbasic stuff\033[0m\n"
          scripts/basic.sh
          ;;
          # break;;
        'h')
          printf "\033[1;31mInstalling: \033[0;32mhomebrew software\033[0m\n"
          scripts/homebrew.sh
          ;;
          # break;;
        'a')
          printf "\033[1;31mInstalling: \033[0;32mgraphical applications\033[0m\n"
          scripts/applications.sh
          ;;
          # break;;
        'c')
          printf "\033[1;31mInstalling: \033[0;32mconfiguration files\033[0m\n"
          scripts/dotfiles.sh
          ;;
          # break;;
        'x')
          printf "\033[1;31mVerifiying: \033[0;32msoftware installations\033[0m\n"
          verify_homebrews
          #verify_applications
          ;;
          # break;;
        'q')
          break;;
        *)
          printf "ERROR: Invalid option.\n"
          break;;
      esac
    }

    while true; do
      if [[ $# == 0 ]]; then
        printf "\n"
        printf "\033[1;31mUsage: \033[0;32mrun OPTION\033[0m\n"
        printf "\033[1;31mOSX Options:\033[0m\n"
        printf "\033[1;31m  Setup:\033[0m\n"
        printf "    b:  Apply basic system settings.\n"
        printf "    h:  Install Homebrew software.\n"
        printf "    a:  Install application software.\n"
        printf "    c:  Install configuration files.\n"
        printf "    x:  Check status of managed software.\n"
        printf "    q:  Quit/Exit.\n\n"
        read -p "Enter selection: " response
        printf "\n"
        process_option $response
      else
        process_option $1
      fi
    done
else
    # Do something under Linux platform
    if grep --quiet CentOS /etc/issue ; then
        sudo yum install zsh;
    elif grep --quiet Debian /etc/issue ; then
        sudo apt-get install zsh;
    elif grep --quiet Ubuntu /etc/issue ; then
        sudo apt-get install zsh;
    elif grep --quiet Arch /etc/issue ; then
        sudo pacman -S zsh;
    else
        echo "Unsupported OS, exiting..."
        exit 1
    fi

    scripts/dotfiles.sh
fi



