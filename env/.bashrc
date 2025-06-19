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


<<<<<<< Updated upstream
=======
which go > /dev/null 2>&1
GO_EXISTS_EXIT_CODE=$?


export BASH_SILENCE_DEPRECATION_WARNING=1

>>>>>>> Stashed changes
if [[ -d "$HOME/.bashrc.d" ]]; then
    for file in "$HOME"/.bashrc.d/*.bashrc; do
      filename=$( basename $file )
      if [[ $filename == "go.bashrc" ]]; then
        if [[ $GO_EXISTS_EXIT_CODE == 0 ]]; then
          [ -f "$file" ] && source "$file"
        fi
      else
        [ -f "$file" ] && source "$file"
      fi
    done
fi

