#!/usr/bin/env bash
# Make sure my bin and scripts are on PATH
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/scripts


# Set Global variables
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export VISUAL=vi
export EDITOR=vi

if [[ -d "$HOME/.bashrc.d" ]]; then
    for file in "$HOME"/.bashrc.d/*.bashrc; do
        [ -f "$file" ] && source "$file"
    done
fi

