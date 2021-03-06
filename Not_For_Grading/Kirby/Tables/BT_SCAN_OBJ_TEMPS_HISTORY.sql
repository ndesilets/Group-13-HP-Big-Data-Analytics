TRUNCATE TABLE CAPSTONE_DEMO.BT_SCAN_OBJ_TEMPS_HISTORY;
DROP TABLE CAPSTONE_DEMO.BT_SCAN_OBJ_TEMPS_HISTORY;
CREATE TABLE CAPSTONE_DEMO.BT_SCAN_OBJ_TEMPS_HISTORY

(
SNAPSHOT_TS TIMESTAMP,
SNAPSHOT_ID NUMBER,
TS# NUMBER,
DATAOBJ# NUMBER,
SIZE_IN_BLKS NUMBER,
TEMPERATURE NUMBER,
POLICY VARCHAR2(10),
CACHED_IN_MEM NUMBER,
CON_ID NUMBER
);

INSERT INTO CAPSTONE_DEMO.BT_SCAN_OBJ_TEMPS_HISTORY

SELECT
  SYSTIMESTAMP AS SNAPSHOT_TS,
  NULL AS SNAPSHOT_ID,
  A.TS#,
  A.DATAOBJ#,
  A.SIZE_IN_BLKS,
  A.TEMPERATURE,
  A.POLICY,
  A.CACHED_IN_MEM,
  A.CON_ID
FROM V$BT_SCAN_OBJ_TEMPS A;

COMMIT;


WITH EXPERIMENT_FILTER AS

(
SELECT
  A.*,
  SQL_EXEC_START + RUN_TIME_SEC/60/60/24 AS SQL_EXEC_END
FROM CAPSTONE_DEMO.EXPERIMENT_SUMMARY_V A
WHERE MODULE = 'DB_BIG_TABLE_CACHE_EXPERIMENT'
AND CLIENT_INFO = 'PARENT_CHILD_ANALYTICS_V1'
--AND BT_CACHE_TARGET IN ('BT_CACHE = 90%', 'BT_CACHE = 10%')
AND PARALLEL_DEGREE_POLICY = 'POLICY = AUTO'
--AND RUN_NUMBER = 3
)

--SELECT DISTINCT
--  C.MODULE,
--  C.CLIENT_INFO,
--  C.SQL_EXEC_START,
--  C.RUN_NUMBER,
--  C.PARALLEL_DEGREE_POLICY,
--  C.BT_CACHE_TARGET,
--  B.OWNER,
--  B.OBJECT_NAME,
--  B.OBJECT_TYPE,
--  A.SIZE_IN_BLKS*8/POWER(1024,2) AS OBJ_SIZE_GB,
--  A.CACHED_IN_MEM*8/POWER(1024,2) AS CACHED_IN_MEM_GB,
--  A.POLICY
--FROM CAPSTONE_DEMO.BT_SCAN_OBJ_TEMPS_HISTORY A
--  INNER JOIN DBA_OBJECTS B
--    ON A.DATAOBJ# = B.DATA_OBJECT_ID
--  INNER JOIN EXPERIMENT_FILTER C
--    ON A.SNAPSHOT_TS BETWEEN C.SQL_EXEC_START AND C.SQL_EXEC_END
--ORDER BY
--  BT_CACHE_TARGET,
--  RUN_NUMBER;

SELECT
  C.MODULE,
  C.CLIENT_INFO,
  C.SQL_EXEC_START,
  C.RUN_NUMBER,
  C.PARALLEL_DEGREE_POLICY,
  C.BT_CACHE_TARGET,
  B.OWNER,
  B.OBJECT_NAME,
  B.OBJECT_TYPE,
  A.SNAPSHOT_TS,
  A.TS#,
  A.SIZE_IN_BLKS*8/POWER(1024,2) AS OBJ_SIZE_GB,
  A.CACHED_IN_MEM*8/POWER(1024,2) AS CACHED_IN_MEM_GB,
  A.TEMPERATURE,
  A.POLICY
FROM CAPSTONE_DEMO.BT_SCAN_OBJ_TEMPS_HISTORY A
  INNER JOIN DBA_OBJECTS B
    ON A.DATAOBJ# = B.DATA_OBJECT_ID
  INNER JOIN EXPERIMENT_FILTER C
    ON A.SNAPSHOT_TS BETWEEN C.SQL_EXEC_START AND C.SQL_EXEC_END
ORDER BY
  A.SNAPSHOT_TS;
  
SELECT
  *
FROM V$BT_SCAN_OBJ_TEMPS A
  INNER JOIN DBA_OBJECTS B
    ON A.DATAOBJ# = B.DATA_OBJECT_ID;