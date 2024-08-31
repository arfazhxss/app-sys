from pathlib import Path
from staffspy import LinkedInAccount, SolverType

# def read_credentials(file_path):
#     credentials = {}
#     with open(file_path, 'r') as file:
#         for line_number, line in enumerate(file, 1):
#             line = line.strip()
#             if not line or line.startswith('#'):  # Skip empty lines and comments
#                 continue
#             try:
#                 key, value = line.split('=', 1)  # Split on first '=' only
#                 credentials[key.strip()] = value.strip()
#             except ValueError:
#                 print(f"Warning: Ignoring invalid line {line_number}: {line}")
#     return credentials

def read_credentials(file_path):
    credentials = {}
    with open(file_path, 'r') as file:
        for line_number, line in enumerate(file, 1):
            line = line.strip()
            if not line or line.startswith('#'):  # Skip empty lines and comments
                continue
            try:
                key, value = line.split(':', 1)  # Try splitting on ':' first
                if ':' not in line:
                    key, value = line.split('=', 1)  # If ':' not found, try '='
                credentials[key.strip()] = value.strip()
            except ValueError:
                print(f"Warning: Ignoring invalid line {line_number}: {line}")
    return credentials

# Get the current directory
current_dir = Path(__file__).resolve().parent

# Read credentials from file
credentials_file = current_dir / "credentials.txt"
credentials = read_credentials(credentials_file)

session_file = current_dir / "session.pkl"
account = LinkedInAccount(
    # credentials - now read from file
    username=credentials['LOGIN'],
    password=credentials['PASSWORD'],
    solver_api_key="CAP-reeffre", # optional but needed if hit with captcha
    solver_service=SolverType.CAPSOLVER,
    
    session_file=str(session_file), # save login cookies to only log in once (lasts a week or so)
    log_level=1, # 0 for no logs
)

# The rest of your code remains the same
# search by company
staff = account.scrape_staff(
    company_name="noratek-solutions-inc",
    # search_term="software engineer",
    # location="london",
    extra_profile_data=True, # fetch all past experiences, schools, & skills
    max_results=1000, # can go up to 1000
)
# or fetch by user ids
users = account.scrape_users(
    user_ids=['williamhgates', 'rbranson', 'jeffweiner08']
)
staff.to_csv("staff.csv", index=True)
users.to_csv("users.csv", index=True)