all: tmux zsh git

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
	ln -fs ${PWD}/.gitignore_global ${HOME}/.gitignore_global
	ln -fsn ${PWD}/.git.hooks.d ${HOME}/.git.hooks.d

gwq:
	test -d ${HOME}/.config/gwq || mkdir -p ${HOME}/.config/gwq
	ln -fs ${PWD}/.config/gwq/config.toml ${HOME}/.config/gwq/config.toml

eslint:
	ln -fs ${PWD}/.eslintrc ${HOME}/.eslintrc
