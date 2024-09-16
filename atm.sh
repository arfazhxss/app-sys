#!/bin/bash

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                      APPLICATION TEMPLATE MANAGEMENT SYSTEM                       ┃
# ┃ ==================================================================================┃
# ┃ Script Name: atm.sh                                                               ┃
# ┃ Author: Arfaz Hussain                                                             ┃
# ┃ Created Date: 2022-10-19                                                          ┃
# ┃ Description:                                                                      ┃
# ┃ This script is designed to automate the generation of LaTeX cover letters         ┃
# ┃ for job applications. It includes functions to gather user input through          ┃
# ┃ dropdown menus, escape LaTeX special characters, and generate a LaTeX file        ┃
# ┃ with the provided information. The script also compiles the LaTeX file into       ┃
# ┃ a PDF and organizes the output files.                                             ┃
# ┃                                                                                   ┃
# ┃ Usage:                                                                            ┃
# ┃ Run the script with or without arguments. If no arguments are provided, the       ┃
# ┃ script will prompt the user for input. If arguments are provided, they should     ┃
# ┃ be in the following order:                                                        ┃
# ┃   1. Position                                                                     ┃
# ┃   2. Company Name                                                                 ┃
# ┃   3. Company Suffix                                                               ┃
# ┃   4. Division                                                                     ┃
# ┃   5. City                                                                         ┃
# ┃   6. State                                                                        ┃
# ┃   7. Terms                                                                        ┃
# ┃                                                                                   ┃
# ┃ Example:                                                                          ┃
# ┃                                                                                   ┃
# ┃ ┌───────────────────────────────────────────────────────────────────────────────┐ ┃
# ┃ │ ./atm.sh "Software Engineer" "Tech Corp" "Inc." "Development" "San Francisco" │ ┃
# ┃ │ "California" "4-month"                                                        │ ┃
# ┃ └───────────────────────────────────────────────────────────────────────────────┘ ┃
# ┃                                                                                   ┃
# ┃ DISCLAIMER:                                                                       ┃
# ┃ This script is provided "as is", without warranty of any kind, express or         ┃
# ┃ implied, including but not limited to the warranties of merchantability,          ┃
# ┃ fitness for a particular purpose, and noninfringement. In no event shall the      ┃
# ┃ author be liable for any claim, damages, or other liability, whether in an        ┃
# ┃ action of contract, tort, or otherwise, arising from, out of, or in connection    ┃
# ┃ with the script or the use or other dealings in the script.                       ┃
# ┃                                                                                   ┃
# ┃ Use at your own risk.                                                             ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

shopt -s extglob

get_dir () {
    echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
}

random_two () {
    echo $(jot -r 2 0 9 | tr -d '\n')
}

# Function to escape LaTeX special characters
ESC_LATEX () {
    sed -e 's/[\\{}&$#_^~%]/\\&/g' <<< "$1"
}

# Function to create a dropdown menu
DROP_DOWN () {
    local origin="$1"
    local query="$2"
    local ADD="++++++"
    local TST="TEST"
    local options=$(cat "$origin" 2>/dev/null)
    local state=$(echo "$ADD\n$TST\n$options" | fzf --height 10% --border --prompt "$query ")
    [[ -z "$state" || "$state" == "exit" ]] && exit
    if [ "$state" = "$ADD" ]; then
        read -p $'\e[1;33mEnter State: \e[0m' new_state
        read -n 1 -r -s -p $'Press any key to continue...\n'
        echo "$new_state" >>"$origin"
        echo "$new_state"
    elif [ "$state" = "$TST" ]; then
        echo "TEST"
    else
        # echo "$state"
        echo "$state"
    fi
}

# Function to get the Position
get_title () {
    local DATA_DIR="$(get_dir)" 
    local title_origin="$DATA_DIR/9.4 PostProcessed/title_data.txt"
    local title_query="Enter Position:"
    echo "$(DROP_DOWN "$title_origin" "$title_query")"
}

# Function to get the Company Name
get_company_name () {
    local DATA_DIR="$(get_dir)" 
    local company_name_origin="$DATA_DIR/9.4 PostProcessed/company_data/company_name.txt"
    local company_name_query="Enter Company Name:"
    echo "$(DROP_DOWN "$company_name_origin" "$company_name_query")"
}

# Function to get the Company Suffix
get_company_suffix () {
    local DATA_DIR="$(get_dir)" 
    local company_suffix_origin="$DATA_DIR/9.4 PostProcessed/company_data/company_suffix.txt"
    local company_suffix_query="Enter Company Suffix:"
    echo "$(DROP_DOWN "$company_suffix_origin" "$company_suffix_query")"
}

get_state () {
    local DATA_DIR="$(get_dir)" 
    local province_origin="$DATA_DIR/9.4 PostProcessed/location_data/Provinces.txt"
    local province_query="Enter Province name:"
    echo "$(DROP_DOWN "$province_origin" "$province_query")"
}

get_city () {
    local locationState="$1"
    local DATA_DIR="$(get_dir)" 
    [ -z "$locationState" ] && { echo "$province_query No province selected."; exit 1; }
    local city_origin="$DATA_DIR/9.4 PostProcessed/location_data/${locationState// /_}.txt"
    local city_query="Enter City name:"
    local locationCity=$(DROP_DOWN "$city_origin" "$city_query")
    [ -z "$locationCity" ] && { echo "$city_query No city selected."; exit 1; } 
    echo "$locationCity"
}

# Function to get the Division
get_division () {
    local DATA_DIR="$(get_dir)" 
    local division_origin="$DATA_DIR/9.4 PostProcessed/company_data/company_division.txt"
    local division_query="Enter Division:"
    echo "$(DROP_DOWN "$division_origin" "$division_query")"
}

# Function to get the Terms
get_terms () {
    local DATA_DIR="$(get_dir)" 
    local terms_origin="$DATA_DIR/9.4 PostProcessed/term_data.txt"
    local terms_query="Enter Terms:"
    echo "$(DROP_DOWN "$terms_origin" "$terms_query")"
}

find_term () {
    local terms="$1"
    local term="two"

    # Determine the value of the term variable
    case "$terms" in
        *"4, 8, 12 or 16-month"*)
            local term="three"
            ;;
        *"8, 12 or a 16-month"*)
            local term="three"
            ;;
        *"12-month"*)
            local term="three"
            ;;
        *"16-month"*)
            local term="three"
            ;;
        *"8-month"*)
            local term="two"
            ;;
        *"4-month"*)
            local term="one"
            ;;
        *)
            echo "two"
            exit 1
            ;;
    esac
    echo "$term"
}

body_0 () {
    local body_0_0="I am writing to express my strong interest in the \\textit{\\Position} Co-op at \\CompanyName."
    local body_0_1="I am a software engineering student at the University of Victoria in British Columbia."
    local body_0_2="I am eager to learn and grow in the field of computer and software engineering,"
    local body_0_3="and I believe that this role will help me gain valuable work experience related to my interests"
    local body_0_4="and help me acquire a practical understanding in a real-world setting."
    printf "%s %s %s %s %s" "$body_0_0" "$body_0_1" "$body_0_2" "$body_0_3" "$body_0_4"
}

body_1 () {
    local concepts="object-oriented programming, software architecture design, agile methodologies and software testing"

    local body_1_0="Throughout my academic endeavours,"
    local body_1_1="I have had the chance to explore and learn about many important concepts in software engineering,"
    local body_1_2="such as $concepts."
    local body_1_3="My academic and project experiences align well with the requirements of this position:"
    printf "%s %s %s %s %s" "$body_1_0" "$body_1_1" "$body_1_2" "$body_1_3" "$body_1_4" 
}

b2_p1() {
    local item="\\item \\textbf{Full-Stack Development}: I've experience developing full-stack applications, working primarily with TypeScript, React and Python. During some projects, I had the chance to design the system, develop schemas for both relational and non-relational databases such as {PostgreSQL} and {MongoDB}."
    printf "\n\t%s\n" "$item"
}

b2_p2() {
    local item="\\item \\textbf{Diverse Project Portfolio}: I've completed over 13 software development projects, including an iOS weather application in Swift, a 3D Rubik's Cube simulation using C++, and several web applications using React, JavaScript, and TypeScript."
    printf "\n\t%s\n" "$item"
}

b2_p3() {
    local item="\\item \\textbf{Testing and Automation}: Throughout my projects, I have utilized build automation tools like Maven and Gradle, along with web automation tools such as Selenium, Puppeteer, and WebDriverIO. I have experience working with unit testing with frameworks such as JUnit, pytest, Mocha and have experience with API testing using Postman."
    printf "\n\t%s\n" "$item"
}

b2_p4() {
    local item="\\item \\textbf{Collaboration and Development}: I have been an active member of the Engineering Students Society and VikeLabs, where I've mentored and worked with fellow engineering students, participated in hackathons and coding workshops."
    printf "\n\t%s\n" "$item"
}

body_2() {
    printf "\\\\begin{itemize}"
    b2_p1
    b2_p2
    b2_p3
    b2_p4
    printf "\\\\end{itemize}"
}

body_3 () {
    local term="$(find_term "$1")"
    local body_3_0="I am currently available for \\textbf{\\Terms} work term and"
    local body_3_1="would be open to the possibility of participating in more than ${term} consecutive terms."
    local body_3_2="Thank you for considering my application."
    local body_3_3="I look forward to the possibility of speaking with you further about this role."
    printf "%s %s %s %s" "$body_3_0" "$body_3_1" "$body_3_2" "$body_3_3"
}

body_4 () {
    local a="\vspace{10pt}\text{Most Sincerely,}"
    local b="\vspace{-25pt}\begin{flushleft}"
    local c="\hspace*{-1cm}\includegraphics[width=10cm]{../../9.2 PreProcessed/0 Resources/signature.png}\vspace{-1cm}"
    local d="\end{flushleft}"
    local e="\vspace{-10pt}\ps{\textbf{Arfaz Hossain} (He/Him)\\\\"
    local f="Software Engineering Student,\\\\"
    local g="University of Victoria}"
    printf "%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s" "$a" "$b" "$c" "$d" "$e" "$f" "$g"
}

preamble () {
    # local a="\documentclass[a4paper, 12pt]{letter}"
    local a="\documentclass[a4paper, 12pt, oneside]{letter}"
    local b="\usepackage{graphicx}"
    local c="\usepackage{hyperref}"
    local d="\usepackage{amsmath}"
    local e="\usepackage{lmodern}"
    local f="\usepackage{xcolor}"
    local g="\usepackage{adjustbox}"
    local h="\usepackage{fancyhdr}"
    local i="\usepackage{etoolbox}"
    local j="\usepackage[left=0.75in, right=0.75in, top=0.2in, bottom=0.5in]{geometry}"
    local k="\setlength{\parindent}{0pt}"
    printf "%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s\n" "$a" "$b" "$c" "$d" "$e" "$f" "$g" "$h" "$i" "$j" "$k"
}

custom_ruler_setup () {    
    local a="\newcommand{\CustomRuler}{\vspace{0\baselineskip}\textcolor{black}{\rule{\linewidth}{0.5pt}}\vspace{-0.5\baselineskip}}"
    printf "%s\n" "$a"
}

link_color () {
    local a="\definecolor{linkblue}{HTML}{0000FF}"
    printf "%s\n" "$a"
}

hyper_setup () {
    local a="\hypersetup{"
    local b="colorlinks=true,"
    local_c="linkcolor=linkblue, % Color of internal links"
    local_d="urlcolor=linkblue, % Color of URLs"
    local_e="}"
    printf "%s\n\t\t\t%s\n\t\t\t%s\n\t\t\t%s\n\t\t%s\n" "$a" "$b" "$local_c" "$local_d" "$local_e"
}

footer_setup () {
    local a="\fancypagestyle{plain}{"
    local b="\fancyhf{} % Clear header and footer"
    local c="\renewcommand{\headrulewidth}{0pt}"
    local d="}"
    printf "%s\n\t\t\t%s\n\t\t\t%s\n\t\t%s\n" "$a" "$b" "$c" "$d"
}

var_define () {
    local a="\newcommand{\Position}{$position}"
    local b="\newcommand{\CompanyName}{$company_name}"
    local c="\newcommand{\CompanyNameSuffix}{$company_suffix}"
    local d="\newcommand{\Division}{$division}"
    local e="\newcommand{\LocationCity}{$locationCity}"
    local f="\newcommand{\LocationState}{$locationState}"
    local g="\newcommand{\Terms}{$terms}"
    printf "%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s\n" "$a" "$b" "$c" "$d" "$e" "$f" "$g"
}

line_break () {
    local a="\vspace{-7pt}\\\\\\\\"
    printf "%s" "$a"
}

header_settings () {
    local a="\noindent"
    local b="\begin{minipage}[t]{0.5\textwidth}"
    local c="\raggedright"
    local d="\vspace{3pt}"
    local e="{\fontsize{30}{34}\selectfont Arfaz Hossain} \\\\"
    local f="\vspace{2pt}"
    local g="{\fontsize{12}{14}\selectfont Victoria, British Columbia}"
    local h="\end{minipage}%"
    local i="\begin{minipage}[t]{0.5\textwidth}"
    local j="\raggedleft"
    local k="\vspace{1pt}"
    local l="\href{https://www.github.com/arfazhxss}{\fontsize{12}{14}\selectfont www.github.com/arfazhxss} \\\\"
    local m="\href{https://www.linkedin.com/in/arfazhussain}{\fontsize{12}{14}\selectfont www.linkedin.com/in/arfazhussain} \\\\"
    local n="\href{https://arfazhxss.ca/resume.pdf}{\fontsize{12}{14}\selectfont arfazhxss.ca/resume.pdf}"
    local o="\end{minipage}"
    printf "%s\n\t\t%s\n\t\t\t%s\n\t\t\t%s\n\t\t\t%s\n\t\t\t%s\n\t\t\t%s\n\t\t%s\n\t\t%s\n\t\t\t%s\n\t\t\t%s\n\t\t\t%s\n\t\t\t%s\n\t\t\t%s\n\t\t%s" "$a" "$b" "$c" "$d" "$e" "$f" "$g" "$h" "$i" "$j" "$k" "$l" "$m" "$n" "$o"
}

custom_ruler () {
    local a="\CustomRuler \vspace{20pt} \today \vspace{5pt}"
    printf "%s" "$a"
}

begin_document () {
    local a="\begin{document}"
    local b="\pagestyle{empty}"
    printf "%s\n\t\t%s" "$a" "$b"
}

letter_details () {
    local cname="$1"
    local csuf="$2"
    local cdiv="$3"

    # if [ $((${#cname} + ${#csuf} + ${#cdiv})) -gt 45 ]; then
    #     local a="\textbf{\CompanyName}\textbf{ \CompanyNameSuffix}\\\\"
    #     local b="\text{\Division}\\\\"
    #     local c="\vspace{20pt}\text{\LocationCity}, \text{\LocationState} \\\\"
    #     local d="\vspace{10pt}\text{Dear Hiring Manager:} \\\\"
    #     printf "%s\n\t%s\n\t\t%s\n\t\t%s\n\t\t%s" "$a" "$b" "$c" "$d"
    # else
    #     local a="\vspace{1em}"
    #     local b="\textbf{\CompanyName}\textbf{ \CompanyNameSuffix},"
    #     local c="\text{\Division}\\\\"
    #     local d="\vspace{20pt}\text{\LocationCity}, \text{\LocationState} \\\\"
    #     local e="\vspace{10pt}\text{Dear Hiring Manager:} \\\\"
    #     printf "%s\n%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s" "$a" "$b" "$c" "$d" "$e"
    # fi
    
    local size1=$((${#cname}))
    local size2=$((${#csuf}))
    local size3=$((${#cdiv}))
    local a="\textbf{Ashlin Richardson}\\\\"
    local b="\textit {Band 3 Senior Data Scientist and Manager of Business Intelligence}\\\\"
    local c="\text{\CompanyName}\text{, \Division} \\\\"
    local d="\vspace{20pt}\text{\LocationCity}, \text{\LocationState} \\\\"
    local e="\vspace{10pt}\text{Dear Mr. Richardson:} \\\\"
    printf "%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s\n\t\t%s" "$a" "$b" "$c" "$d" "$e"
}

# Function to generate LaTeX file
LaTeX () {
    local position="$1"
    local company_name="$2"
    local company_suffix="$3"
    local division="$4"
    local locationCity="$5"
    local locationState="$6"
    local terms="$7"
    
    local preamble="$(preamble)"
    local custom_ruler_setup="$(custom_ruler_setup)"
    local link_color="$(link_color)"
    local hyper_setup="$(hyper_setup)"
    local var_define="$(var_define)"
    local footer_setup="$(footer_setup)"
    local line_break="$(line_break)"
    local header_settings="$(header_settings)"
    local begin_document="$(begin_document)"
    local custom_ruler="$(custom_ruler)"
    # local letter_details="$(letter_details)"
    local letter_details="$(letter_details "$company_name" "$company_suffix" "$division")"

    local body_0="$(body_0)"
    local body_1="$(body_1)"
    local body_2="$(body_2)"
    local body_3="$(body_3 "$7")"
    local body_4="$(body_4)"

    # Generate LaTeX file content
    cat <<-EOF > tntx.tex
        % Define the preamble
        $preamble

        % Define the new ruler command
        $custom_ruler_setup

        % Define color for hyperlinks
        $link_color % Blue color

        % Set up hyperref package
        $hyper_setup

        % Redefine footer style to remove page number
        $footer_setup

        % Define variables
        $var_define

        % Begin document
        $begin_document

        % Header with name and links
        $header_settings

        % Custom ruler (or a line ------)
        $custom_ruler

        % Letter details
        $letter_details $body_0 $line_break
        $body_1
        $body_2
        $body_3 \\\\\\\\\\\\
        $body_4 
        \end{document}
EOF
}

generator () {
if [ "$#" -eq 7 ]; then
        # Use the provided parameters
        local position="$1"
        local company_name="$2"
        local company_suffix="$3"
        local division="$4"
        local locationCity="$5"
        local locationState="$6"
        local terms="$7"
    else
        # Escape LaTeX special characters in variables
        local position=$(ESC_LATEX "$(get_title)")
        local company_name=$( [ "$position" == "TEST" ] && echo "TEST" || ESC_LATEX "$(get_company_name)" )
        local company_suffix=$( [ "$company_name" == "TEST" ] && echo "TEST" || ESC_LATEX "$(get_company_suffix)" )
        local division=$( [ "$company_suffix" == "TEST" ] && echo "TEST" || ESC_LATEX "$(get_division)" )
        local locationState=$( [ "$division" == "TEST" ] && echo "TEST" || ESC_LATEX "$(get_state)" )
        local locationCity=$( [ "$locationState" == "TEST" ] && echo "TEST" || ESC_LATEX "$(get_city "$locationState")" )
        local terms=$( [ "$locationCity" == "TEST" ] && echo "TEST" || ESC_LATEX "$(get_terms)" )
    fi

    # Check if any of the variables are empty and exit if so
    for var in position company_name division locationCity locationState terms; do
        [[ -z ${!var} ]] && { echo "The variable '$var' is empty. Exiting."; exit 1; }
    done

    local filename="Hussain, Arfaz - Placement Application - ${position} - ${company_name} ${company_suffix} - ${division}"
    [ "$terms" == "TEST" ] && filename="TEST-$(date '+%Y-%m-%d')-$(random_two)"
    
    LaTeX "$position" "$company_name" "$company_suffix" "$division" "$locationCity" "$locationState" "$terms"
    echo "$filename"
    unset position company_name company_suffix division locationCity locationState terms filename testCHK
}

test_removal () {
    find . -type f -name '*TEST*.pdf' -delete > /dev/null 2>&1
}

DRAW_BOX() {
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

    # ANSI escape code for red text using tput
    local RED=$(tput setaf 1)
    local RESET=$(tput sgr0)

    # Print the box with wrapped text in red
    echo "${RED}${dashes}${RESET}"
    while IFS= read -r line; do
        printf "${RED}%s%-*s%s${RESET}\n" "$lineBeg" "$width" "$line" "$lineEnd"
    done <<< "$wrapped_text"
    echo "${RED}${dashes}${RESET}"
}

main () {
    echo "Number of arguments: $#"
    
    local filename=$(generator "$@" | sed 's/[\/\\,;]//g')
    perl -pe 's/^( {8}|\t{2})//' tntx.tex > ntntx.tex && mv ntntx.tex tntx.tex
    mv tntx.tex "9.3 CurrProcessed/tex-outputs/" || exit 1
    sed -i '' 's/ \+/ /g' "9.3 CurrProcessed/tex-outputs/tntx.tex"

    # This removes all "TEST" entries in the srt.sh script
    ./9.4\ PostProcessed/srt.sh > /dev/null 2>&1

    cd "9.3 CurrProcessed/tex-outputs"
    pdflatex tntx.tex > /dev/null 2>&1 && mv tntx.pdf "$filename.pdf"
    cp "$filename.pdf" ../
    cp "$filename.pdf" ../../9.5\ Applications/
    rm -f !(*.tex)
    cd ../../ || exit

    printf "%s" "${filename}.pdf" | pbcopy
    # printf "Cover letter generated and saved as \033[31m%s\033[0m\n" "${filename}.pdf"
    DRAW_BOX "$(printf "Cover letter generated and saved as %s.pdf" "$filename")"
    unset filename
}

test_removal
main "$@"