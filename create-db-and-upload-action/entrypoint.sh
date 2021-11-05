#!/bin/bash

mkdir upload_packages
cp ./*/*.deb ./upload_packages/

if [ ! -f ~/.config/rclone/rclone.conf ]; then
    mkdir --parents ~/.config/rclone
    echo "[onedrive]" >> ~/.config/rclone/rclone.conf
    echo "type = onedrive" >> ~/.config/rclone/rclone.conf

    echo "client_id=$RCLONE_ONEDRIVE_CLIENT_ID" >> ~/.config/rclone/rclone.conf
    echo "client_secret=$RCLONE_ONEDRIVE_CLIENT_SECRET" >> ~/.config/rclone/rclone.conf
    echo "region=$RCLONE_ONEDRIVE_REGION" >> ~/.config/rclone/rclone.conf
    echo "drive_type=$RCLONE_ONEDRIVE_DRIVE_TYPE" >> ~/.config/rclone/rclone.conf
    echo "token=$RCLONE_ONEDRIVE_TOKEN" >> ~/.config/rclone/rclone.conf
    echo "drive_id=$RCLONE_ONEDRIVE_DRIVE_ID" >> ~/.config/rclone/rclone.conf
fi

cd upload_packages || exit 1
mkdir conf

echo "Origin: $name" >> ./conf/distributions
echo "Label: $name" >> ./conf/distributions
echo "Codename: $codename" >> ./conf/distributions
echo "Architectures: $arch" >> ./conf/distributions
echo "Components: $component" >> ./conf/distributions
echo "Description: $description" >> ./conf/distributions
if [ ! -z "$gpg_key" ]; then
    echo "$gpg_key" | gpg --import
    key_id=$(gpg --list-key --with-colons | grep "fpr:::::::::" | sed "s/fpr::::::::://g" | sed "s/://g")
    echo "SignWith: $key_id" >> ./conf/distributions
fi

echo "verbose" >> ./conf/options
echo "basedir $PWD" >> ./conf/options
echo "section misc" >> ./conf/options
echo "priority optional" >> ./conf/options

reprepro includedeb "$codename" *.deb

apt-get install -y ca-certificates

rm -rf ./conf
rm -f *.deb
rclone delete "onedrive:${dest_path:?}"
rclone copyto ./ "onedrive:${dest_path:?}" --copy-links
