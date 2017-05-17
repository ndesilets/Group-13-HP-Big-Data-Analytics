TRUNCATE TABLE CAPSTONE_DEMO.BTS_STAT_HISTORY;
DROP TABLE CAPSTONE_DEMO.BTS_STAT_HISTORY;
CREATE TABLE CAPSTONE_DEMO.BTS_STAT_HISTORY

(
SNAPSHOT_TS TIMESTAMP,
SNAPSHOT_ID NUMBER,
TSN NUMBER,
TSV NUMBER,
MAXSIZE NUMBER,
CURSIZE NUMBER,
USED NUMBER,
UTIME NUMBER,
DALLOC NUMBER,
DFREE NUMBER,
NALLOC NUMBER,
NFREE NUMBER,
DTIME NUMBER,
TALLOC NUMBER,
TFREE NUMBER,
TTIME NUMBER,
FLAG NUMBER,
CON_ID NUMBER
);

INSERT INTO CAPSTONE_DEMO.BTS_STAT_HISTORY

SELECT
  SYSTIMESTAMP AS SNAPSHOT_TS,
  NULL AS SNAPSHOT_TS,
  A.TSN,
  A.TSV,
  A.MAXSIZE,
  A.CURSIZE,
  A.USED,
  A.UTIME,
  A.DALLOC,
  A.DFREE,
  A.NALLOC,
  A.NFREE,
  A.DTIME,
  A.TALLOC,
  A.TFREE,
  A.TTIME,
  A.FLAG,
  A.CON_ID
FROM V$BTS_STAT A;

COMMIT;

WITH EXPERIMENT_FILTER AS

(
SELECT
  *
FROM CAPSTONE_DEMO.TIME_USAGE_SUMMARY_V
WHERE MODULE = 'DB_BIG_TABLE_CACHE_EXPERIMENT'
AND CLIENT_INFO = 'SINGLE_TABLE_ANALYTICS_V1'
AND PARALLEL_DEGREE_POLICY = 'POLICY = ADAPTIVE'
)

SELECT
  C.MODULE,
  C.CLIENT_INFO,
  C.SQL_EXEC_START,
  C.RUN_NUMBER,
  C.PARALLEL_DEGREE_POLICY,
  C.BT_CACHE_TARGET,
  A.*
FROM CAPSTONE_DEMO.BTS_STAT_HISTORY A
  INNER JOIN EXPERIMENT_FILTER C
    ON A.SNAPSHOT_TS BETWEEN C.SQL_EXEC_START AND C.SQL_EXEC_END
ORDER BY
  A.SNAPSHOT_TS;