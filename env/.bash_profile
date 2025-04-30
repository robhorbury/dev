HISTFILESIZE=10000
HISTCONTROL=erasedups:ignoresace
HISTIGNORE="ls:ll:export *:history:hg:exit: *:source *.venv/Scripts/activate :tmux-sessionizer"

export PROMPT_COMMAND="history -a"


# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

cd .
