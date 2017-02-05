#!/bin/sh

# This script is designed to facilitate the running of
# tests which will be monitored, the resulting data
# can be used to validate parameter setting effects

# Store connect string
DBUSER=''
DBUSERPASSWORD=''
DB='dbcap'

# Store passed arguments
logDir=$1
dataDir=$2
expScript=$3
moduleName=$4

# Establish connection and execute predefined queries
sqlplus /nolog  <<EOF  > ${logDir}/query.log
CONN ${DBUSER}/${DBUSERPASSWORD}@${DB}

BEGIN

DBMS_APPLICATION_INFO.SET_MODULE
(
  MODULE_NAME => 'EXPERIMENT_NATE_SUITE_V1',
  ACTION_NAME => 'RESOURCE_MONITORING'
);

END;
/

BEGIN
DBMS_APPLICATION_INFO.SET_CLIENT_INFO (client_info => 'SINGLE_TABLE_ANALYTICS_V1');
END;
/

SELECT /*+ PARALLEL(16) */
  *
FROM CAPSTONE_DEMO.SINGLE_TABLE_ANALYTICS_V1;

BEGIN
DBMS_APPLICATION_INFO.SET_CLIENT_INFO (client_info => 'PARENT_CHILD_ANALYTICS_V1');
END;
/

SELECT /*+ PARALLEL(16) */
  *
FROM CAPSTONE_DEMO.PARENT_CHILD_ANALYTICS_V1;

BEGIN
DBMS_APPLICATION_INFO.SET_CLIENT_INFO (client_info => 'LEAD_LAG_V1');
END;
/

SELECT /*+ PARALLEL(16) */
  *
FROM CAPSTONE_DEMO.LEAD_LAG_V1;

BEGIN
DBMS_APPLICATION_INFO.SET_CLIENT_INFO (client_info => 'FILTER_PARENT_CHILD_JOIN_V1');
END;
/

SELECT /*+ PARALLEL(16) */
  *
FROM CAPSTONE_DEMO.FILTER_PARENT_CHILD_JOIN_V1;
EOF

echo 'Finished Testing Suite -- ' ${moduleName}
