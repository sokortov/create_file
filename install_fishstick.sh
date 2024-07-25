#!/bin/bash

export fishstick_git_url=git@github.com:Eyelights/fishstick-blackband.git
export fishstick_build_path=~/Downloads/fishstick-blackband
export fishstick_install_path=~/Documents/fishstick-install

export fishstick_executable_path=${fishstick_install_path}/fishstick_core.arm64
export autorun_dir=~/.config/autostart
export fishstick_autorun_file_path=${autorun_dir}/fishstick_core.desktop

export gd_eye_i_version=5
export gd_eye_recognizer_version=3
export gd_eye_stttts_version=11
export s3_dependencies_urls=(
    s3://eyelights-computer-vision/gd-eye-I/${gd_eye_i_version}/DEBUG.zip
    s3://eyelights-computer-vision/gd-eye-I/${gd_eye_i_version}/RELEASE.zip
    s3://eyelights-computer-vision/gd-eye-recognizer/${gd_eye_recognizer_version}/DEBUG.zip
    s3://eyelights-computer-vision/gd-eye-recognizer/${gd_eye_recognizer_version}/RELEASE.zip
    s3://eyelights-computer-vision/gd-eye-stttts/${gd_eye_stttts_version}/DEBUG.zip
    s3://eyelights-computer-vision/gd-eye-stttts/${gd_eye_stttts_version}/RELEASE.zip
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
godot --headless --export-release "Linux/X11" ${fishstick_build_path}/project.godot ${fishstick_executable_path}
cp -rf ${fishstick_build_path}/bin/* ${fishstick_install_path}
cp -rf ${fishstick_build_path}/blackband ${fishstick_install_path}

echo "Add fishstick to autorun"
mkdir -p ${autorun_dir}
cat > ${fishstick_autorun_file_path} <<EOF
[Desktop Entry]
Type=Application
Exec=bash -c 'sleep 5; ${fishstick_executable_path}'
Name=Fishstick Core
EOF
