# README.md

# Project Documentation

## Overview

This project contains utility scripts for managing GitHub repositories using the GitHub CLI (`gh`). The main scripts included are `functions.sh` and `repocreate.sh`.

## Scripts

### functions.sh

This script contains utility functions for displaying messages and executing commands. The functions included are:

- `success`: Displays a success message in green.
- `warning`: Displays a warning message in yellow.
- `error`: Displays an error message in red.
- `execute`: Executes a command and handles success or error messages.
- `addOKmessage`: Adds a success message to the accumulated messages.

### repocreate.sh

This script utilizes the functions from `functions.sh` to create a new repository on GitHub. It prompts the user for repository details and uses the `gh` command to create the repository.

## Prerequisites

- Ensure you have the GitHub CLI installed on your system.
- Authenticate the GitHub CLI with your GitHub account using `gh auth login`.

## Usage

1. Open a terminal and navigate to the `scripts` directory.
2. Run the `repocreate.sh` script to create a new repository:
   ```bash
   ./repocreate.sh
   ```

Follow the prompts to enter the repository details.