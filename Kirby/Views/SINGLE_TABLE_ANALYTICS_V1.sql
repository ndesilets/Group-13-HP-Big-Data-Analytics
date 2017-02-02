CREATE OR REPLACE VIEW CAPSTONE_DEMO.SINGLE_TABLE_ANALYTICS_V1 AS

SELECT 
  DEVICE_ID,
  AVG(MEASUREMENT) AS AVG_MEASUREMENT
FROM CAPSTONE_DEMO.CAPSTONE_PARALLEL_TEST_V1
GROUP BY
  DEVICE_ID;