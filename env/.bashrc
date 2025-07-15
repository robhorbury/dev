#!/usr/bin/env bash
# Make sure my bin and scripts are on PATH
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/scripts


# Set Global variables
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

<<<<<<< Updated upstream
export VISUAL=vi
export EDITOR=vi
=======
export PATH=$PATH:$XDG_DATA_HOME/uv/python/cpython-3.10.17-macos-aarch64-none/bin


which nvim > /dev/null 2>&1
NVIM_EXISTS_EXIT_CODE=$?

which vim > /dev/null 2>&1
VIM_EXISTS_EXIT_CODE=$?

if [[ $NVIM_EXISTS_EXIT_CODE == 0 ]]; then
  export VISUAL=nvim
  export EDITOR=nvim
elif [[ $VIM_EXISTS_EXIT_CODE == 0 ]]; then
  export VISUAL=vim
  export EDITOR=vim
else
  export VISUAL=vi
  export EDITOR=vi
fi

>>>>>>> Stashed changes


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


which go > /dev/null 2>&1
GO_EXISTS_EXIT_CODE=$?


export BASH_SILENCE_DEPRECATION_WARNING=1

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

if [[ -n "$TERMINAL_BG_COLOR" ]]; then
  # Send the escape sequence to the terminal to change background color
  printf "$TERMINAL_BG_COLOR"
fi
