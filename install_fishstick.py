import os, subprocess, zipfile
from subprocess import run

FISHSTICK_PATH = os.path.expanduser("~/Downloads/fishstick-blackband")
FISHSTICK_GIT_URL = "git@github.com:Eyelights/fishstick-blackband.git"
S3_DEPENDENCIES_URLS = [
    "s3://wqerwerwqer/create_file/296/DEBUG.zip",
    "s3://wqerwerwqer/create_file/296/RELEASE.zip"
]

def get_branches(repo_url):
    result = run(["git", "ls-remote", "--heads", repo_url], capture_output=True, text=True)
    branches = []
    for line in result.stdout.splitlines():
        branch = line.split("/")[-1]
        branches.append(branch)
    return branches

def clone_or_update_repo(repo_url, branch, destination):
    if os.path.exists(destination):
        print(f"Repository already exists. Updating {destination}")
        run(["git", "checkout", branch], cwd=destination, check=True)
        run(["git", "pull", "origin", branch], cwd=destination, check=True)
    else:
        print(f"Cloning repository to {destination}")
        run(["git", "clone", "--branch", branch, repo_url, destination], check=True)
        run(["git", "lfs", "install"], cwd=destination, check=True)

def download_and_extract_s3_files(urls, destination):
    for url in urls:
        zip_file_name = os.path.join(destination, url.split('/')[-1])
        run(["aws", "s3", "cp", url, zip_file_name], check=True)
        with zipfile.ZipFile(zip_file_name, 'r') as zip_ref:
            zip_ref.extractall(destination)
        os.remove(zip_file_name)

branches = get_branches(FISHSTICK_GIT_URL)
print("Available branches:")
for i, branch in enumerate(branches):
    print(f"{i}: {branch}")

branch_index = int(input("Select branch to clone or update (number): "))
selected_branch = branches[branch_index]

clone_or_update_repo(FISHSTICK_GIT_URL, selected_branch, FISHSTICK_PATH)
print(f"Repository cloned or updated to {FISHSTICK_PATH}")

download_and_extract_s3_files(S3_DEPENDENCIES_URLS, FISHSTICK_PATH)
print(f"Files downloaded and extracted to {FISHSTICK_PATH}")
