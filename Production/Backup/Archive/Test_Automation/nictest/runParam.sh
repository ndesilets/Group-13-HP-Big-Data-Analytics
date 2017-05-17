#!/bin/bash

# This script is designed to facilitate the running of
# tests which will be monitored, the resulting data
# can be used to validate parameter setting effects

# Store passed arguments
logDir=$1
dataDir=$2
expScript=$3
dbUser=$4
password=$5
db=$6

#echo -e '\n\n--------------------------'
#echo 'runParam.sh Input Vars'
#echo 'logDir: ' $logDir
#echo 'dataDir: ' $dataDir
#echo 'dbuser: ' $dbUser
#echo 'password: ' $password
#echo 'db: ' $db
#echo -e '--------------------------\n\n'

# Establish connection and execute predefined queries
sqlplus /nolog <<EOF >> ${logDir}/runTest.log 
CONN ${dbUser}/${password}@${db} as sysdba

@${expScript}

EOF


echo 'Finished Testing Suite -- ' ${expScript}

