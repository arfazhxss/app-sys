#!/bin/bash

# Function to create a dropdown menu
DROP_DOWN () {
    local options="$1"
    local query="$2"
    local selected=$(echo -e "$options" | fzf --height 10% --border --prompt "$query ")
    [[ -z "$selected" || "$selected" == "exit" ]] && exit
    echo "$selected"
}

# Function to draw an ASCII box around text with proper word wrapping
DRAW_BOX () {
    local input="$*"
    local termWidth=$(tput cols 2>/dev/null || echo 80)
    local maxWidth=$((termWidth - 4))  # Subtract 4 to account for the box borders

    # Ensure maxWidth is at least 20 characters
    maxWidth=$((maxWidth < 20 ? 20 : maxWidth))

    # Wrap text to the maxWidth
    local wrapped_text=$(echo "$input" | fold -s -w $maxWidth)

    # Calculate the width of the longest line
    local width=$(echo "$wrapped_text" | awk '{print length}' | sort -nr | head -n1)
    local lineBeg="| "
    local lineEnd=" |"

    # Create the top and bottom borders
    local dashes=$(printf '%*s' $((width + ${#lineBeg} + ${#lineEnd})) "")
    dashes=${dashes// /-}

    # Print the box with wrapped text
    echo "$dashes"
    while IFS= read -r line; do
        printf "%s%-*s%s\n" "$lineBeg" "$width" "$line" "$lineEnd"
    done <<< "$wrapped_text"
    echo "$dashes"
}

# Function to copy text to clipboard
COPY_TO_CLIPBOARD () {
    local boxed_text=$(DRAW_BOX "$1")
    echo -n "$1" | pbcopy
    printf "\033[31m%s\033[0m\n" "$2"  # Blue color
    printf "\033[34m%s\033[0m\n" "$boxed_text"  # Red color
}

LINKEDIN () {
    COPY_TO_CLIPBOARD "https://linkedin.com/in/arfazhussain" "LinkedIn URL"
}

GITHUB () {
    COPY_TO_CLIPBOARD "https://github.com/arfazhxss" "GitHub URL"
}

PHONE () {
    COPY_TO_CLIPBOARD "+1 (250) 880-8402" "Not sure why I need this but most probably browser didn't catch that."
}

EMAIL () {
    local email=$(
        printf "arfazhussain.zn@gmail.com;\n"
        printf "arfazhussain@outlook.com;\n"
        printf "arfazhussain@uvic.ca\n"
    )
    COPY_TO_CLIPBOARD "$email" "Note: I've given 3 emails, there's one more but I doubt we need that."
}

# Function to copy the prompt script
PROMPT_SCRIPT() {
    local prompt_script=$(
        printf "______________________________________________________________________________________________________\n"
        printf "Find me the following information:\n"
        printf "Name of the job:\n"
        printf "Name of the Company:\n"
        printf "If the Company has a \"Ltd.\" \"Inc.\" or something like that at the end, like \"wanna work with <company_name>\" not <company_name> corporation, put that:\n"
        printf "Division/Team that job posting is for:\n"
        printf "Province that the job is for:\n"
        printf "City the job is for:\n"
        printf "Number of terms the job is for:\n"
        printf "\n(mention where in the file you found it)\n"
        printf "Term Data:\n"
        printf "a 12-month\n"
        printf "a 12-month or a 16-month\n"
        printf "a 16-month\n"
        printf "a 4, 8 or a 12-month\n"
        printf "a 4, 8, 12 or 16-month\n"
        printf "a 4-month\n"
        printf "a 4-month or an 8-month\n"
        printf "an 8, 12 or a 16-month\n"
        printf "an 8-month\n"
        printf "an 8-month or a 12-month\n"
        printf "\nExpress it like this (taken from a python3 snippet of many variables): ./atm.sh \"{job_title}\" \"{organization_name}\" \"{company_suffix}\" \"{division_name}\" \"{job_location}\" \"{region}\" \"{work_term_duration}\"\n"
    )
    COPY_TO_CLIPBOARD "$prompt_script" "$1"
}

# Main function
main () {
    # Define options
    local st=(
        "Email"
        "Phone Number"
        # "Address"
        # "Website"
        "GitHub"
        "LinkedIn"
        "Prompt Script"
        "Exit"
    )
    while true; do
        local options=$(printf "%s\n" "${st[@]}")

        # Create dropdown menu
        local selected=$(DROP_DOWN "$options" "Select information to copy: ")

        # Handle selected option
        case "$selected" in
            "Exit")
                echo "Exiting the script. Goodbye!"
                exit 0
                ;;
            "Email")
                EMAIL
                ;;
            "Phone Number")
                PHONE
                ;;
            "Address")
                COPY_TO_CLIPBOARD "123 Main St, City, State, ZIP" "Address"
                ;;
            "GitHub")
                GITHUB
                ;;
            "LinkedIn")
                LINKEDIN
                ;;
            "Prompt Script")
                PROMPT_SCRIPT
                ;;
            *)
                echo "Invalid option selected"
                exit 1
                ;;
        esac
        # echo "Press Enter to continue..."
        # read -r
    done
}

# Run the main function
main