--Resource Monitoring Tables
BEGIN -- Gather Stats

DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'CAPSTONE_DEMO', TABNAME => 'SQL_MONITOR_HISTORY', GRANULARITY => 'ALL', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, DEGREE => 4, CASCADE => DBMS_STATS.AUTO_CASCADE);
DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'CAPSTONE_DEMO', TABNAME => 'SESSION_PROCESS_HISTORY', GRANULARITY => 'ALL', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, DEGREE => 4, CASCADE => DBMS_STATS.AUTO_CASCADE);
DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'CAPSTONE_DEMO', TABNAME => 'SQL_WORKAREA_ACTIVE_HISTORY', GRANULARITY => 'ALL', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, DEGREE => 4, CASCADE => DBMS_STATS.AUTO_CASCADE);
DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'CAPSTONE_DEMO', TABNAME => 'SESS_TIME_MODEL_PX_SESS_HIST', GRANULARITY => 'ALL', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, DEGREE => 4, CASCADE => DBMS_STATS.AUTO_CASCADE);

END;