CREATE OR REPLACE VIEW CAPSTONE_DEMO.PARAMETERS_V AS
/
SELECT
  A.CON_ID,
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
               )
ORDER BY
  NAME;
ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER SESSION SET CONTAINER = DBCAP;
ALTER SYSTEM SET DB_BIG_TABLE_CACHE_PERCENT_TARGET = 50;
SELECT
  *
FROM CAPSTONE_DEMO.PARAMETERS_V;

SELECT
  *
from V$BT_SCAN_CACHE;

SELECT
  *
FROM CAPSTONE_DEMO.TIME_USAGE_SUMMARY_V;