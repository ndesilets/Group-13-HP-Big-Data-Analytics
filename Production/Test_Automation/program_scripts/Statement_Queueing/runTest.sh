#!/bin/bash

# runTest.sh
# Established independent connection and runs the sql experiment
# files. Once finished the monitoring loop is terminated.

# Store passed arguments
logDir=$1
dataDir=$2
expScript=$3
dbUser=$4
password=$5
db=$6

#echo -e '\n--------------------------'
#echo 'runTest.sh Input Vars'
#echo 'logDir: ' $logDir
#echo 'dataDir: ' $dataDir
#echo 'dbuser: ' $dbUser
#echo 'db: ' $db
#echo -e '--------------------------\n'

# Establish connection and execute predefined queries
sqlplus /nolog <<EOF >> ${logDir}/runTest.log 
CONN ${dbUser}/${password}@${db}
alter session set NLS_DATE_FORMAT='yyyymmdd hh24:mi:ss';

spool ${logDir}/runTest.log append
select '*********  ' ||  sysdate || '  ***********'   from dual; 
@${expScript}
spool off

EOF


echo 'Test Script Completed -- ' ${expScript}
