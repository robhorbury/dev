#!/usr/bin/env bash

# Set specific
export UV_CONFIG_FILE=$XDG_CONFIG_HOME/uv/uv.toml
export PIP_CONFIG_FILE=$XDG_CONFIG_HOME/pip/pip.ini
export PYTHONDONTWRITEBYTECODE=1
MYVENV="./.venv"

# Alias for python
alias pip="python -m pip"
alias pytest="python -m pytest"
alias qpytest="LOG_LEVEL=CRITICAL pytest --quiet"
alias ruff="python -m ruff"

# Set the debug flag (set it to 1 to enable debug messages)
DEBUG=0

# List of possible locations for activate script
ACTIVATE_LOCATIONS=(
    "bin/activate"
    "Scripts/activate"
)

# Function for debugging messages
function debug() {
    if [[ $DEBUG -eq 1 ]]; then
        echo "$1" >&2
    fi
}

# Function to find the closest parent directory containing a .venv
function find_venv() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.venv" ]]; then
            debug "find_venv: Found .venv at $dir/.venv"
            printf "%s" "$dir/.venv"  # Proper return using printf
            return 0  # Exit early since we've found the venv
        fi
        dir=$(dirname "$dir")
    done
    printf ""  # Return empty if no .venv found
}

# Function to check for the activate script in the provided locations
function find_activate_script() {
    local closest_venv="$1"
    for location in "${ACTIVATE_LOCATIONS[@]}"; do
        local activate_script="$closest_venv/$location"
        debug "  searching: '$activate_script'"
        if [[ -f "$activate_script" ]]; then
            debug "Found activate script at $activate_script"
            printf "%s" "$activate_script"  # Proper return using printf
            return 0  # Exit early once we find the activate script
        fi
    done
    printf ""  # Return empty if no activate script is found
}


function venv_update() {
    local closest_venv
    closest_venv=$(find_venv)  # Capture the returned value from find_venv

    # If we're not in a virtual environment and a parent venv exists, activate it
    if [[ -z "$VIRTUAL_ENV" && -n "$closest_venv" ]]; then
        debug "Not in venv. Activating closest parent venv: $closest_venv"

        # Find the appropriate activate script and source it
        local to_source_activate_script
        to_source_activate_script=$(find_activate_script "$closest_venv")  # Capture the returned value
        debug "  trying to source '$to_source_activate_script'"
        if [[ -n "$to_source_activate_script" ]]; then
            source "$to_source_activate_script"
        else
            debug "Error: No activate script found in $closest_venv"
        fi

    # If we are already in a virtual environment
    elif [[ -n "$VIRTUAL_ENV" ]]; then
        debug "Already in venv: $VIRTUAL_ENV"

        # Check if we're stepping out of the current venv directory
        if [[ "$PWD" != "${VIRTUAL_ENV%/*}" ]]; then
            # Deactivate the current venv if we're stepping out of its directory
            debug "Detected directory change. Deactivating virtualenv: $VIRTUAL_ENV"
            deactivate || echo "Failed to deactivate virtualenv: $VIRTUAL_ENV"

            # If the closest parent venv is different from the current one, activate it
            if [[ -n "$closest_venv" && "$closest_venv" != "$VIRTUAL_ENV" ]]; then
                debug "Activating closest parent venv: $closest_venv"
                # Find the appropriate activate script and source it
                local activate_script
                activate_script=$(find_activate_script "$closest_venv")  # Capture the returned value
                if [[ -n "$activate_script" ]]; then
                    source "$activate_script"
                else
                    debug "Error: No activate script found in $closest_venv"
                fi
            fi
        fi
    fi
}

# Track the current directory and detect when it changes
function on_directory_change() {
    # Call venv_update to handle virtual environment setup when directory changes
    venv_update
}

# Watch for changes in the directory and apply the venv update when that happens
PROMPT_COMMAND="on_directory_change; $PROMPT_COMMAND"

