#!/bin/bash

# Script to sync the git repo and the working directory

# Usage statement
if [ ! $# == 1 ]; then
    echo "Usage: ./syncGit.sh <commitMessage>"
    exit 1
fi 

commitMessage=$1
dirPath="--git-dir=/home/oracle/Group-13-HP-Big-Data-Analytics/.git --work-tree=/home/oracle/Group-13-HP-Big-Data-Analytics/"

# Remove existing archive
if [ -d "/home/oracle/Group-13-HP-Big-Data-Analytics/Production/Backup" ]; then
    echo -e "Removing backup folder\n"
    rm -rf /home/oracle/Group-13-HP-Big-Data-Analytics/Production/Backup
fi  

# Rename Test Automation folder
echo -e "Preparing git directory\n"
mv /home/oracle/Group-13-HP-Big-Data-Analytics/Production/Test_Automation /home/oracle/Group-13-HP-Big-Data-Analytics/Production/Backup

# Copy over working diretory from server
echo -e "Copying new work to git diretory\n"
cp -R /home/oracle/Test_Automation /home/oracle/Group-13-HP-Big-Data-Analytics/Production/Test_Automation

# Change to git directory
#echo -e "Changed to git directory\n"
#cd /home/oracle/Test_Automation /home/oracle/Group-13-HP-Big-Data-Analytics

echo "----------------------------------------------------------------------------" >> git.log
echo " Entry -- " `date` >> git.log
echo -e "----------------------------------------------------------------------------\n" >> git.log

# Add the recent changes
echo -e "Adding new files and pushing to GitHub\n"
git ${dirPath} add --all . >> git.log
git ${dirPath} commit -m "${commitMessage}" >> git.log
git ${dirPath} config --global push.default matching >> git.log
git ${dirPath} push 2>&1 >> git.log

echo -e "----------------------------------------------------------------------------\n\n" >> git.log
