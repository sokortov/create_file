#!/bin/bash

export FISHSTICK_PATH=~/Downloads/fishstick-blackband
export FISHSTICK_GIT_URL=git@github.com:Eyelights/fishstick-blackband.git
export S3_DEPENDENCIES_URLS=(
    s3://wqerwerwqer/create_file/296/DEBUG.zip
    s3://wqerwerwqer/create_file/296/RELEASE.zip
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
    git clone --branch $BRANCH_NAME $FISHSTICK_GIT_URL $FISHSTICK_PAT
    git -C $FISHSTICK_PATH lfs pull
fi

# Download and extract files
for s3_url in ${S3_DEPENDENCIES_URLS[@]}; do
    file_name=$(basename "$s3_url")
    echo "Downloading $file_name from S3..."
    aws s3 cp $s3_url .
    unzip -o $file_name -d $FISHSTICK_PATH
    rm $file_name
done

echo "Script completed."
