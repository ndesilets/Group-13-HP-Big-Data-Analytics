SQL_TO_GENERATE_SQL
TRUNCATE TABLE CAPSTONE_DEMO.IM_USER_SEGMENTS_HISTORY;
DROP TABLE CAPSTONE_DEMO.IM_USER_SEGMENTS_HISTORY;
CREATE TABLE CAPSTONE_DEMO.IM_USER_SEGMENTS_HISTORY
(
SNAPSHOT_TS TIMESTAMP,
SNAPSHOT_ID NUMBER,
SEGMENT_NAME VARCHAR2(128),
PARTITION_NAME VARCHAR2(128),
SEGMENT_TYPE VARCHAR2(18),
TABLESPACE_NAME VARCHAR2(30),
INMEMORY_SIZE NUMBER,
BYTES NUMBER,
BYTES_NOT_POPULATED NUMBER,
POPULATE_STATUS VARCHAR2(9),
INMEMORY_PRIORITY VARCHAR2(8),
INMEMORY_DISTRIBUTE VARCHAR2(15),
INMEMORY_DUPLICATE VARCHAR2(13),
INMEMORY_COMPRESSION VARCHAR2(17),
CON_ID NUMBER
);


INSERT INTO CAPSTONE_DEMO.IM_USER_SEGMENTS_HISTORY

SELECT
SYSTIMESTAMP AS SNAPSHOT_TS,
NULL AS SNAPSHOT_ID,
A.SEGMENT_NAME,
A.PARTITION_NAME,
A.SEGMENT_TYPE,
A.TABLESPACE_NAME,
A.INMEMORY_SIZE,
A.BYTES,
A.BYTES_NOT_POPULATED,
A.POPULATE_STATUS,
A.INMEMORY_PRIORITY,
A.INMEMORY_DISTRIBUTE,
A.INMEMORY_DUPLICATE,
A.INMEMORY_COMPRESSION,
A.CON_ID
FROM V$IM_USER_SEGMENTS A;

COMMIT;