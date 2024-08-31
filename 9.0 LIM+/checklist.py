import json
import sys
sys.path.append('/Users/arfaz/Library/Python/3.11/lib/python/site-packages')
from termcolor import colored

# Define the required sub-elements
required_sub_elements = [
    "Organization Name",
    "Division Name",
    # "Special Job Requirements",
    "Co-op Work Term",
    "Position Type (Disclaimer not all types available in all programs)",
    "Co-op Work term Duration",
    "Job Title",
    "Job Location",
    "Region",
    # "Are remote work arrangements possible for this co-op role?",
    "Does this job require the student to be fully vaccinated for COVID-19?",
    "Is this a contractor role?",
    # "Hours per Week",
    # "Start Date",
    "Number of Positions",
    "Work Abroad",
    "Job Description",
    "Qualifications",
    "For relevant employers as defined by the BC Criminal Review Act Will this position require a co-op student to complete a Criminal Records check?",
    "Minimum Academic Year Completed",
    "Minimum Work terms Completed",
    "Are there any restrictions that would hinder hiring of non-Canadian students with a valid work permit?",
    "Application Deadline",
    "Application Procedure",
    # "Application documents required",
    # "Level of co-op student (multi-select)",
    "All Degrees and Disciplines",
    "Targeted Faculties and Co-op Programs",
    "Organization",
    "Division"
]

# Read the JSON file
with open('result.json', 'r') as file:
    data = json.load(file)

# Check each element
for element in data:
    for key, sub_elements in element.items():
        job_title = sub_elements.get("Job Title", "Unknown Job Title")
        present_elements = [sub_elem for sub_elem in required_sub_elements if sub_elem in sub_elements]
        missing_elements = [sub_elem for sub_elem in required_sub_elements if sub_elem not in sub_elements]
        
        count_present = len(present_elements)
        count_required = len(required_sub_elements)
        
        if not missing_elements:
            print(f"{colored('✓', 'green')} {colored(job_title, 'grey')}{colored(': (', 'grey')}{colored(f'{count_present}/{count_required}', 'yellow')}{colored(')', 'grey')}")
        else:
            # print(colored(f"{job_title}: ({count_present}/{count_required})", 'red'))
            print(f"{colored('✗', 'red')} {colored(job_title, 'grey')}{colored(': (', 'grey')}{colored(f'{count_present}/{count_required}', 'yellow')}{colored(')', 'grey')}")
            for missing in missing_elements:
                print(colored(f"[✗] {missing}", 'grey'))
