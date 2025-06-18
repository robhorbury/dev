#!/usr/bin/env bash

# Git functionality
function clean_git {
    # If we have no argument, then prune but do not force delete
    if [ -z "$1" ]
    then
        git fetch --prune
        git branch -vv | grep 'gone]' | awk '{print $1}' | xargs git branch -d
    else
        case $1 in
            -f)
            # With force flag, force deletion
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

