#!/bin/bash

source ./functions.sh

init_project() {
    # Setup basic go project structure
    if ! ./go-project-init.sh; then
        error "Failed to initialize go project"
        return 1
    }

    # Run additional initialization if needed
    if [ -f "./init.sh" ]; then
        if ! ./init.sh; then
            error "Failed to run custom initialization"
            return 1
        fi
    fi

    return 0
}