#!/bin/bash

#	ask for sudo acces at start
sudo -v

if [[ "$(uname)" =~ Darwin ]]; then
	#	macOS

	#	Enable TouchID for sudo access
	sudo cp ./macos/pamd_sudo /etc/pam.d/sudo

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

	echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/wilkmaciej/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"

	#	update brew
	brew update
	brew upgrade

	#	install brew apps
	echo '
	android-file-transfer
	android-platform-tools
	balenaetcher
	chrome-remote-desktop-host
	google-chrome
	gpg-suite
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

	#	open AppStore
	mas open

	#	Wait for AppStore login
	while
		mas account 1>/dev/null 2>/dev/null
		[[ $? -eq 1 ]]
	do
		sleep 0.5
	done

	osascript -e 'delay 1' -e 'tell application "App Store" to quit'

	echo '
	1295203466	Microsoft Remote Desktop
	1494023538	Plash
	1543920362	Displaperture
	595191960	CopyClip
	824183456	Affinity Photo
	' | awk '{ print $1 }' | xargs -n1 mas install

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

sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

if [[ "$(uname)" =~ Darwin ]]; then
	cp ./macos/JetBrainsMono.ttf $HOME/Library/Fonts
	open ./macos/Argonaut.terminal && osascript -e 'delay 1' -e 'tell application "Terminal" to close front window'
	defaults write com.apple.terminal "Default Window Settings" "Argonaut"
	defaults write com.apple.terminal "Startup Window Settings" "Argonaut"
	cp ./zshrc $HOME/.zshrc
else
	sudo chsh -s `which zsh` $USER
	cat ./zshrc ./linux/zshrc > $HOME/.zshrc
fi

#	vs code
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

if [[ "$(uname)" =~ Darwin ]]; then
	VS_CODE_DIR=$HOME/Library/Application\ Support/Code/User/
else
	VS_CODE_DIR=$HOME/.config/Code/User/
fi

mkdir -p $VS_CODE_DIR
cp ./vscode/* $VS_CODE_DIR

if [[ "$(uname)" =~ Darwin ]]; then

	#	macOS

	./macos/defaults.sh
	
else
	#	LINUX

	#	themes
	sudo unzip ./linux/apperence.zip -d /usr/share
	export DISPLAY=":0"
	dbus-launch dconf load / < ./linux/dconf

	#	create apps folder
	mkdir ~/apps/

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