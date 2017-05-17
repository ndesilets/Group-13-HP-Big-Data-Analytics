#!/bin/bash

# This script is designed to create connection to Oracle
# database and run the resource usage monitor in the
# background

# Store passed arguments
logDir=${1}
dataDir=${2}
snapFreq=${3}
dbUser=${4}
password=${5}
db=${6}

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
sqlplus /nolog  <<EOF  >> ${logDir}/runMonitor.log
CONN ${dbUser}/${password}@${db}

spool ${dataDir}/runMonitor.dat
EXEC CAPSTONE_DEMO.RESOURCE_MONITOR.RESOURCE_USAGE_MONITORING_V2(${snapFreq});
spool off

EOF

echo 'Ending Monitoring Loop'
