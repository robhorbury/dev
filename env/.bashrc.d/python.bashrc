#!/usr/bin/env bash

# Set environment variables for configuration files
export UV_CONFIG_FILE="$XDG_CONFIG_HOME/uv/uv.toml"
export PIP_CONFIG_FILE="$XDG_CONFIG_HOME/pip/pip.ini"
export PYSPARK_PYTHON=python
export PYTHONDONTWRITEBYTECODE=1

# Alias for Python-related commands
alias pip="python -m pip"
alias pytest="python -m pytest"
alias qpytest="LOG_LEVEL=CRITICAL pytest --quiet"
alias ruff="python -m ruff"

# Debug flag (set to 1 to enable debug messages)
DEBUG=0

# Function for debugging messages
function debug() {
    [[ $DEBUG -eq 1 ]] && echo "$1" >&2
}

# Function to deactivate the current virtual environment if any
function deactivate_venv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        debug "Deactivating venv: $VIRTUAL_ENV"
        deactivate || echo "Failed to deactivate virtualenv: $VIRTUAL_ENV"
    fi
}

# Function to find and activate the closest virtual environment
function activate_venv() {
    # Use venv-lookup to find the closest venv and its activate script
    local venv_path
    venv_path=$(venv-lookup --source "$HOME/personal" "$HOME/work" --target "$PWD" 2>&1)  # Capture both stdout and stderr

    # Check if the output from venv-lookup contains "No venv found"
    if [[ "$venv_path" == *"No venv found"* ]]; then
        # If we are in a venv, deactivate it
        if [[ -n "$VIRTUAL_ENV" ]]; then
            deactivate_venv
        fi
        debug "No venv found for the current directory or its ancestors"
    else
        # If a venv is found, continue the activation process
        debug "Found venv at $venv_path"

        # If we're already in the same venv, no need to activate it
        if [[ "$VIRTUAL_ENV" != "$venv_path" ]]; then
            debug "Activating venv at $venv_path"
            # Find the appropriate activate script using the binary
            local activate_script
            activate_script=$(venv-lookup --source "$HOME/personal" "$HOME/work" --target "$PWD" --activate 2>/dev/null)
            
            if [[ -n "$activate_script" ]]; then
                debug "Sourcing activate script: $activate_script"
                source "$activate_script"
            else
                debug "Error: No activate script found in $venv_path"
            fi
        else
            debug "Already in the correct venv: $VIRTUAL_ENV"
        fi
    fi
}

# Track the current directory and detect when it changes
function on_directory_change() {
    # Call the function to activate the appropriate virtual environment or deactivate it
    activate_venv
}

# Watch for changes in the directory and apply the venv update
PROMPT_COMMAND="on_directory_change; $PROMPT_COMMAND"

