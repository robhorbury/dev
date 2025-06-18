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


export BASH_SILENCE_DEPRECATION_WARNING=1

function append_line_to_file() {
  FILE="$1"
  LINE="$2"
  if [[ -f "$FILE" ]]; then
    grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
  else
    echo "$LINE" >> "$FILE"
  fi
}

function append_lines_to_file() {
  FILE="$1"

  for line in ${@: 2}
  do
      append_line_to_file $FILE $line
  done
}


if [[ -d "$HOME/.bashrc.d" ]]; then
    for file in "$HOME"/.bashrc.d/*.bashrc; do
        [ -f "$file" ] && source "$file"
    done
fi

