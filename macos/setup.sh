#!/bin/bash

#	ask for sudo access at start
sudo -v

# copy HOME dotfiles to HOME

for file in ./HOME/*; do rsync -a "$file" $HOME"/."$(basename $file); done

#	Enable TouchID for sudo access
$HOME/enablesudotid.sh

#	install Rosetta
echo "A" | sudo softwareupdate --install-rosetta

#	install brew
printf "\n" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/opt/homebrew/bin/brew shellenv)"

#	update brew
brew update
brew upgrade

#	chmod needed for brew completion
chmod -R go-w "$(brew --prefix)/share"

#	open AppStore
mas open

#	install apps
brew bundle

osascript -e 'delay 1' -e 'tell application "App Store" to quit'

#	install zsh
sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# TODO open ./macos/Argonaut.terminal
osascript -e 'delay 1' -e 'tell application "Terminal" to close front window'
defaults write com.apple.terminal "Default Window Settings" "Argonaut"
defaults write com.apple.terminal "Startup Window Settings" "Argonaut"

#	Disable Crash Reporter
launchctl unload -w /System/Library/LaunchAgents/com.apple.ReportCrash.plist
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist

#	Keep network active when screen is locked
sudo pmset -a networkoversleep 1

#	Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# Disable spotlight indexing
sudo mdutil -a -i off

./macos/defaults.sh

osascript -e 'display alert "Setup complete" as informational'