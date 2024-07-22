#!/bin/bash

FISHSTICK_PATH="$HOME/Downloads/fishstick-blackband"
FISHSTICK_GIT_URL="https://github.com/Eyelights/fishstick-blackband"
S3_DEPENDENCIES_URLS=(
    "s3://wqerwerwqer/create_file/296/DEBUG.zip"
    "s3://wqerwerwqer/create_file/296/RELEASE.zip"
)

echo "Cloning repository $FISHSTICK_GIT_URL into $FISHSTICK_PATH..."
git clone "$FISHSTICK_GIT_URL" "$FISHSTICK_PATH"

cd "$FISHSTICK_PATH" || exit

echo "Available branches:"
git branch -r
echo "Enter the branch name to clone:"
read -r BRANCH_NAME

git checkout "$BRANCH_NAME"

# Download and extract files
for s3_url in "${S3_DEPENDENCIES_URLS[@]}"; do
    file_name=$(basename "$s3_url")
    echo "Downloading $file_name from S3..."
    aws s3 cp "$s3_url" .
    unzip -o "$file_name" -d $FISHSTICK_PATH
    rm "$file_name"
done

echo "Script completed."
