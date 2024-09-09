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

NAME() {
    local options=(
        "Full Name"
        "First Name"
        "Last Name"
        "xX"
    )
    local selected=$(DROP_DOWN "$(printf "%s\n" "${options[@]}")" "Select name option: ")
    case "$selected" in
        "Full Name")
            COPY_TO_CLIPBOARD "Arfaz Hossain" "Full name copied to clipboard"
            ;;
        "First Name")
            COPY_TO_CLIPBOARD "Arfaz" "First name copied to clipboard"
            ;;
        "Last Name")
            COPY_TO_CLIPBOARD "Hossain" "Last name copied to clipboard"
            ;;
        "xX")
            return
            ;;
        "")
            return
            ;;
    esac
}

LINKEDIN () {
    COPY_TO_CLIPBOARD "https://linkedin.com/in/arfazhussain" "...where I need to pretend to be way more professional than I really am"
}

GITHUB () {
    COPY_TO_CLIPBOARD "https://github.com/arfazhxss" "...where all my code dreams live... and where my hopes of becoming a 10x developer went to die. Enjoy the repo rabbit hole!"
}

UNIVERSITY () {
    COPY_TO_CLIPBOARD "University of Victoria" "Don't know why they keep asking for the same thing, but I'm sure it's because I'm from Canada."
}

EMAIL() {
    local options=(
        "0/UVIC"
        "1/OUTLOOK"
        "2/GMAIL"
    )
    local selected=$(DROP_DOWN "$(printf "%s\n" "${options[@]}")" "Select email option: ")
    case "$selected" in
        "0/UVIC")
            COPY_TO_CLIPBOARD "arfazhussain@uvic.ca" "UVIC copied to clipboard"
            ;;
        "1/OUTCOME")
            COPY_TO_CLIPBOARD "arfazhussain@outlook.com" "OUTLOOK copied to clipboard"
            ;;
        "2/GMAIL")
            COPY_TO_CLIPBOARD "arfazhussain.zn@gmail.com" "GMAIL copied to clipboard"
            ;;
        "xX")
            return
            ;;
        "")
            return
            ;;
    esac
}

ADDRESS() {
    local options=(
        "Street [0]"
        "City [1]"
        "Province [2]"
        "Postal Code [3]"
        "Full Address [4]"
        "xX"
    )
    while true; do
        local selected=$(DROP_DOWN "$(printf "%s\n" "${options[@]}")" "Select address information: ")
        case "$selected" in
            "Street [0]")
                COPY_TO_CLIPBOARD "4257 Thornhill Crescent" "Street address copied to clipboard"
                ;;
            "City [1]")
                COPY_TO_CLIPBOARD "Victoria" "City copied to clipboard"
                ;;
            "Province [2]")
                COPY_TO_CLIPBOARD "British Columbia" "City copied to clipboard"
                ;;
            "Postal Code [3]")
                COPY_TO_CLIPBOARD "V8N 3G6" "Postal code copied to clipboard"
                ;;
            "Full Address [4]")
                local full_address=$(
                    printf "4257 Thornhill Crescent,\n"
                    printf "Victoria, British Columbia,\n"
                    printf "V8N 3G6\n"
                )
                COPY_TO_CLIPBOARD "$full_address" "Full address copied to clipboard"
                ;;
            "xX")
                return
                ;;
            "")
                return
                ;;
        esac
    done
}

PHONE () {
    local options=(
        "0/NON-FORMATTED"
        "1/FORMATTED"
    )
    local selected=$(DROP_DOWN "$(printf "%s\n" "${options[@]}")" "Select phone option: ")
    case "$selected" in
        "0/NON-FORMATTED")
            COPY_TO_CLIPBOARD "2508808402" "Phone number copied to clipboard"
            ;;
        "1/FORMATTED")
            COPY_TO_CLIPBOARD "+1 (250) 880-8402" "Not sure why I need this but most probably browser didn't catch that."
            ;;
        "xX")
            return
            ;;
        "")
            return
            ;;
    esac
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

COOP_PROGRAM_NAME() {
    local coop_program_description=$(
        printf "University of Victoria Engineering and Computer Science (UVic ECE) Cooperative Program\n"
        printf "Coop Coordinator Name: Imen Bourguiba\n"
        printf "Co-op: Software Engineering\n"
        printf "Email: engrcoop@uvic.ca\n"
    )
    COPY_TO_CLIPBOARD "$coop_program_description" "Not sure why I need this but most probably browser didn't catch that."
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

JOB_DETAILS() {
    local job="$1"
    local options=(
        "Title"
        "organization/company"
        "Location"
        "Duration"
        "Accomplishments"
        "All Details"
        "xX"
    )
    while true; do
        local selected=$(DROP_DOWN "$(printf "%s\n" "${options[@]}")" "Select detail for $job: ")
        case "$selected" in
            "Title")
                case "$job" in
                    "Software Team Lead")
                        COPY_TO_CLIPBOARD "Software Team Lead" "Job title copied to clipboard"
                        ;;
                    "Graphics Coordinator")
                        COPY_TO_CLIPBOARD "Graphics Coordinator" "Job title copied to clipboard"
                        ;;
                    "Various Positions at Save On Foods")
                        COPY_TO_CLIPBOARD "Various Positions: Grocery Clerk, Cashier, and Deli Clerk" "Job title copied to clipboard"
                        ;;
                    "Customer Service Representative")
                        COPY_TO_CLIPBOARD "Customer Service Representative, Cashier" "Job title copied to clipboard"
                        ;;
                    "Data Analyst Intern")
                        COPY_TO_CLIPBOARD "Data Analyst Intern" "Job title copied to clipboard"
                        ;;
                esac
                ;;
            "organization/company")
                case "$job" in
                    "Software Team Lead")
                        COPY_TO_CLIPBOARD "VikeLabs" "Organization copied to clipboard"
                        ;;
                    "Graphics Coordinator")
                        COPY_TO_CLIPBOARD "Engineering and Computer Science Students Society" "Organization copied to clipboard"
                        ;;
                    "Various Positions at Save On Foods")
                        COPY_TO_CLIPBOARD "Save On Foods" "Organization copied to clipboard"
                        ;;
                    "Customer Service Representative")
                        COPY_TO_CLIPBOARD "Tim Hortons" "Organization copied to clipboard"
                        ;;
                    "Data Analyst Intern")
                        COPY_TO_CLIPBOARD "Moment Touch Properties Ltd." "Organization copied to clipboard"
                        ;;
                esac
                ;;
            "Location")
                case "$job" in
                    "Data Analyst Intern")
                        COPY_TO_CLIPBOARD "Dhaka, Bangladesh" "Location copied to clipboard"
                        ;;
                    *)
                        COPY_TO_CLIPBOARD "Victoria, BC" "Location copied to clipboard"
                        ;;
                esac
                ;;
            "Duration")
                case "$job" in
                    "Software Team Lead")
                        COPY_TO_CLIPBOARD "Feb 2024 - Present" "Duration copied to clipboard"
                        ;;
                    "Graphics Coordinator")
                        COPY_TO_CLIPBOARD "Jan 2023 - Present" "Duration copied to clipboard"
                        ;;
                    "Various Positions at Save On Foods")
                        COPY_TO_CLIPBOARD "Apr 2022 - Sept 2022" "Duration copied to clipboard"
                        ;;
                    "Customer Service Representative")
                        COPY_TO_CLIPBOARD "Sept 2021 - May 2022" "Duration copied to clipboard"
                        ;;
                    "Data Analyst Intern")
                        COPY_TO_CLIPBOARD "Jan 2021 - Aug 2021" "Duration copied to clipboard"
                        ;;
                esac
                ;;
            "Accomplishments")
                case "$job" in
                    "Software Team Lead")
                        local accomplishments=$(cat << EOT
- Collaborated with 5+ team leads to organize workshops for 100+ CS and software engineering students.
- Collaborated with executives from 3+ student clubs to co-host tech events, boosting attendance by 25%.
- Fostering partnerships with other student organizations, expanding resource-sharing opportunities.
EOT
                        )
                        COPY_TO_CLIPBOARD "$accomplishments" "Accomplishments copied to clipboard"
                        ;;
                    "Graphics Coordinator")
                        local accomplishments=$(cat << EOT
- Created 40+ posters and social media campaigns for engineering events.
- Volunteered at 20+ events, enhancing student engagement and participation.
- Updated and maintained the ECSS website and exam bank accessed by 600+ engineering students.
EOT
                        )
                        COPY_TO_CLIPBOARD "$accomplishments" "Accomplishments copied to clipboard"
                        ;;
                    "Various Positions at Save On Foods")
                        local accomplishments=$(cat << EOT
- Oversaw store operations with a team of 10-12 employees, ensuring smooth daily workflow.
- Handled customer inquiries while collaborating with 3 departments through effective communication channels.
- Maintained inventory accuracy, reducing stock shortages by 7% through detailed record-keeping and rotation.
EOT
                        )
                        COPY_TO_CLIPBOARD "$accomplishments" "Accomplishments copied to clipboard"
                        ;;
                    "Customer Service Representative")
                        local accomplishments=$(cat << EOT
- Served 150+ customers daily, ensuring friendly and efficient service.
- Managed cash transactions with 100% accuracy while training new staff members.
- Prepared and served coffee and food to company standards, ensuring consistent quality.
EOT
                        )
                        COPY_TO_CLIPBOARD "$accomplishments" "Accomplishments copied to clipboard"
                        ;;
                    "Data Analyst Intern")
                        local accomplishments=$(cat << EOT
- Analyzed real estate market data using Excel, which improved the accuracy of property valuations by 7%.
- Developed Python scripts to automate data scraping and Bash scripts for cleaning and analysis.
- Compiled and presented data reports through automated Excel macros processes.
EOT
                        )
                        COPY_TO_CLIPBOARD "$accomplishments" "Accomplishments copied to clipboard"
                        ;;
                esac
                ;;
            "All Details")
                local all_details
                case "$job" in
                    "Software Team Lead")
                        all_details=$(cat << EOT
Title: Software Team Lead
Organization: VikeLabs
Location: Victoria, BC
Duration: Feb 2024 - Present
Accomplishments:
- Collaborated with 5+ team leads to organize workshops for 100+ CS and software engineering students.
- Collaborated with executives from 3+ student clubs to co-host tech events, boosting attendance by 25%.
- Fostering partnerships with other student organizations, expanding resource-sharing opportunities.
EOT
                        )
                        ;;
                    "Graphics Coordinator")
                        all_details=$(cat << EOT
Title: Graphics Coordinator
Organization: Engineering and Computer Science Students Society
Location: Victoria, BC
Duration: Jan 2023 - Present
Accomplishments:
- Created 40+ posters and social media campaigns for engineering events.
- Volunteered at 20+ events, enhancing student engagement and participation.
- Updated and maintained the ECSS website and exam bank accessed by 600+ engineering students.
EOT
                        )
                        ;;
                    "Various Positions at Save On Foods")
                        all_details=$(cat << EOT
Title: Various Positions: Grocery Clerk, Cashier, and Deli Clerk
Organization: Save On Foods
Location: Victoria, BC
Duration: Apr 2022 - Sept 2022
Accomplishments:
- Oversaw store operations with a team of 10-12 employees, ensuring smooth daily workflow.
- Handled customer inquiries while collaborating with 3 departments through effective communication channels.
- Maintained inventory accuracy, reducing stock shortages by 7% through detailed record-keeping and rotation.
EOT
                        )
                        ;;
                    "Customer Service Representative")
                        all_details=$(cat << EOT
Title: Customer Service Representative, Cashier
Organization: Tim Hortons
Location: Victoria, BC
Duration: Sept 2021 - May 2022
Accomplishments:
- Served 150+ customers daily, ensuring friendly and efficient service.
- Managed cash transactions with 100% accuracy while training new staff members.
- Prepared and served coffee and food to company standards, ensuring consistent quality.
EOT
                        )
                        ;;
                    "Data Analyst Intern")
                        all_details=$(cat << EOT
Title: Data Analyst Intern
Organization: Moment Touch Properties Ltd.
Location: Dhaka, Bangladesh
Duration: Jan 2021 - Aug 2021
Accomplishments:
- Analyzed real estate market data using Excel, which improved the accuracy of property valuations by 7%.
- Developed Python scripts to automate data scraping and Bash scripts for cleaning and analysis.
- Compiled and presented data reports through automated Excel macros processes.
EOT
                        )
                        ;;
                        esac
                        COPY_TO_CLIPBOARD "$all_details" "All job details copied to clipboard"
                        ;;
            "xX")
                return
                ;;
            "")
                return
                ;;
        esac
    done
}

JOBS() {
    local jobs=(
        "Software Team Lead"
        "Graphics Coordinator"
        "Various Positions at Save On Foods"
        "Customer Service Representative"
        "Data Analyst Intern"
        "xX"
    )
    while true; do
        local selected=$(DROP_DOWN "$(printf "%s\n" "${jobs[@]}")" "Select a job: ")
        if [ "$selected" = "xX" ]; then
            return
        else
            JOB_DETAILS "$selected"
        fi
    done
}

PROJECT_DETAILS() {
    local project="$1"
    local options=(
        "Title"
        "Technologies"
        "Duration"
        "Location"
        "GitHub"
        "Accomplishments"
        "All Details"
        "xX"
    )
    while true; do
        local selected=$(DROP_DOWN "$(printf "%s\n" "${options[@]}")" "Select detail for $project: ")
        case "$selected" in
            "Title")
                COPY_TO_CLIPBOARD "$project" "Project title copied to clipboard"
                ;;
            "Technologies")
                case "$project" in
                    "Course Planner")
                        COPY_TO_CLIPBOARD "Next.js, React, TypeScript, PostgreSQL, Tailwind" "Technologies copied to clipboard"
                        ;;
                    "Automated Application System")
                        COPY_TO_CLIPBOARD "Bash, Python, LaTeX" "Technologies copied to clipboard"
                        ;;
                    "Jabref - Open Source Contributions")
                        COPY_TO_CLIPBOARD "Java, JUnit" "Technologies copied to clipboard"
                        ;;
                    "Ground Support System")
                        COPY_TO_CLIPBOARD "React, TypeScript, MongoDB, Figma" "Technologies copied to clipboard"
                        ;;
                    "Rubik's Cube (3D Simulation)")
                        COPY_TO_CLIPBOARD "C++" "Technologies copied to clipboard"
                        ;;
                esac
                ;;
            "Duration")
                case "$project" in
                    "Course Planner")
                        COPY_TO_CLIPBOARD "Feb 2024 - Present" "Duration copied to clipboard"
                        ;;
                    "Automated Application System")
                        COPY_TO_CLIPBOARD "Dec 2023 - Present" "Duration copied to clipboard"
                        ;;
                    "Jabref - Open Source Contributions")
                        COPY_TO_CLIPBOARD "Dec 2023 - May 2024" "Duration copied to clipboard"
                        ;;
                    "Ground Support System")
                        COPY_TO_CLIPBOARD "Jul 2023 - Jan 2024" "Duration copied to clipboard"
                        ;;
                    "Rubik's Cube (3D Simulation)")
                        COPY_TO_CLIPBOARD "Feb 2023 - June 2023" "Duration copied to clipboard"
                        ;;
                esac
                ;;
            "Location")
                COPY_TO_CLIPBOARD "Victoria, BC" "Location copied to clipboard"
                ;;
            "GitHub")
                case "$project" in
                    "Course Planner")
                        COPY_TO_CLIPBOARD "www.github.com/arfazhxss/course-planner" "GitHub link copied to clipboard"
                        ;;
                    "Automated Application System")
                        COPY_TO_CLIPBOARD "www.github.com/arfazhxss/app-sys" "GitHub link copied to clipboard"
                        ;;
                    "Jabref - Open Source Contributions")
                        COPY_TO_CLIPBOARD "www.github.com/arfazhxss/jabref" "GitHub link copied to clipboard"
                        ;;
                    "Ground Support System")
                        COPY_TO_CLIPBOARD "www.github.com/UVicRocketry/Ground-Support" "GitHub link copied to clipboard"
                        ;;
                    "Rubik's Cube (3D Simulation)")
                        COPY_TO_CLIPBOARD "www.github.com/arfazhxss/rubiks-cube-cpp" "GitHub link copied to clipboard"
                        ;;
                esac
                ;;
            "Accomplishments")
                case "$project" in
                    "Course Planner")
                        local accomplishments=$(cat << EOT
- Developed a course planning tool using Next.js to help students plan courses and track degree progress.
- Integrated PostgreSQL for database management of course data and user information.
- Implemented drag-and-drop functionality in React with state functions to enhance user interactivity.
- Designed the User Experience using TailwindCSS to create a seamless and intuitive user experience.
EOT
                        )
                        COPY_TO_CLIPBOARD "$accomplishments" "Accomplishments copied to clipboard"
                        ;;
                    "Automated Application System")
                        local accomplishments=$(cat << EOT
- Automated and streamlined the entire job application process, optimizing workflow and data handling.
- Utilized multithreading for simultaneous data extraction and processing tasks, reducing runtime by 60%.
- Built command-line tools for data input and batch file processing, reducing manual efforts by 90%.
- Increased consistency by 70% by implementing proper data cleanup and extraction.
EOT
                        )
                        COPY_TO_CLIPBOARD "$accomplishments" "Accomplishments copied to clipboard"
                        ;;
                    "Jabref - Open Source Contributions")
                        local accomplishments=$(cat << EOT
- Developed 100+ unit tests to ensure end-to-end correctness of file lookup in JabRef's database.
- Implemented 20+ caching tests to optimize JabRef's performance and memory management.
- Implemented 30+ integration tests to verify correct interactions between multiple modules and classes.
- Engineered end-to-end functional tests validating bibliography management workflows.
EOT
                        )
                        COPY_TO_CLIPBOARD "$accomplishments" "Accomplishments copied to clipboard"
                        ;;
                    "Ground Support System")
                        local accomplishments=$(cat << EOT
- Collaborated with 13 developers to create portable telemetry software for rocket performance analysis.
- Developed front-end components using TypeScript and contributed to the final Figma designs.
- Integrated live telemetry data from the MongoDB database into MaterialUI tables for post-flight analysis.
- Implemented data visualizations with MaterialUI tables and charts for engineering students.
EOT
                        )
                        COPY_TO_CLIPBOARD "$accomplishments" "Accomplishments copied to clipboard"
                        ;;
                    "Rubik's Cube (3D Simulation)")
                        local accomplishments=$(cat << EOT
- Developed a 3D simulation with OpenGL, integrating GLSL for visuals and math operations.
- Created intuitive keyboard controls for cube rotations using keys like L, J, I, K.
- Enhanced user interaction with dynamic zoom via keyboard shortcuts.
EOT
                        )
                        COPY_TO_CLIPBOARD "$accomplishments" "Accomplishments copied to clipboard"
                        ;;
                esac
                ;;
            "All Details")
                local all_details
                case "$project" in
                    "Course Planner")
                        all_details=$(cat << EOT
Title: Course Planner
Technologies: Next.js, React, TypeScript, PostgreSQL, Tailwind
Duration: Feb 2024 - Present
Location: Victoria, BC
GitHub: www.github.com/arfazhxss/course-planner
Accomplishments:
- Developed a course planning tool using Next.js to help students plan courses and track degree progress.
- Integrated PostgreSQL for database management of course data and user information.
- Implemented drag-and-drop functionality in React with state functions to enhance user interactivity.
- Designed the User Experience using TailwindCSS to create a seamless and intuitive user experience.
EOT
                )
                ;;
            "Automated Application System")
                all_details=$(cat << EOT
Title: Automated Application System
Technologies: Bash, Python, LaTeX
Duration: Dec 2023 - Present
Location: Victoria, BC
GitHub: www.github.com/arfazhxss/app-sys
Accomplishments:
- Automated and streamlined the entire job application process, optimizing workflow and data handling.
- Utilized multithreading for simultaneous data extraction and processing tasks, reducing runtime by 60%.
- Built command-line tools for data input and batch file processing, reducing manual efforts by 90%.
- Increased consistency by 70% by implementing proper data cleanup and extraction.
EOT
                )
                ;;
            "Jabref - Open Source Contributions")
                all_details=$(cat << EOT
Title: Jabref - Open Source Contributions
Technologies: Java, JUnit
Duration: Dec 2023 - May 2024
Location: Victoria, BC
GitHub: www.github.com/arfazhxss/jabref
Accomplishments:
- Developed 100+ unit tests to ensure end-to-end correctness of file lookup in JabRef's database.
- Implemented 20+ caching tests to optimize JabRef's performance and memory management.
- Implemented 30+ integration tests to verify correct interactions between multiple modules and classes.
- Engineered end-to-end functional tests validating bibliography management workflows.
EOT
                )
                ;;
            "Ground Support System")
                all_details=$(cat << EOT
Title: Ground Support System
Technologies: React, TypeScript, MongoDB, Figma
Duration: Jul 2023 - Jan 2024
Location: Victoria, BC
GitHub: www.github.com/UVicRocketry/Ground-Support
Accomplishments:
- Collaborated with 13 developers to create portable telemetry software for rocket performance analysis.
- Developed front-end components using TypeScript and contributed to the final Figma designs.
- Integrated live telemetry data from the MongoDB database into MaterialUI tables for post-flight analysis.
- Implemented data visualizations with MaterialUI tables and charts for engineering students.
EOT
                )
                ;;
            "Rubik's Cube (3D Simulation)")
                all_details=$(cat << EOT
Title: Rubiks Cube (3D Simulation)
Technologies: C++
Duration: Feb 2023 - June 2023
Location: Victoria, BC
GitHub: www.github.com/arfazhxss/rubiks-cube-cpp
Accomplishments:
- Developed a 3D simulation with OpenGL, integrating GLSL for visuals and math operations.
- Created intuitive keyboard controls for cube rotations using keys like L, J, I, K.
- Enhanced user interaction with dynamic zoom via keyboard shortcuts.
EOT
                )
                ;;
                esac
                COPY_TO_CLIPBOARD "$all_details" "All project details copied to clipboard"
                ;;
            "xX")
                return
                ;;
        esac
    done
}

PROJECTS() {
    local projects=(
        "Course Planner"
        "Automated Application System"
        "Jabref - Open Source Contributions"
        "Ground Support System"
        "Rubik's Cube (3D Simulation)"
        "xX"
    )
    while true; do
        local selected=$(DROP_DOWN "$(printf "%s\n" "${projects[@]}")" "Select a project: ")
        if [ "$selected" = "xX" ]; then
            return
        else
            PROJECT_DETAILS "$selected"
        fi
    done
}

# Main function
main () {
    # Define options
    local st=(
        "xX"
        "Name"
        "Email"
        "GitHub"
        "LinkedIn"
        "Jobs [2]"
        "Phone Number"
        "Current Year"
        "Projects [1]"
        "Hard Problems"
        "University Name"
        "Graduation Date"
        "Coop Start Date"
        "Prompt Script [0]"
        "Address/Location"
        "Coop Work Permit"
        "Credits Completed"
        "Coop Program Name"
        "Coop Coordinator Name"
    )
    while true; do
        local options=$(printf "%s\n" "${st[@]}")

        # Create dropdown menu
        local selected=$(DROP_DOWN "$options" "Select information to copy: ")
        
        if [[ -z "$selected" ]]; then
            printf "\033[31mExiting the script. Goodbye!\033[0m\n"
            exit 1
        fi

        # Handle selected option
        case "$selected" in
            "xX")
                printf "\033[31mExiting the script. Goodbye!\033[0m\n"
                exit 0
                ;;
            "Name")
                NAME
                ;;
            "Email")
                EMAIL
                ;;
            "GitHub")
                GITHUB
                ;;
            "Jobs [2]")
                JOBS
                ;;
            "LinkedIn")
                LINKEDIN
                ;;
            "Projects [1]")
                PROJECTS
                ;;
            "Current Year")
                ACADEMIC_YEAR
                ;;
            "Phone Number")
                PHONE
                ;;
            "Hard Problems")
                HARD_PROBLEMS
                ;;
            "Prompt Script [0]")
                PROMPT_SCRIPT
                ;;
            "Graduation Date")
                GRAD_DATE
                ;;
            "Coop Start Date")
                COOP_START_DATE
                ;;
            "University Name")
                UNIVERSITY
                ;;
            "Address/Location")
                ADDRESS
                ;;
            "Coop Work Permit")
                TYPE_OF_CANADIAN
                ;;
            "Credits Completed")
                CREDITS
                ;;
            "Coop Coordinator Name")
                COOP_COORDINATOR_NAME
                ;;
            "Coop Program Name")
                COOP_PROGRAM_NAME
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