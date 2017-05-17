--------------------------------------------------------------------------------
-- Overlapping Data Tests for Prefix or Unique Index Prefix for Date
--------------------------------------------------------------------------------
-- Only running in serial due to hint
ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) IGNORE_ROW_ON_DUPKEY_INDEX(&1(press_local_time, device_id, measurement_type_key, measurement))*/
  INTO &1 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

-- Merge statement
ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO &1 dr
  USING data_loader dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement);
ROLLBACK; 

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO &1 dr
  USING data_loader dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement);
ROLLBACK; 

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO &1 dr
  USING data_loader dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement);
ROLLBACK; 

-- Error logging merge
DROP TABLE ERR$_TEST_ERROR;
BEGIN
  DBMS_ERRLOG.CREATE_ERROR_LOG(DML_TABLE_NAME => '_TEST_ERROR', ERR_LOG_TABLE_OWNER => 'C##CAPSTONE'); 
END;
/
ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO &1 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_TEST_ERROR REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO &1 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_TEST_ERROR REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO &1 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_TEST_ERROR REJECT LIMIT UNLIMITED;
ROLLBACK;
