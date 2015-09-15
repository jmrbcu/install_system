# bash dot files
unalias ls
mkdir ~/.old_bash_config
git clone https://github.com/jmrbcu/dotfiles.git ~/.dotfiles
for dotfile in `ls -A ~/.dotfiles/`; do
  [ -f ~/$dotfile ] && mv $dotfile ~/.old_bash_config
  if [ $dotfile != ".git" ]; then
    ln -s ~/.dotfiles/$dotfile ~/$dotfile;
  fi
done

# zsh configurations
git clone --recursive https://github.com/jmrbcu/prezto.git ~/.zprezto
for rcfile in `ls -A ~/.zprezto/runcoms/z*`; do
  ln -s $rcfile ~/.${rcfile##*/};
done

# change the shell to zsh
chsh -s /bin/zsh

# vim configuration
[ -f ~/.vim ] && mv ~/.vim ~/.vim_old
git clone https://github.com/timss/vimconf.git ~/.vim
ln -sf ~/.vim/.vimrc ~/.vimrc