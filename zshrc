export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

plugins=(
	zsh-autosuggestions
	zsh-syntax-highlighting
	colored-man-pages
)

alias apt="sudo apt"

source $ZSH/oh-my-zsh.sh

xc() {
	xclip $@
	xclip -o | xclip -selection clipboard
}

xv() {
	xclip -o
}