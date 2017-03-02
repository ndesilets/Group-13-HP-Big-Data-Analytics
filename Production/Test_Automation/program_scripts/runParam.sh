#!/bin/bash

# runParam.sh
# Alters session and system setting according to the parameter (PRM)
# files that are within each passed experiemnt directory.

# Store passed arguments
logDir=$1
expScript=$2

# Establish connection and execute predefined queries
sqlplus / as sysdba <<EOF >> ${logDir}/runTest.log 

alter session set NLS_DATE_FORMAT='yyyymmdd hh24:mi:ss';

spool ${logDir}/runParam.log append
select '*********  ' ||  sysdate || '  ***********'   from dual;

@${expScript}
spool off

EOF


echo "Parameters Altered -- ${expScript}" >> lock.txt 2>&1

