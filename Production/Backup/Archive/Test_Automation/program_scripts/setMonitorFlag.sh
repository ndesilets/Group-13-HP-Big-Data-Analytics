#!/bin/bash

# This script is designed to create connection to Oracle
# database and run the resource usage monitor in the
# background

# Store passed arguments
logDir=${1}
dataDir=${2}
dbUser=${3}
password=${4}
db=${5}

#echo -e '\n\n--------------------------'
#echo 'runMonitor.sh Input Vars'
#echo 'logDir: ' $logDir
#echo 'dataDir: ' $dataDir
#echo 'snapFreq: ' $snapFreq
#echo 'dbuser: ' $dbUser
#echo 'password: ' $password
#echo 'db: ' $db
#echo -e '--------------------------\n\n'

# Establish connection and run monitoring loop
sqlplus /nolog  <<EOF  > ${logDir}/query.log
CONN ${dbUser}/${password}@${db}

@../exp_scripts/START_MONITORING.sql

EOF

echo 'Monitor Flag Set to True'
