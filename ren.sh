#!/bin/bash
#!/bin/sh

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                          REFORMAT, ENHANCE AND NAVIGATE                           ┃
# ┃===================================================================================┃
# ┃ Script Name: ren.sh                                                               ┃
# ┃ Author: Arfaz Hossain                                                             ┃
# ┃ Created Date: Thursday, August 29, 2024 at 4:08 PM                                ┃
# ┃===================================================================================┃
# ┃ Description:                                                                      ┃
# ┃===================================================================================┃
# ┃ This script is designed to rename and process files within a specified directory. ┃
# ┃ It includes functions to check directory validity, print file details, process    ┃
# ┃ files based on specific patterns, and handle file renaming and post-processing    ┃
# ┃ tasks. The script uses ExifTool to extract file creation dates and Ghostscript    ┃
# ┃ for PDF merging.                                                                  ┃
# ┃===================================================================================┃
# ┃ Usage                                                                             ┃
# ┃===================================================================================┃
# ┃ Run the script with the directory path as an argument. The script will process    ┃
# ┃ all files matching the specified patterns within the directory.                   ┃
# ┃===================================================================================┃
# ┃ License                                                                           ┃
# ┃===================================================================================┃
# ┃ This script is provided "as is", without warranty of any kind, express or         ┃
# ┃ implied, including but not limited to the warranties of merchantability,          ┃
# ┃ fitness for a particular purpose, and noninfringement. In no event shall the      ┃
# ┃ author be liable for any claim, damages, or other liability, whether in an        ┃
# ┃ action of contract, tort, or otherwise, arising from, out of, or in connection    ┃
# ┃ with the script or the use or other dealings in the script.                       ┃
# ┃                                                                                   ┃
# ┃ Use at your own risk.                                                             ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


symbol000="_"
symbol333="$"
symbol555="#"

fall="a37d7o"
spring="a94d6u"
summer="t50e9u"

# Function to check if a directory exists and is valid
check_directory() {
    if [ -z "$1" ]; then
        echo "Error: Directory parameter is missing."
        exit 1
    fi

    if [ -d "$1" ]; then
        directory="$1"
    else
        echo "Error: The specified directory '$1' does not exist or is not a valid directory."
        exit 1
    fi
}

print_file() {
    local file="$1"
    local id="$2"
    local date="$3"
    local MinSec="$4"
    local max="$5"
    local catch="$6"
    printf "[%s/%s] " "$id" "$total"
    # printf "{\e[31m$directory\e[0m\e[32m$file\e[0m}"
    printf "{\e[31m${directory%/}/\e[0m\e[32m$file\e[0m}"
    printf "\n\n\e[1;34m${catch}\e[0m"
    printf "\nDate: \t\t%s\n" "$date"
    printf "MinSec: \t%s\n" "$MinSec"
    printf "Max: \t\t%s\n\n" "$max"
}

DROP_DOWN () {
    local options="$1"
    local query="$2"
    local selected=$(echo -e "$options" | fzf --height 10% --border --prompt "$query ")
    [[ -z "$selected" || "$selected" == "exit" ]] && exit
    echo "$selected"
}

TranscriptAndOrReferences () {
    local transcript_response
    local references_response

    while true; do
        # Ask for academic transcript
        transcript_response=$(DROP_DOWN "yes\nno" "ACADEMIC TRANSCRIPT? ")

        if [[ "$transcript_response" == "xX" ]]; then
            return  # Exit if the user explicitly chooses "xX" for the first question
        elif [[ "$transcript_response" == "yes" ]]; then
            # If yes for academic transcript, ask for references
            references_response=$(DROP_DOWN "yes\nno\nxX" "REFERENCES? ")

            if [[ "$references_response" == "xX" ]]; then
                continue  # Go back to the academic transcript question
            elif [[ "$references_response" == "yes" ]]; then
                echo 12  # Both academic transcript and references
                break
            else
                echo 1  # Only academic transcript
                break
            fi
        else
            # If no for academic transcript, ask for references
            references_response=$(DROP_DOWN "yes\nno\nxX" "REFERENCES? ")

            if [[ "$references_response" == "xX" ]]; then
                continue  # Go back to the academic transcript question
            elif [[ "$references_response" == "yes" ]]; then
                echo 2  # Only references
                break
            else
                echo 0  # Neither academic transcript nor references
                break
            fi
        fi
    done
}

# Function to generate the LaTeX header
generate_overview_header() {
    cat <<EOF
\documentclass[12pt]{article}
\usepackage{geometry}
\usepackage{fancyhdr}
\usepackage{parskip}
\usepackage{enumitem}
\usepackage{setspace}
\usepackage{lipsum} % For placeholder text

% Page geometry
\geometry{a4paper, margin=1.5in}

% Title formatting to eliminate horizontal misalignment
\makeatletter
\renewcommand{\maketitle}{
  \begin{center}
    {\Huge \@title \par}
    \vskip 0.01em
    {\large \@author \par}
    \vskip -1em 
    {\large \@date \par}
    \noindent\hrulefill 
  \end{center}
}
\makeatother

% Title setup
\title{Application Overview}
\author{Arfaz Hossain} 
\date{\today}

% Spacing
\setstretch{1.3}
\pagestyle{fancy}
\fancyhf{} 
\fancyfoot[C]{0}

\begin{document}
\maketitle

\vskip 2em
This document contains the following attachments, structured as follows:\\\\

\begin{itemize}[leftmargin=*,labelsep=1em]
    \item \textbf{Page 1: Cover Letter}\\\\
    This section contains a formal cover letter addressed to the hiring manager. It highlights my relevant skills, experience, and motivation for applying for the position.
    
    \item \textbf{Pages 2-3: Resume}\\\\
    My resume provides a detailed overview of my education, technical skills, projects, work experiences, and volunteering activities.
EOF
}

# Function to generate the Transcript section
generate_overview_transcript() {
    cat <<EOF
    \item \textbf{Pages 4-6: University of Victoria Unofficial Transcript}\\\\
    The transcript reflects my academic record at the University of Victoria, where I am pursuing a Bachelor of Engineering in Software Engineering.
EOF
}

# Function to generate the Reference section
generate_overview_reference() {
    local current_page=$1
    cat <<EOF
    \item \textbf{Page ${current_page}: Reference}\\\\
    This section contains references or any additional information that supports my application.
EOF
}

# Function to generate the LaTeX footer
generate_overview_footer() {
    cat <<EOF
\end{itemize}

\vspace{2em}

Please feel free to reach out if you require any additional information or have any questions.

\vfill\noindent\hrulefill

\end{document}
EOF
}

generate_overview_tex() {
    local include_sections=$1
    local current_page=1
    local preprocess_directory="$(dirname "$directory")/9.2 PreProcessed"
    
    local tex_file="$(dirname "$directory")/9.2 PreProcessed/overview.tex"

    generate_overview_header > "$tex_file"
    if [[ "$include_sections" == *"1"* ]]; then
        current_page=$((current_page + 3))
        generate_overview_transcript >> "$tex_file"
    fi

    if [[ "$include_sections" == *"2"* ]]; then
        current_page=$((current_page + 3))
        generate_overview_reference "$current_page" >> "$tex_file"
    fi

    generate_overview_footer >> "$tex_file"

    # Compile the LaTeX document
    pdflatex -output-directory="$preprocess_directory" "$tex_file" > /dev/null 2>&1
    rm "$preprocess_directory"/overview.{aux,log}
}

process_files() {
    local file="$1"
    local id="$2"
    local date="$3"
    local MinSec="$4"
    local max="$5"
    local CString1="$6"
    local nxss="$7"
    local directory="$8"
    local CString2="$9"
    local testC1="${10}"
    local move="${11}"
    local testC2="${12}"
    local newFile="$directory/$nxss"
    local oldFile="$directory/$file"

    if [ "$testC1" ] && [ "$testC1" -eq 1 ]; then
        print_file "$file" "$id" "$date" "$MinSec" "$max" "$CString1"
    fi

    if [ "$move" ] && [ "$move" -eq 1 ]; then
        mv "$oldFile" "$newFile"
        printf "[ \e[1;31mmoved!\e[0m ]"
    fi

    if [ "$postprocess" ] && [ "$postprocess" -eq 1 ]; then
        [ ! -d "$(dirname "$directory")/9.3 CurrProcessed" ] && mkdir -p "$(dirname "$directory")/9.3 CurrProcessed" 2>/dev/null
        cp -n "$newFile" "$(dirname "$directory")/9.3 CurrProcessed" 2>/dev/null
    fi

    if [ "$merge" ] && [ "$merge" -eq 1 ]; then
        [ ! -d "$(dirname "$directory")/9.2 PreProcessed" ] && mkdir -p "$(dirname "$directory")/9.2 PreProcessed" 2>/dev/null
        local count=$(find "$(dirname "$directory")/9.2 PreProcessed" -maxdepth 1 -type f -name "*.pdf" | wc -l)
        [ "$count" -ge 1 ] || { echo "Error: Directory does not contain at least one PDF file"; exit 1; }

        if [ -f "$newFile" ]; then
            # Check the result of TranscriptAndOrReferences function
            case "$(TranscriptAndOrReferences)" in
                0)
                    generate_overview_tex "0"
                    # if result is 0, do not include transcript.pdf in the merged output
                    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
                        -sOutputFile="$directory/merged.pdf" \
                        "$(dirname "$directory")/9.2 PreProcessed/overview.pdf" \
                        "$newFile" \
                        "$(dirname "$directory")/9.2 PreProcessed/resume.pdf"
                    echo "Error: function failed"
                    ;;
                1)
                    generate_overview_tex "1"
                    # If result is 1, include transcript.pdf in the merged output
                    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
                        -sOutputFile="$directory/merged.pdf" \
                        "$(dirname "$directory")/9.2 PreProcessed/overview.pdf" \
                        "$newFile" \
                        "$(dirname "$directory")/9.2 PreProcessed/resume.pdf" \
                        "$(dirname "$directory")/9.2 PreProcessed/transcript.pdf"
                    ;;
                *)
                    # If result is not 1, do not include transcript.pdf in the merged output
                    printf "\e[31mError: TranscriptAndOrReferences function failed\e[0m\n"
            esac
        fi

        [ -f "$newFile" ] && mv "$directory/merged.pdf" "$newFile"
    fi

    if [ "$testC2" ] && [ "$testC2" -eq 1 ]; then
        print_file "$nxss" "$id" "$date" "$MinSec" "$max" "$CString2"
    fi
}

renaming_files() {
    for file in "${files[@]}"; do
        ((id++))
        local date=$(exiftool -s -s -s -FileCreateDate "$directory/${file}" | awk -F':' '{print $3}' | awk '{print $1}')
        local MinSec=$(exiftool -s -s -s -FileCreateDate "$directory/$file" | sed -E 's/.* ([0-9]{2}):([0-9]{2}):([0-9]{2}).*/\1\2\3/')

        # Hussain, Arfaz - Placement Application #1 - Software Engineering - ** - **.pdf
        if [[ "$file" == *"Placement Application #"* ]]; then
            
            ((max++))
            local nxs=$(sed 's/Placement Application #[0-9]* - /Placement Application - /g' <<< "$file")
            local nxss="${nxs%% -*} - Placement Application ${symbol000}${spring}${month}${symbol333}${date}${MinSec}${symbol555}${max} ${nxs#*Application }"
            process_files "$file" "$id" "$date" "$MinSec" "$max" "SHOULD HAVE A # AND A NUMBER AFTER \`PLACEMENT APPLICATION\`" "$nxss" "$directory" "Placement Application #" "$testC1" "$move" "$testC2"
            continue

        # Hussain, Arfaz - Placement Application - Software Engineering - ** - **.pdf
        elif [[ "$file" == *"Placement Application -"* && ! "$file" == *"Placement Application #"* ]]; then

            ((max++))
            local nxss="${file%% -*} - Placement Application ${symbol000}${spring}${month}${symbol333}${date}${MinSec}${symbol555}${max} ${file#*Application }"
            process_files "$file" "$id" "$date" "$MinSec" "$max" "SHOULD HAVE A - AFTER \`PLACEMENT APPLICATION\`" "$nxss" "$directory" "Placement Application -" "$testC1" "$move" "$testC2"
            continue
        
        # Hussain, Arfaz - Placement Application 3 - Software Engineering - ** - **.pdf
        elif [[ "$file" == *"Placement Application "* && ! "$file" == *"Placement Application _"* ]]; then
            
            ((max++))
            local nxs=$(sed 's/Placement Application [0-9]* - /Placement Application - /g' <<< "$file")
            local nxss="${nxs%% -*} - Placement Application ${symbol000}${spring}${month}${symbol333}${date}${MinSec}${symbol555}${max} ${nxs#*Application }"
            process_files "$file" "$id" "$date" "$MinSec" "$max" "SHOULD ONLY HAVE A NUMBER AFTER \`PLACEMENT APPLICATION\`" "$nxss" "$directory" "Application +X" "$testC1" "$move" "$testC2"
            continue

        # Hussain, Arfaz - Placement Application _XXX - Software Engineering - ** - **.pdf
        elif [[ "$file" == *"_"* ]]; then 
            
            # TOGGLE THIS WHEN NEEDED
            move=0
            postprocess=0

            ((max++))
            local nxh=$(echo "$file" | sed 's/_[^[:space:]]*//g' | sed 's/  / /g')
            local nxss="${nxh%% -*} - Placement Application ${symbol000}${spring}${month}${symbol333}${date}${MinSec}${symbol555}${max} ${nxh#*Application }"
            process_files "$file" "$id" "$date" "$MinSec" "$max" "SHOULD HAVE A _ AFTER \`PLACEMENT APPLICATION\`" "$nxss" "$directory" "PLACEMENT APPLICATION _" "$testC1" "$move" "$testC2"
            continue;
        
        else
            printf "\n\e[1;31mUNCOUGHT\e[0m\n"
            break;
        fi
    done
}

predir_settings() {
    local baseDir=${directory##*/}
    local baseDir=${baseDir#*[!0-9]}
    month=$(month=$(echo "${baseDir:0:3}" | tr '[:upper:]' '[:lower:]'); echo ${month:0:1}${month: -1})

    files=()
    while IFS= read -r line; do files+=("$line");
    done < <(find "$directory" -type f -name "* - Placement Application*" | sed 's/.*\///; s/.*\([Hh]ussain.*\.pdf\)/\1/' | sort -t'$' -k1,1n)
    total=${#files[@]}

    printf "\nSYMBOLS: %s%s%s\n\n" "$symbol000" "$symbol333" "$symbol555"

    max=$((1 + RANDOM % 1000))
    move=1
    postprocess=1
    merge=1
    testC1=0
    testC2=1
}

execute() {

    # Usage of the function with the directory parameter
    check_directory "$1"

    # pre-execution settings 
    predir_settings

    # renaming files throughout the directory
    renaming_files
    
}

execute "$1"