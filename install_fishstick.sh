#!/bin/bash

export FISHSTICK_PATH=~/Downloads/fishstick-blackband
export FISHSTICK_GIT_URL=git@github.com:Eyelights/fishstick-blackband.git
export S3_DEPENDENCIES_URLS=(
    s3://eyelights-computer-vision/gd-eye-I/5/DEBUG.zip
    s3://eyelights-computer-vision/gd-eye-I/5/RELEASE.zip
    s3://eyelights-computer-vision/gd-eye-recognizer/3/DEBUG.zip
    s3://eyelights-computer-vision/gd-eye-recognizer/3/RELEASE.zip
    s3://eyelights-computer-vision/gd-eye-stttts/11/DEBUG.zip
    s3://eyelights-computer-vision/gd-eye-stttts/11/RELEASE.zip
)

echo "Select needed branch. Available branches:"
git ls-remote --heads $FISHSTICK_GIT_URL | awk '{print $2}' | sed 's|refs/heads/||'
echo "Enter the branch name to clone:"
read -r BRANCH_NAME

if [ -d $FISHSTICK_PATH ]; then
    echo "Repository already exists. Updating $FISHSTICK_PATH"
    git -C $FISHSTICK_PATH checkout $BRANCH_NAME
    git -C $FISHSTICK_PATH pull origin $BRANCH_NAME
else
    echo "Cloning repository to $FISHSTICK_PATH"
    git clone --branch $BRANCH_NAME $FISHSTICK_GIT_URL $FISHSTICK_PATH
    git -C $FISHSTICK_PATH lfs pull
fi

echo "Downloading files from S3..."
for s3_url in ${S3_DEPENDENCIES_URLS[@]}; do
    file_name=$(basename "$s3_url")
    aws s3 cp $s3_url .
    unzip -o $file_name -d $FISHSTICK_PATH
    rm $file_name
done

echo "Script completed."
