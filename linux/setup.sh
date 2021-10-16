#!/bin/bash

#	ask for sudo acces at start
sudo -v

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


#	install apps
sudo apt update
sudo apt upgrade -y
sudo apt install -y gnome-session gnome-terminal gnome-system-monitor gnome-tweaks nautilus nautilus-admin openssh-server git gparted google-chrome-stable code spotify-client zsh vlc eog fonts-powerline xclip binutils nmap gobuster curl net-tools

sudo apt purge -y --auto-remove gedit gnome-user-docs info

#	terminal/zsh

sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

sudo chsh -s `which zsh` $USER
cp ./linux/zshrc $HOME/.zshrc

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

VS_CODE_DIR=$HOME/.config/Code/User/

mkdir -p $VS_CODE_DIR
cp ./vscode/* $VS_CODE_DIR

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

printf "\n\n\n          DONE \n\n\n"