gitleaks_scan_pull_request() {
    local GITHUB_TOKEN="$1"
    
    # Fetch the pull request
    git fetch origin pull/${{ github.event.pull_request.number }}/head:pull_request_branch
    
    # Checkout the pull request branch
    git checkout pull_request_branch
    
    # Run gitleaks
    GITHUB_TOKEN="$GITHUB_TOKEN" gitleaks -c /github/workspace
}

gitleaks_scan_pull_request