# Quick Start

Setup for macOS / bash — complete with Vim, Git, Ruby, and Homebrew. Paste this:

```bash
# 1. Install Homebrew (https://brew.sh)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clone this repo
export DOTFILES_HOME="${HOME}/.dotfiles"
git clone git@github.com:obradovic/dotfiles.git ${DOTFILES_HOME}

# 3. Symlink all dotfiles
dotfiles=( .bashrc .bash_profile .colors_bash .curl_format .dircolors .gemrc .git-completion.sh .git-prompt.sh .gitconfig .inputrc .irbrc .myclirc .vim .vimrc )
for f in "${dotfiles[@]}"; do
    echo "🔗 Linking $f"
    ln -sf ${DOTFILES_HOME}/$f ${HOME}/$f
done
source ~/.bashrc

# 4. Install all the Homebrew packages
cd ${DOTFILES_HOME}
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
