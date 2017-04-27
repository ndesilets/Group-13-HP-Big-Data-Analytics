#!/bin/bash

# This script is designed to facilitate the running of
# tests which will be monitored, the resulting data
# can be used to validate parameter setting effects

# Store connect string
#source ./dbconfig.sh

# Store passed arguments
logDir=$1
dataDir=$2
#expScript=$3
moduleName=$3
dbUser=$4
password=$5
db=$6

#echo '--------------------------'
#echo 'runTest.sh Input Vars'
#echo 'logDir: ' $logDir
#echo 'dataDir: ' $dataDir
#echo 'expScript: ' $expScript      # This input needs some attention
#echo 'moduleName: ' $moduleName
#echo 'dbuser: ' $dbUser
#echo 'password: ' $password
#echo 'db: ' $db
#echo '--------------------------'

# Establish connection and execute predefined queries
sqlplus /nolog  <<EOF  > ${logDir}/query.log
CONN ${dbUser}/${password}@${db}

BEGIN

DBMS_APPLICATION_INFO.SET_MODULE
(
  MODULE_NAME => 'EXPERIMENT_NATE_SUITE_V1',
  ACTION_NAME => 'RESOURCE_MONITORING'
);

END;
/

@PGA_EXPERIMENT.sql


EOF

echo 'Finished Testing Suite -- ' ${moduleName}

