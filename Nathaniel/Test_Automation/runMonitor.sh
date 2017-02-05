#!/bin/sh

# This script is designed to create connection to Oracle
# database and run the resource usage monitor in the
# background

# Store connect string
DBUSER=''
DBUSERPASSWORD=''
DB='dbcap'

# Store passed arguments
logDir=${1}
dataDir=${2}
snapFreq=${3}

# Establish connection and run monitoring loop
sqlplus /nolog  <<EOF  > ${logDir}/query.log
CONN ${DBUSER}/${DBUSERPASSWORD}@${DB}

spool ${dataDir}/runMonitor_output.dat
EXEC CAPSTONE_DEMO.RESOURCE_MONITOR.RESOURCE_USAGE_MONITORING_V2(2000,${snapFreq});
spool off

EOF

echo 'Ending Monitoring Loop'
