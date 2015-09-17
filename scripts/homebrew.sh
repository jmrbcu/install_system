#!/bin/bash

# install homebrew
printf "\033[1;31mChecking for Homebrew...\033[0m\n"
if test ! $(which brew); then
  printf "\033[1;31mInstalling: \033[0;32mHomebrew\033[0m\n"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# check homebrew install
brew doctor

# add some brew repositories
brew tap caskroom/cask
brew tap homebrew/binary
brew update
brew doctor

# install a lot of apps using homebrew
printf "\033[1;31mInstalling: \033[0;32mmidnight commander\033[0m\n"
brew install mc

# vim
printf "\033[1;31mInstalling: \033[0;32mvim\033[0m\n"
brew install --override-system-vi vim

# elinks
printf "\033[1;31mInstalling: \033[0;32meLinks\033[0m\n"
brew install elinks

# xz, rar and p7zip
printf "\033[1;31mInstalling: \033[0;32mxz, rar, p7zip\033[0m\n"
brew install xz rar p7zip

# bash completion
printf "\033[1;31mInstalling: \033[0;32mbash completion\033[0m\n"
brew install bash-completion

# git
printf "\033[1;31mInstalling: \033[0;32mgit\033[0m\n"
brew install git

# wget
printf "\033[1;31mInstalling: \033[0;32mwget\033[0m\n"
brew install wget

# htop
printf "\033[1;31mInstalling: \033[0;32mhtop\033[0m\n"
brew install htop-osx
sudo chown root:wheel /usr/local/Cellar/htop-osx/0.8.2.7/bin/htop
sudo chmod u+s /usr/local/Cellar/htop-osx/0.8.2.7/bin/htop

# mysql
printf "\033[1;31mInstalling: \033[0;32mmysql server\033[0m\n"
brew install mysql
mysql.server start
mysql_secure_installation
mysql.server stop

# python
printf "\033[1;31mInstalling: \033[0;32mpython\033[0m\n"
brew install python
pip install --upgrade setuptools
pip install --upgrade pip
pip install ipython

# zsh
printf "\033[1;31mInstalling: \033[0;32mzsh\033[0m\n"
brew install zsh

# redis
printf "\033[1;31mInstalling: \033[0;32mredis\033[0m\n"
brew install redis
