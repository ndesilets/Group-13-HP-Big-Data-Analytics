#!/bin/bash

# This script sets up the environment needed to run a stat monitoring
# loop in the background as well as run a series of sql tests

# Usage statement
if [ ! $# -ge 2 ]; then
    echo 'Usage: ./driver.sh <snapFreq> <{pga,db_cache,IM-Store}> [user]'
    exit 1
fi

snapFreq=${1}
experiments=${@:2}
expDir='../exp_scripts'
logDir='../logs'
dataDir='../data'

echo $experiments;

# Outer loop to iterate through experiments
for entry in $experiments; do
   # Conditional check for directory (entry)
    echo  "${expDir}/${entry}"
done
echo "*****************************" 
echo " BEGIN EXP " `date` 
echo "*****************************" 

