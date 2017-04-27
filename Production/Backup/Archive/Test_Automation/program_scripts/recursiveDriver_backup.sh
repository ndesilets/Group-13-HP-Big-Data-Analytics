#!/bin/bash

# This script sets up the environment needed to run a stat monitoring
# loop in the background as well as run a series of sql tests

# Usage statement
if [ ! $# == 2 ]; then
    echo 'Usage: ./driver.sh <snapFreq> <expScript> [user]'
    exit 1
fi

# Set up oracle env variables
export ORACLE_SID=capstone
export ORAENV_ASK=NO
. oraenv

# Import user credentials
source ./dbconfig.cfg

# Set up local variables
snapFreq=${1}
expDir=${2}
logDir='../logs'
dataDir='../data'

# Create file system
if [ ! -d ${logDir} ]; then
    mkdir ${logDir}
    echo 'Created ' ${logDir}
fi

if [ ! -d ${dataDir} ]; then
    mkdir ${dataDir}
    echo 'Created ' ${dataDir}
fi

# Add check to see if expDir exists


dirContents=`ls -1 $expDir/*.SQL`

for i in $dirContents; do

    # Grab file name
    name=$(basename -s .SQL $i)

    echo 'Name: ' ${name}
 
    if [ -f ${expDir}/${name}.PRM ]
    then
	echo "${name}.PRM exists"
	echo "Modifying DB params for ${name}.PRM"
	./runParam.sh ${logDir} ${dataDir} "${expDir}/${name}.PRM" ${dbUser} ${password} ${db}
    else
	echo "${name}.PRM does not exist"
    fi

    # Branch of to run monitor and test
    #./setMonitorFlag.sh ${logDir} ${dataDir} ${dbUser} ${password} ${db}

    echo 'Starting Monitoring Loop -- snapFreq: ' ${snapFreq}
    #./runMonitor.sh ${logDir} ${dataDir} ${snapFreq} ${dbUser} ${password} ${db} &

    echo "Starting Experiment Suite -- expScript:  ${expScript}/${i}"
    #./runTest.sh ${logDir} ${dataDir} "${expScript}/${i}.SQL" ${dbUser} ${password} ${db}

done;

# Remove environmental variables
unset ${ORAENV_ASK}

echo 'Experimentation completed'

