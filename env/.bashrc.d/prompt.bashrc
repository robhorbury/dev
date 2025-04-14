#!/usr/bin/env bash

NAME="RobHorbury"

# Function to get the current Git branch
function git_branch() {
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        echo " ($branch)"
    fi
}

# Function to get the active Python venv name
function venv_prompt() {
    last_2_names=""
    if [[ -n "$VIRTUAL_ENV" ]]; then
        last_2_names=`echo $VIRTUAL_ENV | awk -F/ '{print $(NF-1)"/"$(NF)}'`
        echo "(${last_2_names})"
    fi
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX specific setup
    tmux=$(which tmux)
    alias tmux="$tmux -2"
    bind '"\C-f":"tmux-sessionizer\n"'


    # Function to set up the prompt
    function bash_prompt() {
        venv=$(venv_prompt)
        newline=""
        [[ -n "$venv" ]] && newline="\n"
        PS1="${grey}${venv}${clr}${newline}${cyn}${NAME}:${blu} \W${grn}$(git_branch)${clr} \$ "
    }

    PROMPT_COMMAND=bash_prompt
else
    # Windows or other OS setup
    function bash_prompt() {
        venv=$(venv_prompt)
        newline=""
        [[ -n "$venv" ]] && newline="\n"
        PS1="${grey}${venv}${clr}${newline}${washed_out_orange}${NAME}:${blu} \W${dull_cyan}$(git_branch)${clr} \$ "
    }

    PROMPT_COMMAND=bash_prompt
fi

