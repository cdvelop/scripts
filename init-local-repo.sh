#!/bin/bash

source ./functions.sh

init_readme_file() {
    local current_folder=$1

    execute "echo '# $current_folder' >> README.md" \
        "Failed to create README.md" \
        "README.md created" || return $?

    return 0
}

init_change_txt_file() {
    local current_folder=$1

    execute "echo 'init code' >> changes.txt" \
        "Failed to create changes.txt" \
        "changes.txt created" || return $?

    return 0
}

init_git_repo() {
    local current_folder=$1
    local remote_url=$2

    if [ -d ".git" ]; then
        warning "Directory already initialized with Git: $current_folder"
        return 1
    }

    execute "git init" \
        "Failed to initialize git" \
        "Git repository initialized" || return $?

    execute "git branch -M main" \
        "Failed to rename branch" || return $?

    return 0
}

create_initial_commit() {
    execute "git add ." \
        "Failed to stage files" || return $?

    execute "git commit -m 'Initial commit'" \
        "Failed to commit" \
        "Files committed" || return $?

    return 0
}

setup_git_remote() {
    local current_folder=$1
    local remote_url=$2

    execute "git remote add origin https://$remote_url/$current_folder.git" \
        "Failed to add remote" \
        "Remote added successfully" || return $?

    execute "git push -u origin main" \
        "Failed to push to remote" \
        "Pushed to remote" || return $?

    return 0
}

create_git_tag() {
    local tag_name=${1:-"v0.0.1"}

    execute "git tag $tag_name" \
        "Failed to create tag" \
        "Tag created: $tag_name" || return $?

    execute "git push origin $tag_name" \
        "Failed to push tag" \
        "Tag pushed to remote" || return $?

    return 0
}

# Main function that orchestrates the whole process
setup_git_project() {
    local current_folder=$(basename "$(pwd)")

    init_readme_file "$current_folder" || return $?
    init_change_txt_file "$current_folder" || return $?
    init_git_repo "$current_folder" "$currentGitHostUserPath" || return $?
    create_initial_commit || return $?
    setup_git_remote "$current_folder" "$currentGitHostUserPath" || return $?
    create_git_tag || return $?

    return 0
}

# Execute directly if script is not being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_git_project
    exit_code=$?
    successMessages
    exit $exit_code
fi