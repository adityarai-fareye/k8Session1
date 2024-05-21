#!/bin/bash

# Usage: ./run_gitleaks.sh GITHUB_TOKEN PULL_REQUEST_NUMBER

GITHUB_TOKEN="$1"
PULL_REQUEST_NUMBER="$2"

# Fetch the pull request branch
git fetch origin pull/${PULL_REQUEST_NUMBER}/head:pull_request_branch

# Checkout the pull request branch
git checkout pull_request_branch

# Run gitleaks
GITHUB_TOKEN="$GITHUB_TOKEN" gitleaks -c /github/workspace
