CREATE OR REPLACE VIEW CAPSTONE_DEMO.EXPERIMENT_SUMMARY_OVERALL_V AS

WITH AVERAGE_PER_RUN AS

(
SELECT
  MODULE,
  CLIENT_INFO,
  DOP,
  "_PGA_MAX_SIZE",
  BT_CACHE_TARGET,
  PARALLEL_DEGREE_POLICY,
  DB_CACHE_SIZE,
  IM_SIZE,
  A.INMEMORY_COMPRESSION,
  COUNT(*) AS TOTAL_RUNS,
  MIN(RUN_TIME_SEC) AS MIN_RUN_TIME_SEC,
  AVG(DB_TIME_SEC) AS AVG_DB_TIME_SEC,
  AVG(CPU_TIME_SEC) AS AVG_CPU_TIME_SEC,
  AVG(USER_IO_WAIT_TIME_SEC) AS AVG_USER_IO_WAIT_TIME_SEC,
  MAX(CEI) AS MAX_CEI,
  AVG(WORK_AREA_SIZE_GB) AS AVG_WORK_AREA_SIZE_GB,
  AVG(EXPECTED_SIZE_GB) AS AVG_EXPECTED_SIZE_GB,
  AVG(ACTUAL_MEM_USED_GB) AS AVG_ACTUAL_MEM_USED_GB,
  AVG(MAX_MEM_USED_GB) AS AVG_MAX_MEM_USED_GB,
  AVG(TEMPSEG_SIZE_GB) AS AVG_TEMPSEG_SIZE_GB,
  AVG(BUFFER_GETS_GB) AS AVG_BUFFER_GETS_GB,
  AVG(IO_INTERCONNECT_GB) AS AVG_IO_INTERCONNECT_GB,
  AVG(PHYSICAL_READ_GB) AS AVG_PHYSICAL_READ_GB,
  AVG(PHYSICAL_WRITE_GB) AS AVG_PHYSICAL_WRITE_GB,
  MAX(SQL_EXEC_START) AS MAX_SQL_EXEC_START
FROM CAPSTONE_DEMO.EXPERIMENT_SUMMARY_BY_RUN_V A
WHERE RUN_NUMBER <= 3
GROUP BY
  MODULE,
  CLIENT_INFO,
  DOP,
  "_PGA_MAX_SIZE",
  BT_CACHE_TARGET,
  PARALLEL_DEGREE_POLICY,
  DB_CACHE_SIZE,
  IM_SIZE,
  INMEMORY_COMPRESSION
)

SELECT
  A.MODULE,
  A.DOP,
  A."_PGA_MAX_SIZE",
  A.BT_CACHE_TARGET,
  A.PARALLEL_DEGREE_POLICY,
  A.DB_CACHE_SIZE,
  A.IM_SIZE,
  A.INMEMORY_COMPRESSION,
  B.INMEMORY_SIZE_GB,
  SUM(TOTAL_RUNS) AS TOTAL_RUNS,
  SUM(MIN_RUN_TIME_SEC) AS TOTAL_RUN_TIME_SEC,
  SUM(AVG_DB_TIME_SEC) AS TOTAL_DB_TIME_SEC,
  SUM(AVG_CPU_TIME_SEC) AS TOTAL_CPU_TIME_SEC,
  SUM(AVG_USER_IO_WAIT_TIME_SEC) AS TOTAL_IO_WAIT_TIME_SEC,
  AVG(MAX_CEI) AS AVERAGE_CEI,
  SUM(AVG_WORK_AREA_SIZE_GB) AS TOTAL_WORK_AREA_SIZE_GB,
  SUM(AVG_EXPECTED_SIZE_GB) AS TOTAL_EXPECTED_SIZE_GB,
  SUM(AVG_ACTUAL_MEM_USED_GB) AS TOTAL_ACTUAL_MEM_USED_GB,
  SUM(AVG_MAX_MEM_USED_GB) AS TOTAL_MAX_MEM_USED_GB,
  SUM(AVG_TEMPSEG_SIZE_GB) AS TOTAL_TEMPSEG_SIZE_GB,
  SUM(AVG_BUFFER_GETS_GB) AS TOTAL_BUFFER_GETS_GB,
  SUM(AVG_IO_INTERCONNECT_GB) AS TOTAL_IO_INTERCONNECT_GB,
  SUM(AVG_PHYSICAL_READ_GB) AS TOTAL_PHYSICAL_READ_GB,
  SUM(AVG_PHYSICAL_WRITE_GB) AS TOTAL_PHYSICAL_WRITE_GB,
  MAX(MAX_SQL_EXEC_START) AS MAX_SQL_EXEC_START
FROM AVERAGE_PER_RUN A
  LEFT OUTER JOIN CAPSTONE_DEMO.INMEMORY_COMPRESSION_V B
    ON A.INMEMORY_COMPRESSION = B.INMEMORY_COMPRESSION
GROUP BY
  MODULE,
  DOP,
  "_PGA_MAX_SIZE",
  BT_CACHE_TARGET,
  PARALLEL_DEGREE_POLICY,
  DB_CACHE_SIZE,
  IM_SIZE,
  A.INMEMORY_COMPRESSION,
  B.INMEMORY_SIZE_GB;
  
SELECT
  *
FROM CAPSTONE_DEMO.EXPERIMENT_SUMMARY_OVERALL_V;
WHERE 
  (MODULE = 'PGA_EXPERIMENT' AND "_PGA_MAX_SIZE" = '4G' AND DOP = 'DOP = 32')
OR
  (MODULE = 'PGA_EXPERIMENT' AND "_PGA_MAX_SIZE" = '2G' AND DOP = 'DOP = 32')
OR
  (MODULE = 'DB_BIG_TABLE_CACHE_EXPERIMENT' AND PARALLEL_DEGREE_POLICY = 'POLICY = AUTO' AND BT_CACHE_TARGET = 'BT_CACHE = 90%')
OR
  (MODULE = 'IMCS_EXPERIMENT' AND INMEMORY_COMPRESSION = 'FOR QUERY LOW')
ORDER BY
  TOTAL_RUN_TIME_SEC DESC;


