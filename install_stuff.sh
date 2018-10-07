#!/bin/bash
# Install homebrew if it doesn't exist
brew help &> /dev/null
if [ $? -eq 1 ]
  then
    echo "...installing Homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Homebrew installed"
fi

# Install latest zsh
brew install zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Replace .zshrc with git version
cp .zshrc ~/.zshrc

if [ ! -d "~/.vim" ]
then 
    mkdir ~/.vim
fi

if [ ! -d "~/.vim/colors" ]
then
    mkdir ~/.vim/colors
fi

cp .vim/colors/* ~/.vim/colors/
cp .vimrc ~
cp .gitconfig ~
