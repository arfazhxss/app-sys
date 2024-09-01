#!/bin/bash

# Function to list the directory structure recursively
list_structure() {
  local dir="$1"
  local indent="$2"
  local output_file="$3"

  # Use git ls-files to list tracked files in the current directory
  git ls-files --cached --others --exclude-standard "$dir" | sort | while IFS= read -r file; do
    if [[ -f "$file" ]]; then
      echo "${indent}├── $(basename "$file")" >> "$output_file"
    elif [[ -d "$file" ]]; then
      echo "${indent}├── $(basename "$file")/" >> "$output_file"
      list_structure "$file" "${indent}│   " "$output_file"
    fi
  done
}

# Output file
output_file="README.md"

# Remove any existing .md files in the current directory
find . -maxdepth 1 -name '*.md' -type f -delete

# Create or clear the output file
: > "$output_file"

# Write the Markdown header and code block start
echo "# Directory Structure" >> "$output_file"
echo "" >> "$output_file"
echo '```' >> "$output_file"

# Start listing from the current directory with no initial indentation
list_structure "." "" "$output_file"

# Write the code block end
echo '```' >> "$output_file"

echo "Directory structure has been saved to $output_file"
