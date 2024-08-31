#!/bin/bash

# Function to list the directory structure recursively
list_structure() {
  local dir="$1"
  local indent="$2"
  local output_file="$3"

  # List the files in the current directory
  find "$dir" -maxdepth 1 -type f | while read -r file; do
    echo "${indent}├── $(basename "$file")" >> "$output_file"
  done

  # List the subdirectories in the current directory
  find "$dir" -maxdepth 1 -type d ! -path "$dir" | while read -r subdir; do
    echo "${indent}├── $(basename "$subdir")/" >> "$output_file"
    list_structure "$subdir" "${indent}│   " "$output_file"
  done
}

# Output file
output_file="directory_structure.txt"

# Clear the output file if it exists
> "$output_file"

# Start listing from the current directory with no initial indentation
list_structure "." "" "$output_file"

echo "Directory structure has been saved to $output_file"

