#!/bin/bash

set -e

GITHUB_TOKEN="$1"
PULL_REQUEST_NUMBER="$2"
# GITHUB_EVENT="$2"

check_gitleaks_installed() {
    if command -v gitleaks >/dev/null 2>&1; then
        echo "Gitleaks is already installed."
    else
        echo "Installing Gitleaks..."
        curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.16.1/gitleaks_8.16.1_linux_x64.tar.gz -o gitleaks.tar.gz
        tar -xzf gitleaks.tar.gz
        chmod +x gitleaks
        mv gitleaks /usr/local/bin/
        rm gitleaks.tar.gz
        echo "Gitleaks installed"
    fi
}

execute_gitleaks() {
        echo "Running Gitleaks..."
    echo "gitleaks cmd: gitleaks detect --redact -v --exit-code=2 --report-format=sarif --report-path=results.sarif --log-level=debug --log-opts=--no-merges --first-parent $first_commit_sha^..$last_commit_sha"
    echo "Running Gitleaks...2"
    gitleaks detect --redact -v --exit-code=2 --log-level=debug --log-opts=--no-merges --first-parent $first_commit_sha^..$last_commit_sha
    # gitleaks detect --source . --log-opts="--all $first_commit_sha..$last_commit_sha
    # echo "Fetching pull request #$PULL_REQUEST_NUMBER..."
    # git fetch origin pull/${PULL_REQUEST_NUMBER}/head:pull_request_branch

    # echo "Checking out pull request branch..."
    # git checkout pull_request_branch

    # echo "Running Gitleaks..."
    # GITHUB_TOKEN="$GITHUB_TOKEN" gitleaks detect -s . -v
}

REPO="${GITHUB_REPOSITORY}"
# PR_NUMBER="${GITHUB_EVENT_PULL_REQUEST_NUMBER}"
# GITHUB_TOKEN="${GITHUB_TOKEN}"

#!/bin/bash

# Define a method to handle the fetching and processing of commits
fetch_first_and_last_commit_for_pull_request() {
    echo "Repository: $repo"
    echo "Pull Request Number: $PULL_REQUEST_NUMBER"
    echo "GitHub Token: $GITHUB_TOKEN"

    # Fetch the commits from the pull request using the GitHub API
    commits=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
      "https://api.github.com/repos/adityarai-fareye/k8Session1/pulls/$PULL_REQUEST_NUMBER/commits")

    # Check if the response is an array and contains elements
    if echo "$commits" | jq -e '.[0]' > /dev/null 2>&1; then
        first_commit_sha=$(echo "$commits" | jq -r '.[0].sha')
        
        last_commit_sha=$(echo "$commits" | jq -r '.[-1].sha')
        
        echo "The first commit SHA is: $first_commit_sha"
        echo "The last commit SHA is: $last_commit_sha"

        echo "last_commit_sha=$first_commit_sha" >> $GITHUB_ENV
        echo "last_commit_sha=$last_commit_sha" >> $GITHUB_ENV
    else
        echo "Error: Unexpected response structure or no commits found."
        echo "$commits" | jq .
        exit 1
    fi
}


# echo "$REPO"
# echo "$PR_NUMBER"
# echo "$GITHUB_TOKEN"
# echo "$PULL_REQUEST_NUMBER"
# # Fetch the commits from the pull request using the GitHub API
# commits=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
#   "https://api.github.com/repos/adityarai-fareye/k8Session1/pulls/$PULL_REQUEST_NUMBER/commits")

# # echo "$commits commits"
# # Extract the first commit SHA using jq
# first_commit_sha=$(echo "$commits" | jq -r '.[0].sha')

# if echo "$commits" | jq -e '.[0]' > /dev/null 2>&1; then
#     # Extract the last commit SHA using jq
#     last_commit_sha=$(echo "$commits" | jq -r '.[-1].sha')
    
#     # Print the last commit SHA
#     # echo "The last commit SHA is: $last_commit_sha"

#     # Optionally, export the last commit SHA to an environment variable
#     echo "last_commit_sha=$last_commit_sha" >> $GITHUB_ENV
# else
#     echo "Error: Unexpected response structure or no commits found."
#     echo "$commits" | jq .
#     exit 1
# fi

# # Print the first commit SHA
# echo "The first commit SHA is: $first_commit_sha"
# echo "The last commit SHA is: $last_commit_sha"

# Optionally, export the first commit SHA to an environment variable
# echo "first_commit_sha=$first_commit_sha" >> $GITHUB_ENV


fetch_first_and_last_commit_for_pull_request
check_gitleaks_installed
execute_gitleaks