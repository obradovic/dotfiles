# Dotfiles du jour

A minimal yet powerful setup for macOS and Linux shells — complete with Vim, Git, Ruby, and Homebrew.

---

## Quick Start

Paste this into a fresh terminal:

```bash
# 1. Install Homebrew (https://brew.sh)
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# 2. Clone this repo
cd ~
git clone git@github.com:obradovic/dotfiles.git .dotfiles

# 3. Symlink all dotfiles
dotfiles=( .bashrc .bash_profile .colors_bash .curl_format .dircolors .gemrc .git-completion.sh .git-prompt.sh .gitconfig .inputrc .irbrc .myclirc .vim .vimrc )
for f in "${dotfiles[@]}"; do
    echo "🔗 Linking $f"
    ln -sf .dotfiles/$f $f
done
source ~/.bashrc

# 4. Install all the Homebrew packages
cd ~/.dotfiles
brew bundle

# 5. Install Vim plugins (Vim Plug)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Then inside Vim:
# :PlugInstall

# 6. Optional: macOS tweaks
defaults write com.apple.finder AppleShowAllFiles YES               # Show all hidden files
defaults write com.apple.Safari UniversalSearchEnabled -bool FALSE  # Disable send search queries to Apple
defaults write com.apple.Dock autohide -bool TRUE                   # Automatically hide and show the Dock

# 7. Ruby setup
gem install bundler

```
