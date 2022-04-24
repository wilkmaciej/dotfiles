#!/bin/bash

#	ask for sudo access at start
sudo -v

#	Enable TouchID for sudo access
cp ./macos/enablesudotid.sh $HOME/.enablesudotid.sh
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

#	install brew apps
echo '
alt-tab
android-file-transfer
android-platform-tools
balenaetcher
chrome-remote-desktop-host
cyberduck
discord
disk-drill
free-download-manager
google-chrome
gpg-suite
nrlquaker-winbox
raycast
rectangle
slack
spotify
stats
tableplus
the-unarchiver
visual-studio-code
vlc
webtorrent
wine-stable
wireshark
' | xargs -n1 brew install --cask

echo '
arp-scan
arping
binutils
git
gobuster
iperf3
mas
nmap
node
scrcpy
screen
sleepwatcher
telnet
watch
wget
zsh-completions
' | xargs -n1 brew install

brew tap homebrew/command-not-found

#	open AppStore
mas open

#	install AppStore apps
echo '
1295203466	Microsoft Remote Desktop
1494023538	Plash
494803304	WiFi Explorer
824183456	Affinity Photo
937984704	Amphetamine
' | awk '{ print $1 }' | xargs -n1 mas install

osascript -e 'delay 1' -e 'tell application "App Store" to quit'

#	install zsh
sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

cp ./macos/JetBrainsMono.ttf $HOME/Library/Fonts
open ./macos/Argonaut.terminal // TODO
osascript -e 'delay 1' -e 'tell application "Terminal" to close front window'
defaults write com.apple.terminal "Default Window Settings" "Argonaut"
defaults write com.apple.terminal "Startup Window Settings" "Argonaut"
cp ./macos/zshrc $HOME/.zshrc
cp ./macos/zprofile $HOME/.zprofile

#	Disable Crash Reporter
launchctl unload -w /System/Library/LaunchAgents/com.apple.ReportCrash.plist
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist

#	Keep network active when screen is locked
sudo pmset -a networkoversleep 1

#	Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

./macos/defaults.sh

osascript -e 'display alert "Setup complete" as informational'