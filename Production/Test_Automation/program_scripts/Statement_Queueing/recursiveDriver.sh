#!/bin/bash

# This script sets up the environment needed to run a stat monitoring
# loop in the background as well as run a series of sql tests

if [ -f lock.txt ]; then
  echo -e "\nThe testing script appears to already be running."
  echo -e "For detals see:  lock.txt\n"
  exit 1
fi

# Create temp output file
touch lock.txt

# Usage statement
if [ ! $# -ge 2 ]; then
    echo 'Usage: ./driver.sh <snapFreq> <exp 1> [<exp2>] ... [<exp n>]'
    exit 1
fi

# Set up oracle env variables
export ORACLE_SID=capstone
export ORAENV_ASK=NO
. oraenv

# Import user credentials
source ./../dbconfig.cfg

# Set up local variables
snapFreq=${1}
experiments=${@:2}
expDir='../../exp_scripts'
logDir='../../logs'
dataDir='../../data'

# Create file system
if [ ! -d ${logDir} ]; then
    mkdir ${logDir}
    echo 'Created ' ${logDir}
fi

if [ ! -d ${dataDir} ]; then
    mkdir ${dataDir}
    echo 'Created ' ${dataDir}
fi

# Starting stamp
echo "***********************************************************"  >> lock.txt 2>&1 
echo " BEGIN EXP " `date`                                           >> lock.txt 2>&1
echo "***********************************************************"  >> lock.txt 2>&1


# Outer loop to iterate through experiments
for entry in $experiments; do
    echo $entry
   # Conditional check for directory (entry)
    if [ ! -d ${expDir}/${entry} ]; then
        echo " cannot find experiment ${expDir}/${entry}" 
	continue
    fi

    echo -e "Starting experiment ${entry}\n"

    # Grab content for inner loop
    dirContents=`ls -1 ${expDir}/${entry}/*.SQL`

    # Run baseline file
    ./runParam.sh ${logDir} "${expDir}/BASELINE/BASELINE.SQL"

    for i in $dirContents; do

	# Grab file name
	name=$(basename -s .SQL $i)

	if [ -f ${expDir}/${entry}/${name}.PRM ]
	then
	    echo "${name}.PRM exists"                                 
	    echo "Modifying DB params for ${name}.PRM"                
	    ./runParam.sh ${logDir} "${expDir}/${entry}/${name}.PRM"  
	else
	    echo "${expDir}/${entry}/${name}.PRM does not exist"      
	fi

	# Branch of to run monitor and test
	./../setMonitorFlag.sh ${logDir} ${dataDir} ${dbUser} ${password} ${db}           
	echo "Starting Monitoring Loop -- ${snapFreq} "                                
	./runMonitor.sh ${logDir} ${dataDir} ${snapFreq} ${dbUser} ${password} ${db} & 
	
	flag=1
	echo "Value of flag: " $flag

	while [ $flag -lt 10 ]
	do
	    echo "Starting Experiment Suite -  ${expDir}/${entry}/${name}.SQL"                            
	    ./runTest.sh ${logDir} ${dataDir} "${expDir}/${entry}/${name}.SQL" ${dbUser} ${password} ${db} &
	    flag=$((flag+1))
	    echo "Inner loop flag: " $flag
	done
	
	wait
	
	echo "Wait over... ending monitoring loop"
	./endMonitor.sh ${logDir} ${dataDir} ${dbUser} ${password} ${db} 
    done;
done;

# Remove environmental variables
unset ORAENV_ASK

# wait for any outstanding background processes to finish
wait

# Ending stamp
echo "***********************************************************"          >> lock.txt 2>&1
echo " END EXP " `date`                                                     >> lock.txt 2>&1
echo -e "***********************************************************\n\n\n" >> lock.txt 2>&1

# Email out temp results
#mail -s 'CAPSTONE TESTING' -S smtp=smtp3.hp.com daweiss1@gmail.com kirby.sand@hp.com andy.weiss@hp.com nathaniel.whitlock1@hp.com desiletn@oregonstate.edu < lock.txt

# Append temp file and remove
#cat lock.txt >> ../../logs/output.log
rm lock.txt
