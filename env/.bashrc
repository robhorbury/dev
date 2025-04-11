## Ghostty shell integration for Bash. This should be at the top of your bashrc!
# if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
#     builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
# fi


export XDG_CONFIG_HOME=$HOME/.config/
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export UV_CONFIG_FILE=$XDG_CONFIG_HOME/uv/uv.toml
export PIP_CONFIG_FILE=$XDG_CONFIG_HOME/pip/pip.ini
export PYTHONDONTWRITEBYTECODE=1

export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/scripts
bind '"\C-f":"tmux-sessionizer\n"'


MYENV="./.venv"

# Define colors correctly
grn='\033[01;32m'  # Green
cyn='\033[01;36m'  # Cyan
blu='\033[01;34m'  # Blue
clr='\033[00m'     # Reset color

alias pip="python -m pip"
alias pytest="python -m pytest"
alias qpytest="LOG_LEVEL=CRITICAL pytest --quiet"
alias ruff="python -m ruff"

alias hg="history | grep"
alias vim="nvim"
alias sshagent="eval $(ssh-agent -s)"
alias sshagent_kill="ps aux | grep ssh-agent | awk '{print $1}' | xargs kill"
alias tree="git ls-files --exclude-standard | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

alias load_bash="source $HOME/.bash_profile"

function clean_git {
    if [ -z "$1" ]
    then
        git fetch --prune
        git branch -vv | grep 'gone]' | awk '{print $1}' | xargs git branch -d
    else
        case $1 in
            -f)
            echo "Forcing deletion"
            git fetch --prune
            git branch -vv | grep 'gone]' | awk '{print $1}' | xargs git branch -D
            ;;
            -h)
            echo "Pass -f flag to force branch deletion"
            ;;
            *)
            echo "Invalid flag: '$1'"
        esac
    fi
}



if [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
    tmux=$(which tmux)
    alias tmux="$tmux -2"
fi

function venva () {
  source $MYENV/Scripts/activate
}


function dvenv {
        deactivate || print "Failed to deactivate virtualenv: .venv"
}

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
eval "$(fzf --bash)"

function displayFZFFiles {
    echo $(fzf --preview 'bat --theme=gruvbox-dark --color=always --style=header,grid --line-range :400 {}')
}

function nvimGoToFiles {
    nvimExists=$(which nvim)
    if [ -z "$nvimExists" ]; then
      return;
    fi;

    selection=$(displayFZFFiles);
    if [ -z "$selection" ]; then
        return;
    else
        nvim $selection;
    fi;
}

function displayRgPipedFzf {
    echo $(rg . -n --glob "!.git/" --glob "!vendor/" --glob "!node_modules/" | fzf);
}

function nvimGoToLine {
    nvimExists=$(which nvim)
    if [ -z "$nvimExists" ]; then
      return;
    fi
    selection=$(displayRgPipedFzf)
    if [ -z "$selection" ]; then
      return;
    else 
        filename=$(echo $selection | awk -F ':' '{print $1}')
        line=$(echo $selection | awk -F ':' '{print $2}')
        nvim $(printf "+%s %s" $line $filename) +"normal zz";
    fi
}

function displayFZFFiles {
    echo $(fzf --preview 'bat --theme=gruvbox-dark --color=always --style=header,grid --line-range :400 {}')
}

export FZF_DEFAULT_OPTS='--prompt="🔭 " --height 80% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/" --glob "!node_modules/" --glob "!vendor/" --glob "!undo/" --glob "!plugged/"'

alias nf='nvimGoToFiles'
alias ngl='nvimGoToLine'

eval "$(zoxide init bash)"
