import csv
from jobspy import scrape_jobs

jobs = scrape_jobs(
    site_name=["indeed", "linkedin", "zip_recruiter", "glassdoor"],
    search_term="full stack intern co-op OR web developer intern co-op OR back end intern co-op OR back-end intern co-op OR full-stack intern co-op",
    # search_term="software engineer \"intern\" co-op OR software developer \"intern\" co-op OR software engineer intern \"co-op\" OR software developer intern \"co-op\"",
    location="Canada",
    verbose=2,
    results_wanted=500,
    job_type="internship",
    country_indeed='Canada',  # only needed for indeed / glassdoor
    hours_old=60, # (only Linkedin/Indeed is hour specific, others round up to days old)
    
    linkedin_fetch_description=True # get full description , direct job url , company industry and job level (seniority level) for linkedin (slower)
    # proxies=["208.195.175.46:65095", "208.195.175.45:65095", "localhost"],
    
)
print(f"Found {len(jobs)} jobs")
print(jobs.head())
jobs.to_csv("jobs.csv", quoting=csv.QUOTE_NONNUMERIC, escapechar="\\", index=False) # to_excel