#!/bin/bash

echo "Building all images and creating all containers."

# Define base home directory of all containers
export DBX_CONTAINER_HOME_PREFIX=${HOME}/Distrobox

# Set directory as starting point to find all Containerfiles to build
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find all files named "Containerfile" starting from the script's directory, excluding .git directories
find "$script_dir" -type d -name ".git" -prune -o -type f -name 'Containerfile' -print | while IFS= read -r container_file_path; do
    # Get the directory containing the Containerfile
    dir="$(dirname "$container_file_path")"
    
    # Determine the subdir variable
    if [ "$dir" = "$script_dir" ]; then
        container_name="base"
    else
        container_name="$(basename "$dir")"
    fi

    # Run the specific command with the Containerfile and subdir as parameters
    # Replace 'mycommand' with your actual command
    #mycommand "$containerfile" "$subdir"
    #echo "Found ${container_file_path} with container name ${container_name}"
    podman build -t ${container_name} -f ${container_file_path}
done

distrobox assemble create --file ./distrobox.ini
