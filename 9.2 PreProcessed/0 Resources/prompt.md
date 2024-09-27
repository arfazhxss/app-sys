---

**Find me the following information from the job posting:**

- **Job Title:**  
  The official title of the job. **Do not include words like "co-op" or "internship" in the job title**. Just the core job title (e.g., "Software Engineer" not "Software Engineer Internship").
  
- **Company Name:**  
  The name of the company, without any suffixes like "Ltd." or "Inc."  
  **Example:** "Google" from "Google Inc."

- **Company Suffix:**  
  If the company name includes a suffix like "Ltd.", "Inc." etc., provide it here separately. **If there's no suffix, leave this blank**.
  
- **Division or Team:**  
  The division, team, or department this job is for (if specified).
  
- **Province:**  
  The full name of the Canadian province where the job is located. **Use the full name, not abbreviations** (e.g., "British Columbia", not "BC").

- **City:**  
  The city where the job is located.

- **Number of Work Terms:**  
  If the posting specifies the number of work terms (e.g., one term, two terms, etc.), include it here.  
  **Example:** "one", "two".

- **Work Term Duration:**  
  Choose the exact term duration from the following list based on how it's described in the posting. **It must exactly match one of these options**. If the posting lists a range, use the closest matching phrase. **Convert weeks to months if necessary.**

  - a 12-month
  - a 12-month or a 16-month
  - a 16-month
  - a 4, 8 or a 12-month
  - a 4, 8, 12 or 16-month
  - a 4-month
  - a 4-month or an 8-month
  - an 8, 12 or a 16-month
  - an 8-month
  - an 8-month or a 12-month

**For example:**
  - If the job posting says "4-12 months", use **"a 4, 8 or a 12-month"**.
  - If it says "8 to 12 months", use **"an 8-month or a 12-month"**.
  - If it mentions "weeks", calculate and convert into the matching **months** phrase.

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

the "two" is just an extra that we won't need above.

**Be sure to mention where you found each piece of data in the file.**

---