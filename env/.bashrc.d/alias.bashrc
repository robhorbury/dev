#!/usr/bin/env bash

# Custom aliases
alias ls="ls --color=auto"
alias hg="history | grep"
alias vim="nvim"
alias sshagent="eval $(ssh-agent -s)"
alias sshagent_kill="ps aux | grep ssh-agent | awk '{print $1}' | xargs kill"
alias tree="git ls-files --exclude-standard | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

alias load_bash="source $HOME/.bash_profile"


function yt-download () {

yt-dlp -x --no-playlist --audio-format  mp3 --audio-quality 0 -o "%(title)s.%(ext)s" "$1"

}

# Get rid of hanging agent:
sshagent_kill &> /dev/null
