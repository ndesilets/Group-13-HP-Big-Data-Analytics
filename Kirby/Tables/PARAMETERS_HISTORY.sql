TRUNCATE TABLE CAPSTONE_DEMO.PARAMETERS_HISTORY;
DROP TABLE CAPSTONE_DEMO.PARAMETERS_HISTORY;
CREATE TABLE CAPSTONE_DEMO.PARAMETERS_HISTORY

(
SNAPSHOT_TS TIMESTAMP,
NAME VARCHAR2(80),
VALUE VARCHAR2(4000),
DISPLAY_VALUE VARCHAR2(4000),
ISDEFAULT VARCHAR2(9),
ISSES_MODIFIABLE VARCHAR2(5),
ISSYS_MODIFIABLE VARCHAR2(9),
ISPDB_MODIFIABLE VARCHAR2(5),
ISINSTANCE_MODIFIABLE VARCHAR2(5),
ISMODIFIED VARCHAR2(10),
ISADJUSTED VARCHAR2(5),
DESCRIPTION VARCHAR2(255)
);

PROCEDURE PARAMETERS_HISTORY_INSERT AS

BEGIN

INSERT INTO CAPSTONE_DEMO.PARAMETERS_HISTORY

SELECT 
  SYSTIMESTAMP AS SNAPSHOT_TS,
  A.NAME,
  A.VALUE,
  A.DISPLAY_VALUE,
  A.ISDEFAULT,
  A.ISSES_MODIFIABLE,
  A.ISSYS_MODIFIABLE,
  A.ISPDB_MODIFIABLE,
  A.ISINSTANCE_MODIFIABLE,
  A.ISMODIFIED,
  A.ISADJUSTED,
  A.DESCRIPTION
FROM V$PARAMETER A
WHERE NAME IN (
                'pga_aggregate_limit', 
                'pga_aggregate_target', 
                '_pga_max_size', 
                'sga_max_size', 
                'sga_target', 
                'db_cache_size', 
                'db_big_table_cache_percent_target', 
                'parallel_degree_policy', 
                'parallel_min_time_threshold',
                'inmemory_size',
                'parallel_servers_target',
                'parallel_degree_limit',
                'parallel_degree_level',
                'parallel_threads_per_cpu',
                'parallel_execution_message_size',
                'parallel_min_servers',
                'parallel_max_servers',
                'parallel_adaptive_multi_user'
               );
               
COMMIT;

END PARAMETERS_HISTORY_INSERT;
/
SELECT
  *
FROM CAPSTONE_DEMO.PARAMETERS_HISTORY;