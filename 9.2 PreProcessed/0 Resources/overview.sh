#!/bin/bash

# Function to display a dropdown menu using fzf
DROP_DOWN () {
    local options="$1"
    local query="$2"
    local selected=$(echo -e "$options" | fzf --height 10% --border --prompt "$query ")
    [[ -z "$selected" || "$selected" == "exit" ]] && exit
    echo "$selected"
}

# Function to get responses for Academic Transcript and References
GET_ACADEMIC_REFERENCES () {
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
generate_header() {
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
generate_transcript() {
    cat <<EOF
    \item \textbf{Pages 4-6: University of Victoria Unofficial Transcript}\\\\
    The transcript reflects my academic record at the University of Victoria, where I am pursuing a Bachelor of Engineering in Software Engineering.
EOF
}

# Function to generate the Reference section
generate_reference() {
    local current_page=$1
    cat <<EOF
    \item \textbf{Page ${current_page}: Reference}\\\\
    This section contains references or any additional information that supports my application.
EOF
}

# Function to generate the LaTeX footer
generate_footer() {
    cat <<EOF
\end{itemize}

\vspace{2em}

Please feel free to reach out if you require any additional information or have any questions.

\vfill\noindent\hrulefill

\end{document}
EOF
}

# Main function to generate the complete LaTeX document
generate_tex() {
    local include_sections=$1
    local current_page=1
    local preprocess_directory="$(dirname "$directory")/9.2 PreProcessed"
    
    local tex_file="$(dirname "$directory")/9.2 PreProcessed/overview.tex"

    generate_header > "$tex_file"
    if [[ "$include_sections" == *"1"* ]]; then
        current_page=$((current_page + 3))
        generate_transcript >> "$tex_file"
    fi

    if [[ "$include_sections" == *"2"* ]]; then
        current_page=$((current_page + 3))
        generate_reference "$current_page" >> "$tex_file"
    fi

    generate_footer >> "$tex_file"

    # Compile the LaTeX document
    pdflatex -output-directory="$preprocess_directory" "$tex_file"
    rm "$preprocess_directory"/overview.{aux,log}
}

# Example usage:
generate_tex $(GET_ACADEMIC_REFERENCES)

# Call the function
# GET_ACADEMIC_REFERENCES



