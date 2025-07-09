#!/usr/bin/env bash

# Define colors correctly
grn='\[\033[01;32m\]'        # Green
cyn='\[\033[01;36m\]'        # Cyan
blu='\[\033[01;34m\]'        # Blue
orange='\[\033[38;5;208m\]'
dull_cyan='\[\033[38;5;72m\]'
washed_out_orange='\[\033[38;5;216m\]'
grey='\[\033[0;90m\]'
clr='\[\033[00m\]'           # Reset color


export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
