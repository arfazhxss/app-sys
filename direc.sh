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

  # List the subdirectories in the current directory, excluding those that start with a dot and node_modules
  find "$dir" -maxdepth 1 -type d ! -path "$dir" | while read -r subdir; do
    if [[ "$(basename "$subdir")" != .* && "$(basename "$subdir")" != "node_modules" ]]; then
      echo "${indent}├── $(basename "$subdir")/" >> "$output_file"
      list_structure "$subdir" "${indent}│   " "$output_file"
    fi
  done
}

# Output file
output_file="README.md"

# Clear the output file if it exists
> "$output_file"

# Write the Markdown header and code block start
echo "# Directory Structure" >> "$output_file"
echo "" >> "$output_file"
echo '```' >> "$output_file"

# Start listing from the current directory with no initial indentation
list_structure "." "" "$output_file"

# Write the code block end
echo '```' >> "$output_file"

echo "Directory structure has been saved to $output_file"
