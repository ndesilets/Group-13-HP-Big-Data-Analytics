SELECT DISTINCT
  'DELETE FROM CAPSTONE_DEMO.' || TABLE_NAME || ' WHERE MODULE = ''' || 'IMCS_EXPERIMENT'' AND SQL_EXEC_START > TO_DATE(20170222, ''yyyymmdd''' || ');' AS DELETE_STATEMENT,
  'SELECT COUNT(*) FROM CAPSTONE_DEMO.' || TABLE_NAME || ' WHERE MODULE = ''' || 'IMCS_EXPERIMENT'' AND SQL_EXEC_START > TO_DATE(20170222, ''yyyymmdd''' || ');' AS COUNT_STATEMENT
FROM ALL_TAB_COLS
WHERE OWNER = 'CAPSTONE_DEMO'
AND COLUMN_NAME = 'MODULE'
AND TABLE_NAME NOT LIKE '%V';

SELECT COUNT(*) FROM CAPSTONE_DEMO.SQL_MONITOR_HISTORY WHERE MODULE = 'IMCS_EXPERIMENT' AND SQL_EXEC_START > TO_DATE(20170222, 'yyyymmdd');
SELECT COUNT(*) FROM CAPSTONE_DEMO.SQL_WORKAREA_ACTIVE_HISTORY WHERE MODULE = 'IMCS_EXPERIMENT' AND SQL_EXEC_START > TO_DATE(20170222, 'yyyymmdd');
SELECT COUNT(*) FROM CAPSTONE_DEMO.SESS_TIME_MODEL_PX_SESS_HIST WHERE MODULE = 'IMCS_EXPERIMENT' AND SQL_EXEC_START > TO_DATE(20170222, 'yyyymmdd');
SELECT COUNT(*) FROM CAPSTONE_DEMO.SESSION_PROCESS_HISTORY WHERE MODULE = 'IMCS_EXPERIMENT' AND SQL_EXEC_START > TO_DATE(20170222, 'yyyymmdd');

DELETE FROM CAPSTONE_DEMO.SQL_MONITOR_HISTORY WHERE MODULE = 'IMCS_EXPERIMENT' AND SQL_EXEC_START > TO_DATE(20170222, 'yyyymmdd');
DELETE FROM CAPSTONE_DEMO.SQL_WORKAREA_ACTIVE_HISTORY WHERE MODULE = 'IMCS_EXPERIMENT' AND SQL_EXEC_START > TO_DATE(20170222, 'yyyymmdd');
DELETE FROM CAPSTONE_DEMO.SESS_TIME_MODEL_PX_SESS_HIST WHERE MODULE = 'IMCS_EXPERIMENT' AND SQL_EXEC_START > TO_DATE(20170222, 'yyyymmdd');
DELETE FROM CAPSTONE_DEMO.SESSION_PROCESS_HISTORY WHERE MODULE = 'IMCS_EXPERIMENT' AND SQL_EXEC_START > TO_DATE(20170222, 'yyyymmdd');

SELECT
  A.MODULE,
  A.CLIENT_INFO,
  A.SQL_EXEC_START,
  A.RUN_NUMBER,
  A.DOP,
  A."_PGA_MAX_SIZE",
  A.BT_CACHE_TARGET,
  A.PARALLEL_DEGREE_POLICY,
  A.DB_CACHE_SIZE,
  A.IM_SIZE,
  A.INMEMORY_COMPRESSION,
  A.RUN_TIME_SEC,
  A.DB_TIME_SEC,
  A.CPU_TIME_SEC,
  C.USER_IO_WAIT_TIME_SEC,
  A.CPU_COUNT/(A.CPU_TIME_SEC/A.RUN_TIME_SEC) AS CEI,
  B.WORK_AREA_SIZE_GB,
  B.EXPECTED_SIZE_GB,
  B.ACTUAL_MEM_USED_GB,
  B.MAX_MEM_USED_GB,
  B.TEMPSEG_SIZE_GB,
  C.BUFFER_GETS_GB,
  C.IO_INTERCONNECT_GB,
  C.PHYSICAL_READ_GB,
  C.PHYSICAL_WRITE_GB
FROM CAPSTONE_DEMO.TIME_USAGE_SUMMARY_V A
  INNER JOIN CAPSTONE_DEMO.WORK_AREA_SUMMARY_V B
    ON A.SQL_EXEC_START = B.SQL_EXEC_START
  INNER JOIN CAPSTONE_DEMO.IO_SUMMARY_V C
    ON A.SQL_EXEC_START = C.SQL_EXEC_START
WHERE A.MODULE = 'IMCS_EXPERIMENT'
AND A.CLIENT_INFO = 'PARENT_CHILD_ANALYTICS_V1';