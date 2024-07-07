#!/bin/sh

# Homebrew(https://brew.sh/)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# xcode
xcode-select --install

# node
brew install node
brew install pnpm
# git
brew install git
brew install ghq
brew install lazygit
brew install git-delta
brew install gh
# tmux
brew install tmux
# other
brew install peco
brew install mas

# line
mas install 539883307
# spark
mas install 539883307
# yoink
mas install 457622435
# bitwarden
mas install 1352778147
# reeder 5
mas install 1529448980
# final cut pro
mas install 1529448980
# things 3
mas install 904280696
# hazeover
mas install 430798174
# slack
mas install 803453959
#  kindle
mas install 302584613
# xcode
mas install 497799835
# apple developer
mas install 640199958
# magnet
mas install 441258766
# cot editor
mas install 1024640650
# Numbers
mas install 409203825
# Pages
mas install 409201541

# chrome
# goole ime
# google drive
# better touch tool
# deepl
# notion
# iterm2
# vscode insiders

ln $(pwd)/home/.zshenv ~/.zshenv
