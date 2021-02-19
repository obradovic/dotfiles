# Quick Start

First, paste the following into a terminal:

```
# Install brew (from https://brew.sh)
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Clone this repo
cd ~
git clone git@github.com:obradovic/dotfiles.git .dotfiles

# Link the dotfiles
dotfiles=( .bashrc .bash_profile .colors_bash .curl_format .dircolors .gemrc .git-completion.sh .git-prompt.sh .gitconfig .inputrc .irbrc .vim .vimrc )
for dotfile in "${dotfiles[@]}"; do
    echo "Linking $dotfile"
    ln -s .dotfiles/$dotfile $dotfile
done
. ~/.bashrc

# Install all the brew packages from the Brewfile
cd .dotfiles
brew tap Homebrew/bundle
brew bundle

# Install VIM Plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# From inside vi
:PlugInstall

cd
```

