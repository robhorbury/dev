#!/usr/bin/env bash

# Set environment variables for configuration files
export UV_CONFIG_FILE="$XDG_CONFIG_HOME/uv/uv.toml"
export PIP_CONFIG_FILE="$XDG_CONFIG_HOME/pip/pip.ini"
export PYSPARK_PYTHON=python
export PYTHONDONTWRITEBYTECODE=1
export local_host_ip=$(cat /etc/hosts | grep "\tlocalhost" | awk '{sub(/\t.*/,x)}1')
export SPARK_LOCAL_IP=$local_host_ip

PYTHON_VENV_VERSION=3.11
IGNORE_PRE_COMMIT=1

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

if [[ -z "$LAST_DIR" ]]; then
    LAST_DIR="$PWD"
fi

# Track the current directory and detect when it changes
function on_directory_change() {
    # Call the function to activate the appropriate virtual environment or deactivate it
    if [[ "$PWD" != "$LAST_DIR" ]]; then
        LAST_DIR="$PWD"
        deactivate_venv
        fi
    activate_venv
    }





function setup_python_personal_pre_commit() {

  usage=$( cat <<EOF
Usage: $0 [OPTIONS]
Options:
  --help            Display this help message
  --include (-i)    Track files with git
EOF
)

  while [ $# -gt 0 ]; do
    case $1 in
      --include)          IGNORE_PRE_COMMIT=0;;
      --help)             echo "$usage"; return 0 ;;
      -h)                 echo "$usage"; return 0 ;;
      *)                  echo "Unknown option: $1"; return 1 ;;
    esac
    shift
  done

  # Install dependencies
  uv pip install ruff
  uv pip install commitizen
  uv pip install codespell
  #Copy template files over
  scp $HOME/.local/templates/.pre-commit-config.yaml ./
  scp $HOME/.local/templates/.cz.toml ./

  python -m pre_commit install

  if [[ $IGNORE_PRE_COMMIT == 1 ]]; then
  git_ignore_list=(
    ".cz.toml"
    ".pre-commit-config.yaml"
    )
  append_lines_to_file ".git/info/exclude" "${git_ignore_list[@]}"
  fi


}


function init_python_project() {

  usage=$( cat <<EOF
Usage: $0 [OPTIONS]
Options:
  --help                    Display this help message
  --version (-v)            Specify python version (default: $PYTHON_VENV_VERSION)
  --no-pre-commit (-np)     Do not setup pre-commit
  --include (-i)            Include pre-commit files in git
EOF
)
INCLUDE_PRE_COMMIT=0
NO_PRE_COMMIT=0

  while [ $# -gt 0 ]; do
    case $1 in
      --version)          PYTHON_VENV_VERSION=$2; shift;;
      -v)                 PYTHON_VENV_VERSION=$2; shift;;
      --include)          INCLUDE_PRE_COMMIT=1;;
      -i)                 INCLUDE_PRE_COMMIT=1;;
      --no-pre-commit)    NO_PRE_COMMIT=1;;
      --np)               NO_PRE_COMMIT=1;;
      --help)             echo "$usage"; return 0;;
      -h)                 echo "$usage"; return 0;;
      *)                  echo "Unknown option: $1"; return 1 ;;
    esac
    shift
  done

  if [[ ! -d "./.git" ]]; then
    git init
  fi

  uv venv -p $PYTHON_VENV_VERSION
  refresh_venv
  uv pip install python-lsp-ruff

  git_ignore_list=(
    ".databricks"
    ".venv"
    ".coverage"
    "coverage.xml"
    "junit"
    "branch"
    "build"
    "dist"
    "*.egg-info"
    ".pylintrc"
    ".vscode"
    ".databricks"
    "__pycache__"
    ".pytest_cache"
    "typings"
    ".mypy_cache"
    )

  append_lines_to_file ".gitignore" "${git_ignore_list[@]}"

  if [[ $NO_PRE_COMMIT == 0 ]]; then
    if [[ $INCLUDE_PRE_COMMIT == 1 ]]; then
      setup_python_personal_pre_commit --include
    else
      setup_python_personal_pre_commit
    fi
  fi

}


# Watch for changes in the directory and apply the venv update
PROMPT_COMMAND="on_directory_change; $PROMPT_COMMAND"

