all: screen tmux zsh emacs git

screen:
	ln -fs ${PWD}/.screenrc ${HOME}/.screenrc

tmux:
	ln -fs ${PWD}/.tmux.conf ${HOME}/.tmux.conf

zsh:
	ln -fs ${PWD}/.zshrc ${HOME}/.zshrc
	test -d ${HOME}/.zshrc.d || mkdir ${HOME}/.zshrc.d

emacs:
	ln -fsn ${PWD}/.emacs.d ${HOME}/.emacs.d

git:
	ln -fs ${PWD}/.gitconfig ${HOME}/.gitconfig

