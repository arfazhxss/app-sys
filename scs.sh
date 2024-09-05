#!/bin/bash

# =============================================================================
# Script Name: Standard Clipboard Scripted System (SCSS/SCS)
# Author: Arfaz Hussain
# Created Date: Thursday, August 29, 2024 at 4:08 PM
# Description: 
# This script provides a set of utility functions to copy various types of 
# information (such as email, phone number, GitHub URL, LinkedIn URL, etc.) 
# to the clipboard. It includes functions to create dropdown menus, draw ASCII 
# boxes around text, and handle clipboard operations. The script uses `fzf` 
# for interactive selection and `pbcopy` for clipboard operations.
#
# Usage:
# Run the script and follow the prompts to select the information you want to 
# copy to the clipboard. The script will display the selected information in 
# an ASCII box and copy it to the clipboard.
#
# License:
# This script is provided "as is", without warranty of any kind, express or 
# implied, including but not limited to the warranties of merchantability, 
# fitness for a particular purpose, and noninfringement. In no event shall the 
# author be liable for any claim, damages, or other liability, whether in an 
# action of contract, tort, or otherwise, arising from, out of, or in connection 
# with the script or the use or other dealings in the script.
#
# Use at your own risk.
#
# Full Documentation:
# For more detailed information, please refer to the full documentation located 
# in the 9.7 DOCX/scs.md file.
# =============================================================================

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
    printf "\033[31m%s\033[0m\n" "$2"
    printf "\033[34m%s\033[0m\n" "$boxed_text"
}

LINKEDIN () {
    COPY_TO_CLIPBOARD "https://linkedin.com/in/arfazhussain" "...where I need to pretend to be way more professional than I really am"
}

GITHUB () {
    COPY_TO_CLIPBOARD "https://github.com/arfazhxss" "...where all my code dreams live... and where my hopes of becoming a 10x developer went to die. Enjoy the repo rabbit hole!"
}

LOCATION() {
    local location_description=$(
        printf "4257 Thornhill Crescent,\n"
        printf "Victoria, British Columbia,\n"
        printf "V8N 3G6\n"
    )
    COPY_TO_CLIPBOARD "$location_description" "location_info"
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
    COPY_TO_CLIPBOARD "$prompt_script" "Here's the ultimate job-snooping toolkit. Just remember, you didn't get this from me. If anyone asks, I don't even know what JSON is."
}

ACADEMIC_YEAR() {
    local current_year_description=$(
        printf "Current Year: 3\n"
    )
    COPY_TO_CLIPBOARD "$current_year_description" "Year 3! That awkward stage where I'm not quite a noob, but not quite a Jedi yet. Yoda said 'Patience,' but he never took 8:30 am classes"
}

CREDITS() {
    local credits_completed_description=$(
        printf "Credits Completed: 41.5\n"
    )
    COPY_TO_CLIPBOARD "$credits_completed_description" "41.5 credits down... and who knows how many more to go. I stopped counting after they said 'required courses.'"
}

GRAD_DATE() {
    local graduation_date_description=$(
        printf "Graduation Date: April, 2026\n"
    )
    COPY_TO_CLIPBOARD "$graduation_date_description" "graduation_date_info"
}

COOP_START_DATE() {
    local coop_start_date_description=$(
        printf "Coop Start Date: September 2024\n"
    )
    COPY_TO_CLIPBOARD "$coop_start_date_description" "coop_start_date_info"
}

TYPE_OF_CANADIAN() {
    local type_of_canadian_description=$(
        printf "Student Permit and Coop Work Permit\n"
    )
    COPY_TO_CLIPBOARD "$type_of_canadian_description" "type_of_canadian_info"
}

COOP_COORDINATOR_NAME() {
    local coop_coordinator_description=$(
        printf "Coop Coordinator Name: Imen Bourguiba\n"
        printf "Email: imenbour@uvic.ca\n"
        printf "Alternate Email: engrcoop@uvic.ca\n"
    )
    COPY_TO_CLIPBOARD "$coop_coordinator_description" "Meet Imen Bourguiba, the person who knows if I'm slacking off. Pro tip: butter them up with coffee offers (it's a hypothesis, untested)."
}


HARD_PROBLEMS() {
    local question=$(
        printf "Please describe for us 2 of the hardest problems you have solved in\n"
        printf "your career or school work and exactly how you solved them?\n"
    )
    local problems_description=$(
        printf "Automating the Job Application Process\n\n"
        printf "One of the most challenging problems I tackled was automating the\n"
        printf "entire job application process to optimize workflow and data handling.\n"
        printf "I achieved this by developing a robust command-line tool that reduced\n"
        printf "manual input and batch-processed multiple files, cutting down manual\n"
        printf "effort by 90%%. To handle large datasets efficiently, I implemented\n"
        printf "multithreading for simultaneous data extraction and processing,\n"
        printf "reducing runtime by 60%%. I also designed a comprehensive data cleanup\n"
        printf "system to ensure consistency, boosting the accuracy and reliability of\n"
        printf "the processed data by 70%%.\n\n"
        
        printf "Building an Intuitive Course Planning Tool\n"
        printf "Another complex problem I solved was creating a user-friendly course\n"
        printf "planning tool that helps students track their degree progress. I\n"
        printf "developed this tool using Next.js and React, focusing on implementing\n"
        printf "drag-and-drop functionality with precise state management to ensure\n"
        printf "smooth interactions. I integrated PostgreSQL to manage complex course\n"
        printf "data relationships efficiently and used TailwindCSS to design a\n"
        printf "seamless user interface. This combination of backend efficiency and\n"
        printf "front-end interactivity resulted in an intuitive and highly functional\n"
        printf "tool that significantly enhanced the user experience for students.\n\n"
        
        printf "Developing 3D Simulation for Rubik's Cube\n"
        printf "Creating a 3D simulation for a Rubik's Cube using C++ and OpenGL\n"
        printf "presented a significant challenge, as it required both mathematical\n"
        printf "rigor and user-centric design. I tackled this by integrating GLSL\n"
        printf "shaders to handle complex visual and mathematical operations,\n"
        printf "ensuring the cube's rotations and transformations were both accurate\n"
        printf "and visually appealing. I also implemented intuitive keyboard controls\n"
        printf "for rotations and dynamic zoom functions, enhancing user interaction\n"
        printf "and making the simulation more engaging and accessible to users of\n"
        printf "all levels.\n"
    )
    COPY_TO_CLIPBOARD "$problems_description" "$question"
}



# Main function
main () {
    # Define options
    local st=(
        "Email"
        "Phone Number"
        "Address"
        "Location"
        # "Website"
        "Hard Problems"
        "GitHub"
        "LinkedIn"
        "Prompt Script"
        "Current Year"
        "Credits Completed"
        "Graduation Date"
        "Coop Start Date"
        "Coop Work Permit"
        "Coop Coordinator Name"
        "Exit"
    )
    while true; do
        local options=$(printf "%s\n" "${st[@]}")

        # Create dropdown menu
        local selected=$(DROP_DOWN "$options" "Select information to copy: ")

        # Handle selected option
        case "$selected" in
            "Exit")
                printf "\033[31mExiting the script. Goodbye!\033[0m\n"
                exit 0
                ;;
            "Email")
                EMAIL
                ;;
            "Phone Number")
                PHONE
                ;;
            "Address")
                LOCATION
                ;;
            "Location")
                LOCATION
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
            "Hard Problems")
                HARD_PROBLEMS
                ;;
            "Current Year")
                CURRENT_YEAR
                ;;
            "Credits Completed")
                CREDITS
                ;;
            "Graduation Date")
                GRAD_DATE
                ;;
            "Coop Start Date")
                COOP_START_DATE
                ;;
            "Coop Work Permit")
                TYPE_OF_CANADIAN
                ;;
            "Coop Coordinator Name")
                COOP_COORDINATOR_NAME
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