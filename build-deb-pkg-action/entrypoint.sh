#!/bin/bash

wget -qO - 'https://proget.makedeb.org/debian-feeds/makedeb.pub' | gpg --dearmor | tee /usr/share/keyrings/makedeb-archive-keyring.gpg 1> /dev/null

echo 'deb [signed-by=/usr/share/keyrings/makedeb-archive-keyring.gpg arch=all] https://proget.makedeb.org/ makedeb main' | tee /etc/apt/sources.list.d/makedeb.list

apt-get update -yqq && \
eatmydata apt-get install -y makedeb

# To make makedeb root_check happy
useradd builder -m
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chmod -R a+rw .

cd "$pkg_name" || exit 1

echo "y" | sudo --set-home -u builder makedeb -s
