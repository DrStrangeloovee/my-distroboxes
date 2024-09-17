#!/bin/bash

echo "Building all images and creating all containers."

# Define base home directory of all containers
export DBX_CONTAINER_HOME_PREFIX=${HOME}/Distrobox

# Set directory as starting point to find all Containerfiles to build
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find all files named "Containerfile" starting from the script's directory, excluding .git directories
find "$SCRIPT_DIR" -type d -name ".git" -prune -o -type f -name 'Containerfile' -print | while IFS= read -r CONTAINER_FILE_PATH; do
    # Get the directory containing the Containerfile
    dir="$(dirname "$CONTAINER_FILE_PATH")"
    
    # Determine the subdir variable
    if [ "$dir" = "$SCRIPT_DIR" ]; then
        CONTAINER_NAME="base"
    else
        CONTAINER_NAME="$(basename "$dir")"
    fi

    # Run the specific command with the Containerfile and subdir as parameters
    # Replace 'mycommand' with your actual command
    #mycommand "$containerfile" "$subdir"
    #echo "Found ${CONTAINER_FILE_PATH} with container name ${CONTAINER_NAME}"
    podman build -t ${CONTAINER_NAME} -f ${CONTAINER_FILE_PATH}
done