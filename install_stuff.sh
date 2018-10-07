#!/bin/bash
cd "${0%/*}" &> /dev/null

# Install homebrew if it doesn't exist
echo "Checking for homebrew..."
brew help &> /dev/null
if [ $? -eq 1 ]
  then
    echo "...installing Homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Homebrew installed"
fi

# Install latest zsh
echo "Installing latest zsh"
brew install zsh

# Install oh-my-zsh
echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Replace config files
echo "Replacing config files"
[ ! -d "$HOME/.vim" ] && mkdir ~/.vim
[ ! -d "$HOME/.vim/colors" ] && mkdir ~/.vim/colors

cp .zshrc ~/.zshrc
cp .gitconfig ~
cp .vimrc ~
cp .vim/colors/* ~/.vim/colors/

echo "Setup complete!"
