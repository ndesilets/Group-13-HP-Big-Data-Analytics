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

DECLARE
    populated boolean := false;
    completed number := 0;
BEGIN
    WHILE populated != true
    LOOP
        SELECT
            COUNT(*)
        INTO
            completed
        FROM V$IM_SEGMENTS
        WHERE POPULATE_STATUS = 'COMPLETED';

        IF completed = 2 THEN
            populated := true;
        END IF;

        DBMS_LOCK.SLEEP(SECONDS => 30);
    END LOOP;
END;
/

EOF


echo "Parameters Altered -- ${expScript}" >> lock.txt 2>&1

