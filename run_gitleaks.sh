#!/bin/bash

set -e

check_gitleaks_installed() {
    if command -v gitleaks >/dev/null 2>&1; then
        echo "Gitleaks is already installed."
    else
        echo "Installing Gitleaks..."
        curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.18.2/gitleaks_8.18.2_linux_x64.tar.gz -o gitleaks.tar.gz
        tar -xzf gitleaks.tar.gz
        chmod +x gitleaks
        mv gitleaks /usr/local/bin/
        rm gitleaks.tar.gz
    fi
}

execute_gitleaks() {
    GITHUB_TOKEN="$1"
    PULL_REQUEST_NUMBER="$2"
    echo "Fetching pull request #$PULL_REQUEST_NUMBER..."
    git fetch origin pull/${PULL_REQUEST_NUMBER}/head:pull_request_branch

    echo "Checking out pull request branch..."
    git checkout pull_request_branch

    echo "Running Gitleaks..."
    GITHUB_TOKEN="$GITHUB_TOKEN" gitleaks detect -s . -v
}

check_gitleaks_installed
execute_gitleaks