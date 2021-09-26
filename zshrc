export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

plugins=(
	zsh-autosuggestions
	zsh-syntax-highlighting
	colored-man-pages
	command-not-found
	brew
	adb
	osx
)

DISABLE_UPDATE_PROMPT=true

source $ZSH/oh-my-zsh.sh

alias p1="ping 1.1.1.1"

alias upg="brew update && brew upgrade && mas upgrade && softwareupdate -i -a"

export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
