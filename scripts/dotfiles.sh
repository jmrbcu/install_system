#!/bin/bash

# bash dot files
unalias ls &> /dev/null

if [ -L ~/.old_bash_config ] || [ -e ~/.old_bash_config ]; then 
    echo "Backup directory: .old_bash_config exists, please, rename it..."
    exit 1;
fi

mkdir ~/.old_bash_config

# check  if the .dotfiles directory exists and if true, move it to the backup directory
[ -L ~/.dotfiles ] || [ -e ~/.dotfiles  ] && mv ~/.dotfiles ~/.old_bash_config

git clone https://github.com/jmrbcu/dotfiles.git ~/.dotfiles
for dotfile in `ls -A ~/.dotfiles/`; do
  # check  if the file exists and if true, move it to the backup directory
  [ -L ~/$dotfile ] || [ -e ~/$dotfile  ] && mv ~/$dotfile ~/.old_bash_config

  if [ $dotfile != ".git" ]; then
    ln -s ~/.dotfiles/$dotfile ~/$dotfile;
  fi
done

# sanitize the .gitconfig for linux use
sed -i.save 's/\[push\]//g;s/default = simple//g;s/^\s*$//g' ~/.gitconfig

# zsh configurations
# check  if the .zprezto directory exists and if true, move it to the backup directory
[ -L ~/.zprezto ] || [ -e ~/.zprezto  ] && mv ~/.zprezto ~/.old_bash_config

git clone --recursive https://github.com/jmrbcu/prezto.git ~/.zprezto
for rcfile in `ls -A ~/.zprezto/runcoms/z*`; do
  # check  if the file exists and if true, move it to the backup directory
  [ -L ~/.${rcfile##*/} ] || [ -e ~/.${rcfile##*/} ] && mv ~/.${rcfile##*/} ~/.old_bash_config

  ln -s $rcfile ~/.${rcfile##*/};
done

# change the shell to zsh
chsh -s /bin/zsh

# vim configuration
# check  if the file exists and if true, move it to the backup directory
[ -L ~/.vim ] || [ -e ~/.vim ] && mv ~/.vim ~/.vim_old

git clone https://github.com/timss/vimconf.git ~/.vim
ln -sf ~/.vim/.vimrc ~/.vimrc
