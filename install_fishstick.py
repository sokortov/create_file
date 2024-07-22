import os, subprocess, zipfile
from subprocess import run

FISHSTICK_PATH = os.path.expanduser("~/Downloads/fishstick-blackband")
FISHSTICK_GIT_URL = "git@github.com:Eyelights/fishstick-blackband.git"
S3_DEPENDENCIES_URLS = [
    "s3://wqerwerwqer/create_file/296/DEBUG.zip",
    "s3://wqerwerwqer/create_file/296/RELEASE.zip"
]

def get_fishstick_branches():
    result = run(["git", "ls-remote", "--heads", FISHSTICK_GIT_URL], capture_output=True, text=True)
    branches = []
    for line in result.stdout.splitlines():
        branch = line.split("/")[-1]
        branches.append(branch)
    return branches

def clone_or_update_fishstick_repo(branch):
    if os.path.exists(FISHSTICK_PATH):
        print(f"Repository already exists. Updating {FISHSTICK_PATH}")
        run(["git", "checkout", branch], cwd=FISHSTICK_PATH, check=True)
        run(["git", "pull", "origin", branch], cwd=FISHSTICK_PATH, check=True)
    else:
        print(f"Cloning repository to {FISHSTICK_PATH}")
        run(["git", "clone", "--branch", branch, FISHSTICK_GIT_URL, FISHSTICK_PATH], check=True)
        run(["git", "lfs", "install"], cwd=FISHSTICK_PATH, check=True)
        
    print(f"Repository cloned or updated to {FISHSTICK_PATH}")

def download_and_extract_fishstick_dependencies():
    for url in S3_DEPENDENCIES_URLS:
        zip_file_name = os.path.join(FISHSTICK_PATH, url.split('/')[-1])
        run(["aws", "s3", "cp", url, zip_file_name], check=True)
        with zipfile.ZipFile(zip_file_name, 'r') as zip_ref:
            zip_ref.extractall(FISHSTICK_PATH)
        os.remove(zip_file_name)
        print(f"Files downloaded and extracted to {FISHSTICK_PATH}")

branches = get_fishstick_branches()
print("Available branches:")
for i, branch in enumerate(branches):
    print(f"{i}: {branch}")

branch_index = int(input("Select branch to clone or update (number): "))
selected_branch = branches[branch_index]

clone_or_update_fishstick_repo(selected_branch)

download_and_extract_fishstick_dependencies()
