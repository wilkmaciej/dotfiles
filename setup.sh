#!/bin/bash

if [[ "$(uname)" =~ Darwin ]]; then
	#	macOS

	#	install CLT for Xcode
	xcode-select --install

	#	install brew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	#	install brew apps
	brew install --cask google-chrome visual-studio-code spotify
	brew install binutils nmap gobuster wget gpg

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


#	zsh
sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
cp ./zshrc ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

if [[ "$(uname)" =~ Darwin ]]; then else
	sudo chsh -s `which zsh` $USER
	cat ./linux/zshrc >> ~/.zshrc
fi

#	vs code
echo '
aaron-bond.better-comments
christian-kohler.path-intellisense
CoenraadS.bracket-pair-colorizer-2
kohlbachjan.the-best-theme
mhutchie.git-graph
ms-python.python
ms-toolsai.jupyter
ms-vscode.vscode-typescript-next
PKief.material-icon-theme
streetsidesoftware.code-spell-checker
TabNine.tabnine-vscode
VisualStudioExptTeam.vscodeintellicode
' | xargs -L1 code --install-extension

if [[ "$(uname)" =~ Darwin ]]; then
	VS_CODE_DIR="~/Library/Application\ Support/Code/User/"
else
	VS_CODE_DIR="~/.config/Code/User/"
fi

mkdir -p $VS_CODE_DIR
cp ./vscode/* $VS_CODE_DIR

#	create apps folder
mkdir ~/apps/

if [[ "$(uname)" =~ Darwin ]]; then else
	#	LINUX

	#	themes
	sudo unzip ./linux/apperence.zip -d /usr/share
	export DISPLAY=":0"
	dbus-launch dconf load / < ./linux/dconf

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