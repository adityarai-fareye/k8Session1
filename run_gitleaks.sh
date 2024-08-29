#!/bin/bash

set -e

GITHUB_TOKEN="$1"
PULL_REQUEST_NUMBER="$2"

# check_gitleaks_installed() {
#     if command -v gitleaks >/dev/null 2>&1; then
#         echo "Gitleaks is already installed."
#     else
#         echo "Installing Gitleaks..."
#         curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.18.2/gitleaks_8.18.2_linux_x64.tar.gz -o gitleaks.tar.gz
#         tar -xzf gitleaks.tar.gz
#         chmod +x gitleaks
#         mv gitleaks /usr/local/bin/
#         rm gitleaks.tar.gz
#     fi
# }

# execute_gitleaks() {
#     echo "Fetching pull request #$PULL_REQUEST_NUMBER..."
#     git fetch origin pull/${PULL_REQUEST_NUMBER}/head:pull_request_branch

#     echo "Checking out pull request branch..."
#     git checkout pull_request_branch

#     echo "Running Gitleaks..."
#     GITHUB_TOKEN="$GITHUB_TOKEN" gitleaks detect -s . -v
# }

function git_commit_check(){
    cd ${PWD}
    last_commit_sha=""
    ## if flow trigger is due to tag
    [ "$(echo "$GITHUB_REF"  | grep -i  tags)" ] && { current_tag_version=${GITHUB_REF/refs\/tags\//} ;}
    if [ ! -z "$current_tag_version" ]; then
    last_commit_sha=$current_tag_version
    elif [ "$(helper_is_scheduled_run)" == "true" ]; then
    if [ ! -f .devops/last_commit_hash.txt ]; then
        git_update_last_commit_hash
        last_commit_sha=$(cat .devops/last_commit_hash.txt | xargs)
        first_run="true"
    else
        last_commit_sha=$(cat .devops/last_commit_hash.txt | xargs)
        git_update_last_commit_hash
    fi
    else
    last_commit_sha=$GITHUB_SHA
    fi
    if [ ! "$first_run" == "true" ] && [ "$(helper_is_scheduled_run)" == "true" ] ; then
    git_check_if_change_exists "$last_commit_sha"
    fi
    echo "last_commit_hash=$last_commit_sha" >> $GITHUB_ENV
    export "last_commit_hash=$last_commit_sha"
    if [ -z "$last_commit_hash" ]; then
    echo "no commits found"
    exit 0
    fi
}

function helper_is_scheduled_run(){
	if [ "$GITHUB_EVENT_NAME" == "schedule" ]; then
	  echo "true"
	else
	  echo "false"
  fi
}

function git_update_last_commit_hash(){
    pushd "$GITHUB_WORKSPACE"
    git log --pretty=format:'%H' -n 1 > .devops/last_commit_hash.txt
    git add -f .devops/last_commit_hash.txt
    git commit -m "updating last commit hash ID"
    git push
    popd
}

function git_check_if_change_exists(){
  git branch
  git config pull.ff only
  git fetch origin
  git pull
  number_of_files_changed=$(git diff "$1"..HEAD --name-only | uniq | wc -l)
  if [ "$number_of_files_changed" == "1" ]; then
    # check if only file changed is of ci_framework
    [ ! -z "$(git diff $1..HEAD --name-only | uniq | grep -i '.devops/')" ] && { email_set_email_env_vars; email_write_content "Build SKIP : No change Found"; echo "Build SKIP : No change Found"; exit 0; }
  fi
  [ $number_of_files_changed -lt 1 ] && { email_set_email_env_vars ;email_write_content "Build SKIP : No change Found"; echo "Build SKIP : No change Found"; exit 0; }
  echo "change found"
}

function email_set_email_env_vars(){
    echo "email_to=${email_to},$1" >> $GITHUB_ENV
    echo "email_from=${email_from}" >> $GITHUB_ENV
    echo "email_cc=${email_cc}" >> $GITHUB_ENV
    echo "email_bcc=${email_bcc}" >> $GITHUB_ENV
}

function email_write_content(){
    content_to_write="$1"
    echo -e "$content_to_write" | sed 's/_/\&#95\;/g' >> "$email_body_file_location"
    echo -e "<br>" >> "$email_body_file_location"
}

# check_gitleaks_installed
# execute_gitleaks
git_commit_check