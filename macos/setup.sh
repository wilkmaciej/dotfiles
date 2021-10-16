#!/bin/bash

#	ask for sudo acces at start
sudo -v

#	Enable TouchID for sudo access and add daemon to enable it if needed
cp ./macos/enablesudotid.sh $HOME/.enablesudotid.sh
./macos/enablesudotid.sh
sed "s/USER/${USER}/g" ./macos/sudotid.plist | sudo dd of=/Library/LaunchDaemons/sudotid.plist

#	install CLT for Xcode
xcode-select --install

#	wait for CLT to install
while
	xcode-select -p 1>/dev/null 2>/dev/null
	[[ $? -eq 2 ]]
do
	sleep 0.5
done

#	install Rosetta
echo "A" | sudo softwareupdate --install-rosetta

#	install brew
printf "\n" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/opt/homebrew/bin/brew shellenv)"

#	update brew
brew update
brew upgrade

#	install brew apps
echo '
alt-tab
android-file-transfer
android-platform-tools
balenaetcher
chrome-remote-desktop-host
google-chrome
gpg-suite
inssider
inssider
nrlquaker-winbox
raycast
rectangle
spotify
stats
visual-studio-code
vlc
wireshark
' | xargs -n1 brew install --cask

echo '
arp-scan
binutils
eslint
gobuster
mas
nmap
node
screen
sleepwatcher
telnet
typescript
watch
wget
zsh-completions
' | xargs -n1 brew install

brew tap homebrew/command-not-found

#	open AppStore
mas open

osascript -e 'display alert "Log in to Apple Store" as informational'

#	Wait for AppStore login
while
	mas account 1>/dev/null 2>/dev/null
	[[ $? -eq 1 ]]
do
	sleep 0.5
done

osascript -e 'delay 1' -e 'tell application "App Store" to quit'

#	install AppStore apps
echo '
1295203466	Microsoft Remote Desktop
1494023538	Plash
1543920362	Displaperture
595191960	CopyClip
824183456	Affinity Photo
' | awk '{ print $1 }' | xargs -n1 mas install

#	install zsh
sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

cp ./macos/JetBrainsMono.ttf $HOME/Library/Fonts
open ./macos/Argonaut.terminal && osascript -e 'delay 1' -e 'tell application "Terminal" to close front window'
defaults write com.apple.terminal "Default Window Settings" "Argonaut"
defaults write com.apple.terminal "Startup Window Settings" "Argonaut"
cp ./macos/zshrc $HOME/.zshrc

#	install vs code extensions
echo '
aaron-bond.better-comments
christian-kohler.path-intellisense
CoenraadS.bracket-pair-colorizer-2
dbaeumer.vscode-eslint
eamodio.gitlens
esbenp.prettier-vscode
GitHub.copilot
kohlbachjan.the-best-theme
mhutchie.git-graph
ms-python.python
ms-python.vscode-pylance
ms-toolsai.jupyter
ms-toolsai.jupyter-keymap
ms-vscode-remote.remote-ssh
ms-vscode-remote.remote-ssh-edit
ms-vscode.vscode-typescript-next
PKief.material-icon-theme
rangav.vscode-thunder-client
richie5um2.vscode-sort-json
streetsidesoftware.code-spell-checker
TabNine.tabnine-vscode
Tyriar.sort-lines
VisualStudioExptTeam.vscodeintellicode
yzhang.markdown-all-in-one
' | xargs -n1 code --install-extension

VS_CODE_DIR=$HOME/Library/Application\ Support/Code/User/

mkdir -p $VS_CODE_DIR
cp ./vscode/* $VS_CODE_DIR

./macos/defaults.sh

osascript -e 'display alert "Setup complete" as informational'