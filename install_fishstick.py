import os
import subprocess
import zipfile

downloads_path = os.path.expanduser("~/Downloads")
repo_url = "git@github.com:Eyelights/fishstick-blackband.git"

def get_branches(repo_url):
    result = subprocess.run(["git", "ls-remote", "--heads", repo_url], capture_output=True, text=True)
    branches = []
    for line in result.stdout.splitlines():
        branch = line.split("/")[-1]
        branches.append(branch)
    return branches

def clone_or_update_repo(repo_url, branch, destination):
    if os.path.exists(destination):
        print(f"Repository already exists. Updating {destination}")
        subprocess.run(["git", "checkout", branch], cwd=destination, check=True)
        subprocess.run(["git", "pull", "origin", branch], cwd=destination, check=True)
    else:
        print(f"Cloning repository to {destination}")
        subprocess.run(["git", "clone", "--branch", branch, repo_url, destination], check=True)
        subprocess.run(["git", "lfs", "install"], cwd=destination, check=True)

def download_and_extract_s3_files(urls, destination):
    for url in urls:
        zip_file_name = os.path.join(destination, url.split('/')[-1])
        subprocess.run(["aws", "s3", "cp", url, zip_file_name], check=True)
        with zipfile.ZipFile(zip_file_name, 'r') as zip_ref:
            zip_ref.extractall(destination)
        os.remove(zip_file_name)

branches = get_branches(repo_url)
print("Available branches:")
for i, branch in enumerate(branches):
    print(f"{i}: {branch}")

branch_index = int(input("Select branch to clone or update (number): "))
selected_branch = branches[branch_index]

repo_name = repo_url.split("/")[-1].replace(".git", "")
clone_path = os.path.join(downloads_path, repo_name)

clone_or_update_repo(repo_url, selected_branch, clone_path)
print(f"Repository cloned or updated to {clone_path}")

s3_urls = [
    "s3://wqerwerwqer/create_file/296/DEBUG.zip",
    "s3://wqerwerwqer/create_file/296/RELEASE.zip"
]

download_and_extract_s3_files(s3_urls, clone_path)
print(f"Files downloaded and extracted to {clone_path}")
