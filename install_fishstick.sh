#!/bin/bash

export fishstick_build_path=~/Downloads/fishstick-blackband
export fishstick_install_path=~/Desktop/fishstick-install
export fishstick_git_url=git@github.com:Eyelights/fishstick-blackband.git
export s3_dependencies_urls=(
    s3://eyelights-computer-vision/gd-eye-I/5/DEBUG.zip
    s3://eyelights-computer-vision/gd-eye-I/5/RELEASE.zip
    s3://eyelights-computer-vision/gd-eye-recognizer/3/DEBUG.zip
    s3://eyelights-computer-vision/gd-eye-recognizer/3/RELEASE.zip
    s3://eyelights-computer-vision/gd-eye-stttts/11/DEBUG.zip
    s3://eyelights-computer-vision/gd-eye-stttts/11/RELEASE.zip
)

echo "Select needed branch. Available branches:"
git ls-remote --heads ${fishstick_git_url} | awk '{print $2}' | sed 's|refs/heads/||'
echo "Enter the branch name to clone:"
read -r branch_name

if [ -d ${fishstick_build_path} ]; then
    echo "Repository already exists. Updating ${fishstick_build_path}"
    git -C ${fishstick_build_path} checkout ${branch_name}
    git -C ${fishstick_build_path} pull origin ${branch_name}
else
    echo "Cloning repository to ${fishstick_build_path}"
    git clone --branch ${branch_name} ${fishstick_git_url} ${fishstick_build_path}
    git -C ${fishstick_build_path} lfs pull
fi

echo "Downloading files from S3..."
for s3_url in ${s3_dependencies_urls[@]}; do
    file_name=$(basename "$s3_url")
    aws s3 cp $s3_url .
    unzip -o $file_name -d ${fishstick_build_path}
    rm $file_name
done

echo "Export godot project"
mkdir ${fishstick_install_path}
godot --headless --export-release "Linux/X11" ${fishstick_build_path}/project.godot ${fishstick_install_path}/fishstick_core.arm64
cp -rf ${fishstick_build_path}/bin/* ${fishstick_install_path}
