#!/usr/bin/env bash

export PATH=$PATH:$HOME/go/bin
export GOPATH=$HOME/go
DEFAULT_GO_VERSION=$( go version | grep -o "[0-9].*[0-9].*[0-9] " )

function init_go_project() {

  usage=$( cat <<EOF
Usage: $0 [OPTIONS]
Options:
  --help                    Display this help message
EOF
)

  while [ $# -gt 0 ]; do
    case $1 in
      --help)             echo "$usage"; return 0;;
      -h)                 echo "$usage"; return 0;;
      *)                  echo "Unknown option: $1"; return 1 ;;
    esac
    shift
  done

  if [[ ! -d "./.git" ]]; then
    git init
  fi

  scp $HOME/.local/templates/.golangci.yml ./


}
