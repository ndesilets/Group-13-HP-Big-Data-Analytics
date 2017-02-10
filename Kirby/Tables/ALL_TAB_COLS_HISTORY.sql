TRUNCATE TABLE CAPSTONE_DEMO.ALL_TAB_COLS_HISTORY;
DROP TABLE CAPSTONE_DEMO.ALL_TAB_COLS_HISTORY;
CREATE TABLE CAPSTONE_DEMO.ALL_TAB_COLS_HISTORY

(
SNAPSHOT_TS TIMESTAMP,
OWNER VARCHAR2(128),
TABLE_NAME VARCHAR2(128),
COLUMN_NAME VARCHAR2(128),
DATA_TYPE VARCHAR2(128),
DATA_TYPE_MOD VARCHAR2(3),
DATA_TYPE_OWNER VARCHAR2(128),
DATA_LENGTH NUMBER,
DATA_PRECISION NUMBER,
DATA_SCALE NUMBER,
NULLABLE VARCHAR2(1),
COLUMN_ID NUMBER,
DEFAULT_LENGTH NUMBER,
NUM_DISTINCT NUMBER,
LOW_VALUE RAW(1000),
HIGH_VALUE RAW(1000),
DENSITY NUMBER,
NUM_NULLS NUMBER,
NUM_BUCKETS NUMBER,
LAST_ANALYZED DATE,
SAMPLE_SIZE NUMBER,
CHARACTER_SET_NAME VARCHAR2(44),
CHAR_COL_DECL_LENGTH NUMBER,
GLOBAL_STATS VARCHAR2(3),
USER_STATS VARCHAR2(3),
AVG_COL_LEN NUMBER,
CHAR_LENGTH NUMBER,
CHAR_USED VARCHAR2(1),
V80_FMT_IMAGE VARCHAR2(3),
DATA_UPGRADED VARCHAR2(3),
HIDDEN_COLUMN VARCHAR2(3),
VIRTUAL_COLUMN VARCHAR2(3),
SEGMENT_COLUMN_ID NUMBER,
INTERNAL_COLUMN_ID NUMBER,
HISTOGRAM VARCHAR2(15),
QUALIFIED_COL_NAME VARCHAR2(4000),
USER_GENERATED VARCHAR2(3),
DEFAULT_ON_NULL VARCHAR2(3),
IDENTITY_COLUMN VARCHAR2(3),
EVALUATION_EDITION VARCHAR2(128),
UNUSABLE_BEFORE VARCHAR2(128),
UNUSABLE_BEGINNING VARCHAR2(128)
);

INSERT INTO CAPSTONE_DEMO.ALL_TAB_COLS_HISTORY

SELECT
  SYSTIMESTAMP SNAPSHOT_TS,
  A.OWNER,
A.TABLE_NAME,
A.COLUMN_NAME,
A.DATA_TYPE,
A.DATA_TYPE_MOD,
A.DATA_TYPE_OWNER,
A.DATA_LENGTH,
A.DATA_PRECISION,
A.DATA_SCALE,
A.NULLABLE,
A.COLUMN_ID,
A.DEFAULT_LENGTH,
A.NUM_DISTINCT,
A.LOW_VALUE,
A.HIGH_VALUE,
A.DENSITY,
A.NUM_NULLS,
A.NUM_BUCKETS,
A.LAST_ANALYZED,
A.SAMPLE_SIZE,
A.CHARACTER_SET_NAME,
A.CHAR_COL_DECL_LENGTH,
A.GLOBAL_STATS,
A.USER_STATS,
A.AVG_COL_LEN,
A.CHAR_LENGTH,
A.CHAR_USED,
A.V80_FMT_IMAGE,
A.DATA_UPGRADED,
A.HIDDEN_COLUMN,
A.VIRTUAL_COLUMN,
A.SEGMENT_COLUMN_ID,
A.INTERNAL_COLUMN_ID,
A.HISTOGRAM,
A.QUALIFIED_COL_NAME,
A.USER_GENERATED,
A.DEFAULT_ON_NULL,
A.IDENTITY_COLUMN,
A.EVALUATION_EDITION,
A.UNUSABLE_BEFORE,
A.UNUSABLE_BEGINNING
FROM ALL_TAB_COLS A
WHERE OWNER = 'CAPSTONE_DEMO';