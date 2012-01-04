all: screen tmux zsh

screen:
	ln -fs ${PWD}/.screenrc ${HOME}/.screenrc

tmux:
	ln -fs ${PWD}/.tmux.conf ${HOME}/.tmux.conf

zsh:
	ln -fs ${PWD}/.zshrc ${HOME}/.zshrc

