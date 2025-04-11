#!/usr/bin/env bash

NAME="RobHorbury"

# Function to get the current Git branch
function git_branch() {
    # Get branch name or commit hash if detached
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

    if [ -n "$branch" ]; then
        echo " ($branch)"
    fi
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX specific setup
    tmux=$(which tmux)
    alias tmux="$tmux -2"
    bind '"\C-f":"tmux-sessionizer\n"'

    # Function to set up the prompt
    #
    function bash_prompt() {
        PS1="${cyn}${NAME}:${blu} \W${grn}$(git_branch)${clr} \$ "
    }

    # Apply the prompt function dynamically
    PROMPT_COMMAND=bash_prompt
else
    # Windows setup
    # Function to set up the prompt
    function bash_prompt() {
        PS1="${cyn}${NAME}:${blu} \W${orange}$(git_branch)${clr} \$ "
    }

    # Apply the prompt function dynamically
    PROMPT_COMMAND=bash_prompt
fi
