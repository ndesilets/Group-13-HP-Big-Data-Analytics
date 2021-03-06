TRUNCATE TABLE CAPSTONE_DEMO.IM_COLUMN_LEVEL_HISTORY;
DROP TABLE CAPSTONE_DEMO.IM_COLUMN_LEVEL_HISTORY;
CREATE TABLE CAPSTONE_DEMO.IM_COLUMN_LEVEL_HISTORY
(
SNAPSHOT_TS TIMESTAMP,
SNAPSHOT_ID NUMBER,
INST_ID NUMBER,
OWNER VARCHAR2(31),
OBJ_NUM NUMBER,
TABLE_NAME VARCHAR2(31),
SEGMENT_COLUMN_ID NUMBER,
COLUMN_NAME VARCHAR2(31),
INMEMORY_COMPRESSION VARCHAR2(26),
CON_ID NUMBER
);


INSERT INTO CAPSTONE_DEMO.IM_COLUMN_LEVEL_HISTORY

SELECT
SYSTIMESTAMP AS SNAPSHOT_TS,
NULL AS SNAPSHOT_ID,
A.INST_ID,
A.OWNER,
A.OBJ_NUM,
A.TABLE_NAME,
A.SEGMENT_COLUMN_ID,
A.COLUMN_NAME,
A.INMEMORY_COMPRESSION,
A.CON_ID
FROM V$IM_COLUMN_LEVEL A;

COMMIT;