# Personal Information Clipboard Utility

## Overview

This Bash script provides a user-friendly interface for quickly copying various pieces of personal information to the clipboard. It uses a dropdown menu for selection and formats the output in an ASCII box for improved readability.

## Features

- Interactive dropdown menu for selecting information
- ASCII box formatting for copied text
- Supports multiple information types: Email, Phone Number, GitHub URL, LinkedIn URL, and a custom prompt script
- Clipboard integration for easy pasting
- Color-coded output for improved readability

## Requirements

- Bash shell
- `fzf` for creating the dropdown menu
- `pbcopy` for clipboard functionality (Mac OS X)

## Usage

Run the script in a Bash terminal:

```bash
./script_name.sh
```

Use the arrow keys to navigate the menu, press Enter to select an option, and Ctrl+C or select "Exit" to quit the script.

## Function Descriptions

### DROP_DOWN()

Creates an interactive dropdown menu using `fzf`.

Parameters:
- `$1`: Options to display in the menu
- `$2`: Prompt text for the menu

Returns: The selected option

### DRAW_BOX()

Draws an ASCII box around the given text, with proper word wrapping.

Parameters:
- `$*`: The text to be enclosed in the box

Returns: The formatted text in an ASCII box

### COPY_TO_CLIPBOARD()

Copies the given text to the clipboard and displays it in an ASCII box.

Parameters:
- `$1`: The text to be copied
- `$2`: A message to display above the ASCII box

### LINKEDIN()

Copies the LinkedIn URL to the clipboard.

### GITHUB()

Copies the GitHub URL to the clipboard.

### PHONE()

Copies the phone number to the clipboard.

### EMAIL()

Copies multiple email addresses to the clipboard.

### PROMPT_SCRIPT()

Copies a predefined prompt script to the clipboard.

### main()

The main function that runs the script. It creates the menu, handles user selection, and calls the appropriate functions based on the selection.

## Customization

To add or remove options from the menu, modify the `st` array in the `main()` function. Ensure that you also add corresponding case statements and functions for any new options.

## Notes

- This script is designed for personal use and should be modified if intended for distribution or use by others.
- The script currently uses `pbcopy` for clipboard functionality, which is specific to Mac OS X. For use on other operating systems, replace `pbcopy` with the appropriate clipboard command.
- The color codes used in the script (`\033[31m` for red and `\033[34m` for blue) may not work in all terminal emulators. Test and adjust as necessary.

## Security Considerations

- This script handles personal information. Ensure that it's run in a secure environment and that the clipboard is cleared after use if necessary.
- Avoid storing sensitive information like passwords directly in the script.

## Future Improvements

- Add support for other operating systems' clipboard commands
- Implement a configuration file for easy customization of personal information
- Add error handling for missing dependencies (e.g., `fzf`)
- Implement a feature to securely store and retrieve sensitive information
