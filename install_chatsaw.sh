#!/bin/bash

export chatsaw_git_url=git@github.com:Eyelights/chatsaw.git
export chatsaw_build_path=~/Downloads/chatsaw
export chatsaw_install_path=~/Documents/chatsaw-install
export chatsaw_executable_path=${chatsaw_install_path}/application
export autorun_dir=~/.config/autostart
export chatsaw_autorun_file_path=${autorun_dir}/chatsaw.desktop

export chatsaw_console_git_url=git@github.com:Eyelights/chatsaw-console.git
export chatsaw_console_build_path=~/Downloads/chatsaw-console
export chatsaw_console_install_path=~/Documents/chatsaw-console-install
export start_chatsaw_console_script=${chatsaw_console_install_path}/start.sh

echo "Download chatsaw"
if [ -d ${chatsaw_build_path} ]; then
    echo "Repository already exists. Updating ${chatsaw_build_path}"
    git -C ${chatsaw_build_path} checkout develop
    git -C ${chatsaw_build_path} pull origin develop
else
    echo "Cloning repository to ${chatsaw_build_path}"
    git clone --branch develop ${chatsaw_git_url} ${chatsaw_build_path}
fi

echo "Install chatsaw"
(cd ${chatsaw_build_path}/sources && go build ${chatsaw_build_path}/sources/application.go)
mkdir -p ${chatsaw_install_path}
cp -rf ${chatsaw_build_path}/sources/application ${chatsaw_install_path}

echo "Add chatsaw to autorun"
mkdir -p ${autorun_dir}
cat > ${chatsaw_autorun_file_path} <<EOF
[Desktop Entry]
Type=Application
Exec=bash -c 'sleep 5; ${chatsaw_executable_path}'
Name=chatsaw Core
EOF

echo "Download chatsaw-console"
if [ -d ${chatsaw_console_build_path} ]; then
    echo "Repository already exists. Updating ${chatsaw_console_build_path}"
    git -C ${chatsaw_console_build_path} checkout master
    git -C ${chatsaw_console_build_path} pull origin master
else
    echo "Cloning repository to ${chatsaw_console_build_path}"
    git clone --branch master ${chatsaw_console_git_url} ${chatsaw_console_build_path}
fi

echo "Install chatsaw-console"
(cd ${chatsaw_console_build_path} && go build ${chatsaw_console_build_path}/main.go)
mkdir -p ${chatsaw_console_install_path}
cp -rf ${chatsaw_console_build_path}/main ${chatsaw_console_install_path}
echo "./main ws://127.0.0.1:5000/api/chatsaw-console/socket-notify" > ${start_chatsaw_console_script}
chmod +x ${start_chatsaw_console_script}
