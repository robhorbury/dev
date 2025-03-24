HISTFILESIZE=10000
HISTCONTROL=erasedups:ignoresace
HISTIGNORE="ls:ll:export *:history:hg:exit: *:source *.venv/Scripts/activate"

export PROMPT_COMMAND="history -a"
cd .
