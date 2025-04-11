#!/usr/bin/env bash

# Set specific
export UV_CONFIG_FILE=$XDG_CONFIG_HOME/uv/uv.toml
export PIP_CONFIG_FILE=$XDG_CONFIG_HOME/pip/pip.ini
export PYTHONDONTWRITEBYTECODE=1
MYENV="./.venv"

# Alias for python
alias pip="python -m pip"
alias pytest="python -m pytest"
alias qpytest="LOG_LEVEL=CRITICAL pytest --quiet"
alias ruff="python -m ruff"

# Venv functions:
function venva () {
    source $MYENV/Scripts/activate
}
function dvenv {
        deactivate || print "Failed to deactivate virtualenv: .venv"
}

