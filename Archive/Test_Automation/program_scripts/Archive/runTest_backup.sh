#!/bin/sh

# This script is designed to facilitate the running of
# tests which will be monitored, the resulting data
# can be used to validate parameter setting effects

# Store connect string
DBUSER='whitlocn'
DBUSERPASSWORD='capPass'
DB='dbcap'

# Store passed arguments
logDir=$1
dataDir=$2
moduleName=$3

# Establish connection and execute predefined queries
sqlplus /nolog  <<EOF  > ${logDir}/query.log
CONN ${DBUSER}/${DBUSERPASSWORD}@${DB}

Begin
DBMS_APPLICATION_INFO.SET_MODULE
(
  MODULE_NAME => 'Experiment_Nate_1',
  ACTION_NAME => 'RESOURCE_MONITORING'
);
End;
/

spool ${dataDir}/test_output.dat
SELECT /*+ PARALLEL(16) */
  * 
FROM CAPSTONE_DEMO.LEAD_LAG_V1;
spool off
EOF

echo 'Finished Testing Suite -- ' ${moduleName}

