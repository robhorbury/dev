## Ghostty shell integration for Bash. This should be at the top of your bashrc!
# if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
#     builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
# fi
export XDG_CONFIG_HOME=$HOME/.config/

# Define colors correctly
grn='\033[01;32m'  # Green
cyn='\033[01;36m'  # Cyan
blu='\033[01;34m'  # Blue
clr='\033[00m'     # Reset color

alias pip="python -m pip"
alias pytest="python -m pytest"
alias ruff="python -m ruff"

alias hg="history | grep"
alias vim="nvim"
alias sshagent="eval $(ssh-agent -s)"
alias sshagent_kill="ps aux | grep ssh-agent | awk '{print $1}' | xargs kill"

if [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
    tmux=$(which tmux)
    alias tmux="$tmux -2"
fi



export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/scripts
bind '"\C-f":"tmux-sessionizer\n"'


export PYTHONDONTWRITEBYTECODE=1
# Get the username correctly
function user() {
    echo "$(id -u -n)"
}

# Function to get the current Git branch
function git_branch() {
    # Get branch name or commit hash if detached
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    
    if [ -n "$branch" ]; then
        echo " ($branch)"
    fi
}

# Function to set up the prompt
function bash_prompt() {
    PS1="${cyn}$(user):${blu} \W${grn}$(git_branch)${clr} \$ "
}

# Apply the prompt function dynamically
PROMPT_COMMAND=bash_prompt


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval "$(zoxide init bash)"
