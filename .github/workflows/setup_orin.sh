#!/bin/bash

export arch=arm64
export godot_version=4.2.2
export godot_path=/usr/local/bin/godot
export godot_templates_dir=~/.local/share/godot/export_templates/${godot_version}.stable

echo "Install dependencies"
sudo apt update -y && sudo apt upgrade -y && \
sudo apt install -y mc pip curl git git-lfs libavfilter-dev libcpprest-dev libssl-dev pkg-config scons awscli

echo "Install progressbar"
pip install progressbar

echo "Install GO-lang"
sudo snap install go --classic

echo "Install VSCode"
wget -O vscode-${arch}.deb https://code.visualstudio.com/sha/download\?build\=stable\&os=linux-deb-${arch}
sudo apt install -y ./vscode-${arch}.deb
rm ./vscode-${arch}.deb

echo "Install VSCode plugins"
code --install-extension ms-vscode.cmake-tools && \
code --install-extension twxs.cmake && \
code --install-extension mhutchie.git-graph

echo "Install Godot"
wget -O Godot_v${godot_version}-stable_linux.${arch}.zip https://github.com/godotengine/godot/releases/download/${godot_version}-stable/Godot_v${godot_version}-stable_linux.${arch}.zip
unzip ./Godot_v${godot_version}-stable_linux.${arch}.zip
rm ./Godot_v${godot_version}-stable_linux.${arch}.zip
sudo mv -y ./Godot_v${godot_version}-stable_linux.${arch} ${godot_path}
sudo chmod +x ${godot_path}

echo "Install Godot export template"
export godot_templates_dir=~/.local/share/godot/export_templates/${godot_version}.stable
mkdir -p ${godot_templates_dir}
wget -O Godot_v${godot_version}-stable_export_templates.tpz https://github.com/godotengine/godot/releases/download/${godot_version}-stable/Godot_v${godot_version}-stable_export_templates.tpz
unzip -d ${godot_templates_dir} -j ./Godot_v${godot_version}-stable_export_templates.tpz
rm ./Godot_v${godot_version}-stable_export_templates.tpz

echo "Enabling 'Do not distrub' mode"
gsettings set org.gnome.desktop.notifications show-banners false

echo "Disable screen blanking"
gsettings set org.gnome.desktop.session idle-delay 0

echo "Disable Wifi"
sudo nmcli radio wifi off
