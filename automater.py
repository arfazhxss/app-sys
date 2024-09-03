#!/bin/bash

# =============================================================================
# Script Name: automater.py
# Author: Arfaz Hossain
# Created Date: Thursday, August 29, 2023
# Description: 
# This script processes job application data from a JSON file and generates 
# LaTeX cover letters for each job entry. It includes functions to clean and 
# validate job titles, organization names, division names, work term durations, 
# job locations, and regions. The script also escapes LaTeX special characters 
# and runs a shell script to generate the final output.
#
# Usage:
# Run the script with the necessary JSON file in the specified location. The 
# script will read the data, process it, and generate the required LaTeX files.
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
# =============================================================================

import os
import re
import json
from termcolor import colored
import subprocess

location_data_path = "/Users/arfaz/Desktop/Projects/app-sys/9.4 PostProcessed/location_data"

with open('9.0 LIM+/result.json', 'r') as file:
    data = json.load(file)

def escape_latex_chars(s):
    special_chars = ['&', '%', '$', '#', '_', '{', '}', '\\', '~', '^']
    for char in special_chars:
        s = s.replace(char, '\\' + char)
    return s

def is_city(city_name):
    for filename in os.listdir(location_data_path):
        if filename.endswith(".txt"):
            file_path = os.path.join(location_data_path, filename)
            with open(file_path, 'r') as file:
                cities = file.readlines()
                if any(city_name.strip().lower() == city.strip().lower() for city in cities):
                    return True
    return False

def org_chk(organization, num):
    suffix_file_path = "/Users/arfaz/Desktop/Projects/app-sys/9.4 PostProcessed/company_data/company_suffix.txt"

    with open(suffix_file_path, 'r') as file:
        suffixes = file.read().splitlines()

    clean_org = organization.split("-")[0].split(",")[0].split("(")[0]

    for suffix in suffixes:
        if suffix in clean_org:
            clean_org = clean_org.replace(f'{suffix}', "")
    
    if num==1:
        return clean_org.strip()
    elif num==2:
        return organization[len(clean_org.strip()):].replace(",","-").replace("Ltd","Ltd.").replace("Inc","Inc.").replace("Corp","Corp.").strip() if len(organization[len(clean_org)-1:].strip()) > 1 else ""

def div_chk(organization, division):
    for word in division.split():
        if is_city(word) and (word.lower() not in ["branch","canada","forest","pacific","legal","afton","mountain"]):
            division = word+" Office"
            return division
    if organization.lower() in division.lower():
        division = re.sub(rf'(?i)\b{organization}\b', '', division).strip()
        division = re.sub(r'\s+', ' ', division).strip()
        # Ensure parentheses are not mistakenly removed
        if not division.startswith('('):
            division = division.lstrip(' (')
        if not division.endswith(')'):
            division = division.rstrip(' )')
    elif division.lower() in organization.lower():
        division = "Human Resources"
    if (division in ["Headquarters","Headquarter","HQ"] ) or (not division or division.lower() == organization.lower()):
        division = "Human Resources"
    if division.startswith('(') and division.endswith(')'):
        division = division[1:-1]
    if division=="New Afton Mine":
        division="Human Resources"
    return division

def jb_chk(title):
    # Remove words containing numbers and text within parentheses
    title = re.sub(r'\b\w*\d\w*\b', '', re.sub(r'\s*\(.*?\)', '', title))
    title = title.replace('Students', '')
    title = title.replace('Student', '')
    title = title.replace('Position', '')
    title = title.replace('Tier', '')
    
    translation_table = str.maketrans({
        '|': '',
        ',': '',
        '/': ' or '
    })
    
    title = ' '.join(title.translate(translation_table).split())
    
    if any(sub in title.lower() for sub in ["opportunities", "various"]):
        return "XXX"
    
    seasons = r'\b(Fall|Spring|Summer|Winter)\b'
    years = r'\b(19|20)\d{2}\b'
    job_types = r'\b(Co-op|Internship|Intern|Job|Co op|Coop)\b'
    patterns = f'({seasons}|{years}|{job_types})'
    clean_title = re.sub(patterns, '', title, flags=re.IGNORECASE).strip()
    clean_title = re.sub(r'\s+', ' ', clean_title).strip()

    clean_title = clean_title.replace(' - ', 'and')
    clean_title = clean_title.replace(' -', '')
    clean_title = clean_title.replace('- ', '')
    clean_title = clean_title.replace('HelpDesk', 'Help-Desk')
    if clean_title=="":
        clean_title="Engineering Co-op"
    return clean_title.strip()

def dr_chk(duration_string):
    duration_string = re.sub(r'\s*\(.*?\)', '', duration_string)
    durations = ["4", "8", "12", "16"]
    found = [d for d in durations if f"{d} " in duration_string]
    
    if len(found) == 1:
        return f"a{'n' if found[0] == '8' else ''} {found[0]}-month"
    elif len(found) > 1 and not any(sub in duration_string for sub in ["Min", "Max"]):
        return " or ".join([f"{'an' if d == '8' else 'a'} {d}-month" for d in found])
    elif len(found) > 1 and any(sub in duration_string for sub in ["Min", "Max"]):
        return " to ".join([f"{'an' if d == '8' else 'a'} {d}-month" for d in found])

def cty_chk(city):
    if "," in city:
        city=city.split(',')[0]
    if any(sub in city.lower() for sub in [" and "," or ","various"]):
        return "XXX"
    return city

def rg_chk(city1, region):
    region = re.sub(r'\s*\(.*?\)', '', region)
    provinces = {
        'AB': 'Alberta',
        'BC': 'British Columbia',
        'MB': 'Manitoba',
        'NB': 'New Brunswick',
        'NL': 'Newfoundland and Labrador',
        'NS': 'Nova Scotia',
        'ON': 'Ontario',
        'PE': 'Prince Edward Island',
        'QC': 'Quebec',
        'SK': 'Saskatchewan',
        'NT': 'Northwest Territories',
        'NU': 'Nunavut',
        'YT': 'Yukon'
    }
    
    if "Remote" in city:
        return "Remote"
    elif any(sub in region.lower() for sub in ["various","n/a"]) or "-" not in region:
        return "XXX"
    else:    
        abb,city2=region.split('-')[0:2]
        city2=' '.join([provinces.get(word, word) for word in city2.split()])
        rgx = provinces.get(abb,abb)
        if city2==city1 or city1 in city2:
            city2="XXX"
        if rgx in city2:
            rgx="XXX"
        return (city2+", "+rgx).replace("XXX, ","").replace(", XXX","")

job_titles = []
organization_names = []
division_names = []
work_term_durations = []
job_locations = []
regions = []
company_suffixes = []

for element in data:
    i=0
    for key, sub_elements in element.items():
        if i==24:
            print(f'{i} [{sub_elements.get("Job Title", "").split('(')[0].strip()}]')
            print(f'{i} [{jb_chk(sub_elements.get("Job Title", "").split('(')[0].strip())}]')
        job_titles.append(jb_chk(sub_elements.get("Job Title", "").split('(')[0].strip()))
        organization_names.append(org_chk(sub_elements.get("Organization Name", ""),1))
        company_suffixes.append(org_chk(sub_elements.get("Organization Name", ""),2))
        division_names.append(div_chk(sub_elements.get("Organization Name", ""),(sub_elements.get("Division Name", ""))))
        work_term_durations.append(dr_chk(sub_elements.get("Co-op Work term Duration", "")))
        city = cty_chk(sub_elements.get("Job Location", ""))
        job_locations.append(city)
        regions.append(rg_chk(city,sub_elements.get("Region", "")))
        i+=1

for i in range(len(job_titles)):
    # print(f'{i} [{organization_names[i]}]')
    # print(f'{i} [{escape_latex_chars(company_suffixes[i])}]')
    # print(f'>> [{company_suffixes[i]}]')
    # print(f'{division_names[i]}')
    # print(f'>> {job_locations[i]}')
    # print(f'{i} {regions[i]}')
    # print(f'./atm.sh "{job_title}" "{organization_name}" "{company_suffix}" "{division_name}" "{job_location}" "{region}" "{work_term_duration}"')
    syst=f'./atm.sh "{job_titles[i]}" "{organization_names[i]}" "{escape_latex_chars(company_suffixes[i])}" "{escape_latex_chars(division_names[i])}" "{job_locations[i]}" "{regions[i]}" "{work_term_durations[i]}"'
    if ((job_locations[i]=="XXX") or (regions[i]=="XXX")):
        # print(i,colored(syst, 'blue'))
        continue
    subprocess.run(syst,shell=True)