#!/bin/bash

#	ask for sudo acces at start
sudo -v

if [[ "$(uname)" =~ Darwin ]]; then
	#	macOS

	#	install CLT for Xcode
	xcode-select --install

	#	install brew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	#	update brew
	brew update
	brew upgrade

	#	install brew apps
	brew install --cask google-chrome visual-studio-code spotify vlc android-platform-tools ngrok gpg-suite
	brew install binutils nmap gobuster wget telnet arp-scan

else
	#	LINUX

	#	grub
	sudo cp ./linux/grub /etc/default/grub
	sudo update-grub

	#	keys
	sudo apt update
	sudo apt upgrade -y
	sudo apt install -y software-properties-common

	#	google chrome
	wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

	#	vs code
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
	echo 'deb https://packages.microsoft.com/repos/vscode stable main' | sudo tee /etc/apt/sources.list.d/vscode.list

	#	spotify
	wget -qO- https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list


	#	all apps
	sudo apt update
	sudo apt upgrade -y
	sudo apt install -y gnome-session gnome-terminal gnome-system-monitor gnome-tweaks nautilus nautilus-admin openssh-server git gparted google-chrome-stable code spotify-client zsh vlc eog fonts-powerline xclip binutils nmap gobuster curl net-tools

	sudo apt purge -y --auto-remove gedit gnome-user-docs info
fi

#	terminal/zsh

if [[ "$(uname)" =~ Darwin ]]; then
	cp ./macos/JetBrainsMono.ttf ~/Library/Fonts
	open ./macos/Argonaut.terminal && osascript -e 'delay 1' -e 'tell application "Terminal" to close front window'
	defaults write com.apple.terminal "Default Window Settings" "Argonaut"
	defaults write com.apple.terminal "Startup Window Settings" "Argonaut"
	cp ./zshrc ~/.zshrc
else
	sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
	sudo chsh -s `which zsh` $USER
	cat ./zshrc ./linux/zshrc > ~/.zshrc
fi

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

#	vs code
echo '
aaron-bond.better-comments
christian-kohler.path-intellisense
CoenraadS.bracket-pair-colorizer-2
kohlbachjan.the-best-theme
mhutchie.git-graph
ms-python.python
ms-python.vscode-pylance
ms-toolsai.jupyter
ms-vscode.vscode-typescript-next
PKief.material-icon-theme
rangav.vscode-thunder-client
streetsidesoftware.code-spell-checker
TabNine.tabnine-vscode
VisualStudioExptTeam.vscodeintellicode
' | xargs -n1 code --install-extension

if [[ "$(uname)" =~ Darwin ]]; then
	VS_CODE_DIR=~/Library/Application\ Support/Code/User/
else
	VS_CODE_DIR=~/.config/Code/User/
fi

mkdir -p $VS_CODE_DIR
cp ./vscode/* $VS_CODE_DIR

if [[ "$(uname)" =~ Darwin ]]; then

	#	macOS

	#	System preferences

	#	Disable the “Are you sure you want to open this application?” dialog
	defaults write com.apple.LaunchServices LSQuarantine -bool false

	#	Disable the warning when changing a file extension
	defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

	#	Enable opening folder on hover while holding item
	defaults write NSGlobalDomain com.apple.springing.enabled -bool true

	#	Avoid creating .DS_Store files on network or USB volumes
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

	#	Expand the following File Info panes:
	#	“General”, “Open with”, and “Sharing & Permissions”
	defaults write com.apple.finder FXInfoPanesExpanded -dict \
		General -bool true \
		OpenWith -bool true \
		Privileges -bool true
	
	#	Enable the automatic update check
	defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

	#	Check for software updates daily, not just once per week
	defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

	#	Download newly available updates in background
	defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

	#	Install System data files & security updates
	defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

	#	Turn on app auto-update
	defaults write com.apple.commerce AutoUpdate -bool true

	#	Use AirDrop over every interface
	defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

	#	Restart automatically if the computer freezes
	sudo systemsetup -setrestartfreeze on
else
	#	LINUX

	#	themes
	sudo unzip ./linux/apperence.zip -d /usr/share
	export DISPLAY=":0"
	dbus-launch dconf load / < ./linux/dconf

	#	create apps folder
	mkdir ~/apps/

	#	Postman
	wget -O- https://dl.pstmn.io/download/latest/linux64 | tar -xzC ~/apps/

	#	Spotifyd
	wget -O- https://github.com/Spotifyd/spotifyd/releases/latest/download/spotifyd-linux-full.tar.gz | tar -xzC ~/apps/

	#	Git Vanity
	git clone https://github.com/tochev/git-vanity.git ~/apps/git-vanity/

	#	Hashcat
	sudo apt install -y make gcc g++
	CURRENT_DIR=$(pwd)
	cd /dev/shm/hashcat
	git clone https://github.com/hashcat/hashcat.git
	make
	sudo make install
	cd $CURRENT_DIR

	#	Node
	curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
	sudo apt-get install -y nodejs
	sudo setcap 'cap_net_bind_service=+ep' `which node`

	#	Network		!!!! DO IT AS LAST STEP
	sudo cp ./linux/netplan /etc/netplan/01-netcfg.yaml
	sudo netplan apply
fi

printf "\n\n\n          DONE \n\n\n"