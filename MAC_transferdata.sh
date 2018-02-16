#!/bin/bash

err_report() {
    echo "Error on line $1"
}

trap 'err_report $LINENO' ERR

# Get user input
read -p 'Techs username: ' your_id
read -sp 'Techs Password: ' passvar
printf "\n"
read -p 'Enter users ID: ' uservar
echo Next prompt is users password

# Set date for for folder name
DATE=`date +%m-%d-%Y`

# Mount shared folder
sudo mkdir -p /mnt/home
sudo mount_smbfs //$your_id:$passvar@<remoteserver> /mnt/home

# Make dir
sudo test -d "/mnt/home/$uservar" || sudo mkdir -p "/mnt/home/$uservar"
sudo mkdir -p /mnt/home/$uservar/IT_backup\ $DATE/Desktop /mnt/home/$uservar/IT_backup\ $DATE/Documents /mnt/home/$uservar/IT_backup\ $DATE/Pictures

# Copy files
sudo cp -v -R /users/$uservar/Documents/ /mnt/home/$uservar/IT_backup\ $DATE/Documents
sudo cp -v -R /users/$uservar/Desktop /mnt/home/$uservar/IT_backup\ $DATE/Desktop
sudo cp -v -R /users/$uservar/Pictures /mnt/home/$uservar/IT_backup\ $DATE/Pictures
sudo cp -v -R /users/$uservar/Library/Application\ Support/Google/Chrome/Default/Bookmarks /mnt/home/$uservar/IT_backup\ $DATE/ 

# Unmount drive
sudo umount /mnt/home