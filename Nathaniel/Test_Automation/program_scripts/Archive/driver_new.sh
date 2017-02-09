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

# Set up local variables
snapFreq=${1}
expScript=$( cat ${2} )
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

# Branch of to run monitor and test
echo 'Starting Monitoring Loop -- snapFreq: ' ${snapFreq}
./runMonitor.sh ${logDir} ${dataDir} ${snapFreq} &

echo 'Starting Experiment Suite -- expScript: ' ${expScript}
./runTest.sh ${logDir} ${dataDir} ${expScript}

# Remove environmental variables
unset ${ORAENV_ASK}

# Add code to query flag table to stop
# the monitor loop

echo 'Experimentation completed'

