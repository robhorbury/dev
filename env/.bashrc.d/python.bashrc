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
