CREATE OR REPLACE VIEW CAPSTONE_DEMO.IO_SUMMARY_V AS

WITH IO_OVER_TIME AS

(
SELECT
  SQL_EXEC_START,
  SQL_EXEC_ID,
  SNAPSHOT_TS,
  SQL_ID,
  ROUND(CAPSTONE_DEMO.INTERVAL_TO_SEC(SNAPSHOT_TS - SQL_EXEC_START),0) AS RUN_TIME_SEC,
  SUM(BUFFER_GETS) AS BUFFER_GETS,
  SUM(BUFFER_GETS)*8/POWER(1024,2) AS BUFFER_GETS_GB,
  SUM(DISK_READS) AS DISK_READS,
  SUM(DIRECT_WRITES) AS DIRECT_WRITES,
  SUM(IO_INTERCONNECT_BYTES)/POWER(1024,3) AS IO_INTERCONNECT_GB,
  SUM(PHYSICAL_READ_REQUESTS) AS PHYSICAL_READ_REQUESTS,
  SUM(PHYSICAL_READ_BYTES)/POWER(1024,3) AS PHYSICAL_READ_GB,
  SUM(PHYSICAL_WRITE_REQUESTS) AS PHYSICAL_WRITE_REQUESTS,
  SUM(PHYSICAL_WRITE_BYTES)/POWER(1024,3) AS PHYSICAL_WRITE_GB,
  SUM(USER_IO_WAIT_TIME/1E6) AS USER_IO_WAIT_TIME_SEC
FROM CAPSTONE_DEMO.SQL_MONITOR_HISTORY
GROUP BY
  SQL_EXEC_START,
  SQL_EXEC_ID,
  SNAPSHOT_TS,
  SQL_ID
)

SELECT
  SQL_EXEC_START,
  SQL_EXEC_ID,
  SQL_ID,
  MAX(BUFFER_GETS) AS BUFFER_GETS,
  MAX(BUFFER_GETS_GB) AS BUFFER_GETS_GB,
  MAX(DISK_READS) AS DISK_READS,
  MAX(DIRECT_WRITES) AS DIRECT_WRITES,
  MAX(IO_INTERCONNECT_GB) AS IO_INTERCONNECT_GB,
  MAX(PHYSICAL_READ_REQUESTS) AS PHYSICAL_READ_REQUESTS,
  MAX(PHYSICAL_READ_GB) AS PHYSICAL_READ_GB,
  MAX(PHYSICAL_WRITE_REQUESTS) AS PHYSICAL_WRITE_REQUESTS,
  MAX(PHYSICAL_WRITE_GB) AS PHYSICAL_WRITE_GB,
  MAX(USER_IO_WAIT_TIME_SEC) AS USER_IO_WAIT_TIME_SEC
FROM IO_OVER_TIME
GROUP BY
  SQL_EXEC_START,
  SQL_EXEC_ID,
  SQL_ID;
