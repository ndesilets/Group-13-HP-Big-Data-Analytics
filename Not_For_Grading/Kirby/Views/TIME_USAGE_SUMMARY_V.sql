CREATE OR REPLACE VIEW CAPSTONE_DEMO.TIME_USAGE_SUMMARY_V AS SELECT * FROM

(
WITH SESS_TIME_MOD AS

(
SELECT 
  A.MODULE,
  A.CLIENT_INFO,
  A.SQL_EXEC_START,
  A.SNAPSHOT_TS,
  A.STAT_NAME,
  A.SID,
  A.VALUE
FROM CAPSTONE_DEMO.SESS_TIME_MODEL_PX_SESS_HIST A
WHERE SQL_EXEC_START IS NOT NULL
),

TIME_PIVOT AS

(
SELECT
  *
FROM SESS_TIME_MOD
PIVOT (
      SUM(VALUE/1E6) AS SEC
      FOR STAT_NAME IN ('DB time' AS DB_TIME, 'sql execute elapsed time' AS ELAPSED_TIME, 'DB CPU' AS CPU_TIME)
      )
),

CPU_OVER_TIME AS

(
SELECT
  MODULE,
  CLIENT_INFO,
  SQL_EXEC_START,
  SNAPSHOT_TS,
  (COUNT(*) - 1)/2 AS DOP,
  CAPSTONE_DEMO.INTERVAL_TO_SEC(SNAPSHOT_TS - SQL_EXEC_START) AS RUN_TIME_SEC,
  SUM(DB_TIME_SEC) AS DB_TIME_SEC,
  SUM(CPU_TIME_SEC) AS CPU_TIME_SEC
FROM TIME_PIVOT A
GROUP BY
  MODULE,
  CLIENT_INFO,
  SQL_EXEC_START,
  SNAPSHOT_TS
)

SELECT
  A.MODULE,
  A.CLIENT_INFO,
  A.SQL_EXEC_START,
  DENSE_RANK() OVER(PARTITION BY A.MODULE, A.CLIENT_INFO, B.DOP, B."_PGA_MAX_SIZE", B.DB_BIG_TABLE_CACHE_PERCENT, B.PARALLEL_DEGREE_POLICY, B.DB_CACHE_SIZE, B.IM_SIZE, B.INMEMORY_COMPRESSION ORDER BY A.SQL_EXEC_START) AS RUN_NUMBER,
  B.CPU_COUNT,
  B.DOP,
  B."_PGA_MAX_SIZE",
  B.DB_BIG_TABLE_CACHE_PERCENT || '%' AS BT_CACHE_TARGET,
  B.PARALLEL_DEGREE_POLICY,
  B.DB_CACHE_SIZE,
  B.IM_SIZE,
  B.INMEMORY_COMPRESSION,
  MAX(A.SNAPSHOT_TS) AS SQL_EXEC_END,
  MAX(RUN_TIME_SEC) AS RUN_TIME_SEC,
  MAX(DB_TIME_SEC) AS DB_TIME_SEC,
  MAX(CPU_TIME_SEC) AS CPU_TIME_SEC
FROM CPU_OVER_TIME A
  INNER JOIN CAPSTONE_DEMO.EXPERIMENT_PARAMETERS_V B
    ON A.SQL_EXEC_START = B.SQL_EXEC_START
GROUP BY
  A.MODULE,
  A.CLIENT_INFO,
  A.SQL_EXEC_START,
  B.CPU_COUNT,
  B.DOP,
  B."_PGA_MAX_SIZE",
  B.DB_BIG_TABLE_CACHE_PERCENT,
  B.PARALLEL_DEGREE_POLICY,
  B.DB_CACHE_SIZE,
  B.IM_SIZE,
  B.INMEMORY_COMPRESSION
);

SELECT
    *
FROM CAPSTONE_DEMO.TIME_USAGE_SUMMARY_V
ORDER BY
    SQL_EXEC_START DESC;

SELECT
    *
FROM CAPSTONE_DEMO.ALL_TABLES_HISTORY
ORDER BY
    SNAPSHOT_TS DESC;
    
SELECT
    *
FROM CAPSTONE_DEMO.SQL_MONITOR_HISTORY
ORDER BY    
    SNAPSHOT_TS DESC;
    
SELECT 
  A.MODULE,
  A.CLIENT_INFO,
  A.SQL_EXEC_START,
  A.SNAPSHOT_TS,
  A.STAT_NAME,
  A.SID,
  A.VALUE
FROM CAPSTONE_DEMO.SESS_TIME_MODEL_PX_SESS_HIST A
WHERE SQL_EXEC_START IS NOT NULL
ORDER BY
    SNAPSHOT_TS DESC;