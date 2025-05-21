#!/usr/bin/env bash

# Set environment variables for configuration files
export UV_CONFIG_FILE="$XDG_CONFIG_HOME/uv/uv.toml"
export PIP_CONFIG_FILE="$XDG_CONFIG_HOME/pip/pip.ini"
export PYSPARK_PYTHON=python
export PYTHONDONTWRITEBYTECODE=1
export local_host_ip=$(cat /etc/hosts | grep "\tlocalhost" | awk '{sub(/\t.*/,x)}1')
export SPARK_LOCAL_IP=$local_host_ip

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
    local result
    result=$(venv-lookup -dir $(pwd))  # Capture both stdout and stderr
    $result
}

function refresh_venv_cache() {
    venv-lookup -refresh
}

function refresh_venv() {
    venv-lookup -refresh-dir $(pwd)
}

function clear_venv_cache() {
    venv-lookup -clear
}

# Track the current directory and detect when it changes
function on_directory_change() {
    # Call the function to activate the appropriate virtual environment or deactivate it
    activate_venv
}


# Watch for changes in the directory and apply the venv update
PROMPT_COMMAND="on_directory_change; $PROMPT_COMMAND"

