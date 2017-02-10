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