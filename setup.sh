#!/bin/bash

#	grub
sudo cp ./grub /etc/default/grub
sudo update-grub

#	keys

sudo apt update
sudo apt upgrade -y
sudo apt install -y software-properties-common

#	google chrome
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

#	vs code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
echo 'deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main' | sudo tee /etc/apt/sources.list.d/vscode.list

#	spotify
wget -qO- https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list


#	all apps

sudo apt update
sudo apt upgrade -y
sudo apt install -y gnome-session gnome-terminal gnome-system-monitor gnome-tweaks nautilus nautilus-admin openssh-server git gparted google-chrome-stable code spotify-client zsh vlc eog fonts-powerline xclip binutils nmap gobuster curl net-tools

sudo apt purge -y --auto-remove gedit gnome-user-docs info

#	zsh

sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
sudo chsh -s `which zsh` $USER
cp ./zshrc ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

#	vs code

echo '
aaron-bond.better-comments
christian-kohler.path-intellisense
CoenraadS.bracket-pair-colorizer-2
formulahendry.auto-close-tag
formulahendry.auto-rename-tag
mhutchie.git-graph
ms-python.python
ms-toolsai.jupyter
TabNine.tabnine-vscode
VisualStudioExptTeam.vscodeintellicode
' | xargs -L1 code --install-extension

mkdir -p ~/.config/Code/User/
cp ./settings.json ~/.config/Code/User/settings.json

#	themes

sudo unzip ./apperence.zip -d /usr/share

export DISPLAY=":0"

dbus-launch dconf load / < ./dconf

# create apps folder

mkdir ~/apps/

#	Postman

wget -O- https://dl.pstmn.io/download/latest/linux64 | tar -xzC ~/apps/

# Spotifyd

wget -O- https://github.com/Spotifyd/spotifyd/releases/latest/download/spotifyd-linux-full.tar.gz | tar -xzC ~/apps/

# Git Vanity

git clone https://github.com/tochev/git-vanity.git ~/apps/git-vanity/

# Hashcat

sudo apt install -y make gcc g++
git clone https://github.com/hashcat/hashcat.git /dev/shm/hashcat
CURRENT_DIR=$(pwd)
cd /dev/shm/hashcat
make
sudo make install
cd $CURRENT_DIR

#	Node

curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo setcap 'cap_net_bind_service=+ep' `which node`

#	network		!!!! DO IT AS LAST STEP

sudo cp ./netplan /etc/netplan/01-netcfg.yaml
sudo netplan apply

printf "\n\n\n          DONE \n\n\n"
