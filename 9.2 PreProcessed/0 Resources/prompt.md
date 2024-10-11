---

**Find me the following information from the job posting:**

- **Job Title:**  
  The official title of the job. **Do not include words like "co-op" or "internship" in the job title**. Just the core job title (e.g., "Software Engineer" not "Software Engineer Internship").  
  **If the job title can't be found, use "NOT FOUND"**.

- **Company Name:**  
  The name of the company, without any suffixes like "Ltd." or "Inc."  
  **Example:** "Google" from "Google Inc.".  
  **If the company name can't be found, use "NOT FOUND"**.

- **Company Suffix:**  
  If the company name includes a suffix like "Ltd.", "Inc." etc., provide it here separately. **If there's no suffix, leave this blank**.

- **Division or Team:**  
  The division, team, or department this job is for (if specified). If there’s no mention of a division or team, use **"Human Resources"** or **"Talent Acquisition"** depending on the job posting. For example, if it's a hiring role, suggest "Talent Acquisition".  
  If there's no division or team mentioned, **use "NOT FOUND"**.

- **Province:**  
  The full name of the Canadian province where the job is located. **Use the full name, not abbreviations** (e.g., "British Columbia", not "BC").  
  **If the province can't be found, use "NOT FOUND"**.  
  **For remote jobs, use "Canada"**.

- **City:**  
  The city where the job is located.  
  **For remote jobs, use "Remote"**.  
  **If the city can't be found, use "NOT FOUND"**.

- **Number of Work Terms:**  
  If the posting specifies the number of work terms (e.g., one term, two terms, etc.), include it here.  
  **If it’s not mentioned, use "NOT FOUND"**.

- **Work Term Duration:**  
  Choose the exact term duration from the following list based on how it's described in the posting. **It must exactly match one of these options**. If the posting lists a range, use the closest matching phrase. **Convert weeks to months if necessary**.

  - a 12-month
  - a 12-month or a 16-month
  - a 16-month
  - a 4, 8 or a 12-month
  - a 4, 8, 12 or 16-month
  - a 4-month or an 8-month
  - an 8, 12 or a 16-month
  - an 8-month
  - an 8-month or a 12-month

  **If the work term duration can't be found, use "NOT FOUND"**.

---

**Additional Instructions:**

- If there's an **"&"** inside any component, use a **"\&"** to escape it.
  
---

**Express the result in this exact format:**

```
./atm.sh "{job_title}" "{company_name}" "{company_suffix}" "{division_name}" "{city}" "{province}" "{number_of_terms} {work_term_duration}"
```

---

**Example:**

If you find a job posting for a "Software Developer" role at "Google Inc." on the "Cloud Engineering Team" in "Vancouver", "British Columbia", for **12-month terms**, the output should be:

```
./atm.sh "Software Developer" "Google" "Inc." "Cloud Engineering Team" "Vancouver" "British Columbia" "a 12-month"
```

If the posting has a remote job title but no mention of the team, you could use:

```
./atm.sh "Software Developer" "Google" "Inc." "Talent Acquisition" "Remote" "Canada" "a 12-month"
```

**Be sure to mention where you found each piece of data in the file.**

---