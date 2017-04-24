ALTER SESSION SET DB_FILE_MULTIBLOCK_READ_COUNT=32;
ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2147483647;
ALTER SESSION SET HASH_AREA_SIZE = 2147483647;
ALTER SESSION ENABLE PARALLEL DML;

-- Set up table
DROP TABLE dr_part_date_sub_id_16;

CREATE TABLE dr_part_date_sub_id_16
PARTITION BY RANGE(PRESS_LOCAL_TIME)
INTERVAL (NUMTODSINTERVAL(1,'DAY'))
SUBPARTITION BY hash(DEVICE_ID)
  SUBPARTITION template
  (
    SUBPARTITION p1,
    SUBPARTITION p2,
    SUBPARTITION p3,
    SUBPARTITION p4,
    SUBPARTITION p5,
    SUBPARTITION p6,
    SUBPARTITION p7,
    SUBPARTITION p8,
    SUBPARTITION p9,
    SUBPARTITION p10,
    SUBPARTITION p11,
    SUBPARTITION p12,
    SUBPARTITION p13,
    SUBPARTITION p14,
    SUBPARTITION p15,
    SUBPARTITION p16
  )
(PARTITION part_01 VALUES LESS THAN (TO_DATE('01/02/2007', 'MM/DD/YYYY')) )
AS (SELECT DISTINCT device_id, press_local_time, measurement_type_key, measurement 
  FROM whitlocn.capstone_two_million
  WHERE (device_id IN ('11', '12','15','16','19','24') AND press_local_time < to_date(20171220, 'yyyymmdd'))
    OR (device_id IN ('14','23','20','25','26') AND press_local_time < to_date(20161212, 'yyyymmdd')
    OR (device_id IN ('13','17','18','21','22') AND press_local_time < to_date(20161221, 'yyyymmdd'))));

-- Set up DL
DROP TABLE data_loader;

CREATE TABLE  data_loader AS (SELECT DISTINCT device_id, press_local_time, measurement_type_key, measurement FROM whitlocn.capstone_two_billion
WHERE (device_id BETWEEN '11' AND '18') 
AND (press_local_time BETWEEN to_date(20161212, 'yyyymmdd') AND to_date(20161229, 'yyyymmdd')));

-- GLOBAL INDEX EXPERIMENTS
--------------------------------------------------------------------------------
-- Primary key experiment (Prefix)
--------------------------------------------------------------------------------
EXECUTE CAPSTONE_DEMO.RESOURCE_MONITOR.PARAMETERS_HISTORY_INSERT;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'P_DATE_S_ID_OVERLAP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'PRIMARY__KEY_PREFIX');
END;
/

ALTER TABLE dr_part_date_sub_id_16 DROP CONSTRAINT prefix_key;
ALTER TABLE dr_part_date_sub_id_16 ADD CONSTRAINT prefix_key PRIMARY KEY(press_local_time,device_id, measurement_type_key, measurement);

-- Only running in serial due to hint
INSERT /*+ PARALLEL(8) IGNORE_ROW_ON_DUPKEY_INDEX(dr_part_date_sub_id_16(press_local_time, device_id, measurement_type_key, measurement))*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

-- Merge statement
ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
DROP TABLE ERR$_dr_part_date_sub_id_16;
BEGIN
  DBMS_ERRLOG.CREATE_ERROR_LOG(DML_TABLE_NAME => 'dr_part_date_sub_id_16', ERR_LOG_TABLE_OWNER => 'WHITLOCN'); 
END;
/
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER TABLE dr_part_date_sub_id_16 DROP CONSTRAINT prefix_key;
----------------------------------------------------------------------------------
---- Primary key experiment (Non-prefix)
----------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'PRIMARY_KEY_NONPREFIX');
END;
/

ALTER TABLE dr_part_date_sub_id_16 DROP CONSTRAINT non_prefix_key;
ALTER TABLE dr_part_date_sub_id_16 ADD CONSTRAINT non_prefix_key PRIMARY KEY(device_id, press_local_time,  measurement_type_key, measurement);

INSERT /*+ PARALLEL(8) IGNORE_ROW_ON_DUPKEY_INDEX(dr_part_date_sub_id_16(device_id, press_local_time, measurement_type_key, measurement))*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

-- Merge statement
ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
DROP TABLE ERR$_dr_part_date_sub_id_16;
BEGIN
  DBMS_ERRLOG.CREATE_ERROR_LOG(DML_TABLE_NAME => 'dr_part_date_sub_id_16', ERR_LOG_TABLE_OWNER => 'WHITLOCN'); 
END;
/
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER TABLE dr_part_date_sub_id_16 DROP CONSTRAINT non_prefix_key;
----------------------------------------------------------------------------------
---- Unique index experiment (Prefix)
----------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'UNIQUE_INDEX_PREFIX');
END;
/

DROP INDEX unique_P_index;
CREATE UNIQUE INDEX unique_P_index ON dr_part_date_sub_id_16(press_local_time,device_id, measurement_type_key, measurement);

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) IGNORE_ROW_ON_DUPKEY_INDEX(dr_part_date_sub_id_16(press_local_time, device_id, measurement_type_key, measurement))*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

-- Merge statement
ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
DROP TABLE ERR$_dr_part_date_sub_id_16;
BEGIN
  DBMS_ERRLOG.CREATE_ERROR_LOG(DML_TABLE_NAME => 'dr_part_date_sub_id_16', ERR_LOG_TABLE_OWNER => 'WHITLOCN'); 
END;
/
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

DROP INDEX unique_P_index;
----------------------------------------------------------------------------------
---- Unique index experiment (Non-prefix)
----------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'UNIQUE_INDEX_NONPREFIX');
END;
/

DROP INDEX unique_NP_index;
CREATE UNIQUE INDEX unique_NP_index ON dr_part_date_sub_id_16(device_id, press_local_time,  measurement_type_key, measurement);

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) IGNORE_ROW_ON_DUPKEY_INDEX(dr_part_date_sub_id_16(device_id, press_local_time, measurement_type_key, measurement))*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

-- Merge statement
ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
DROP TABLE ERR$_dr_part_date_sub_id_16;
BEGIN
  DBMS_ERRLOG.CREATE_ERROR_LOG(DML_TABLE_NAME => 'dr_part_date_sub_id_16', ERR_LOG_TABLE_OWNER => 'WHITLOCN'); 
END;
/
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

DROP INDEX unique_NP_index;
--------------------------------------------------------------------------------
-- Nonunique index experiment (Prefix)
--------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'NONUNIQUE_INDEX_PREFIX');
END;
/

DROP INDEX nonunique_P_index;
CREATE INDEX nonunique_P_index ON dr_part_date_sub_id_16(press_local_time, device_id, measurement_type_key, measurement);

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

-- Merge statement
ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
DROP TABLE ERR$_dr_part_date_sub_id_16;
BEGIN
  DBMS_ERRLOG.CREATE_ERROR_LOG(DML_TABLE_NAME => 'dr_part_date_sub_id_16', ERR_LOG_TABLE_OWNER => 'WHITLOCN'); 
END;
/
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

DROP INDEX nonunique_P_index;
--------------------------------------------------------------------------------
-- Nonunique index experiment (Non-prefix)
--------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'NONUNIQUE_INDEX_NONPREFIX');
END;
/

DROP INDEX nonunique_NP_index;
CREATE INDEX nonunique_NP_index ON dr_part_date_sub_id_16(device_id, press_local_time,  measurement_type_key, measurement);

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

-- Merge statement
ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
DROP TABLE ERR$_dr_part_date_sub_id_16;
BEGIN
  DBMS_ERRLOG.CREATE_ERROR_LOG(DML_TABLE_NAME => 'dr_part_date_sub_id_16', ERR_LOG_TABLE_OWNER => 'WHITLOCN'); 
END;
/
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

DROP INDEX nonunique_NP_index;

-- LOCAL INDEX EXPERIMENTS
--------------------------------------------------------------------------------
-- Unique index (Prefix)
--------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'LOCAL_UNIQUE_PREFIX');
END;
/

DROP INDEX local_prefix_unique;
CREATE UNIQUE INDEX local_prefix_unique ON dr_part_date_sub_id_16(press_local_time, device_id, measurement_type_key, measurement) LOCAL;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) IGNORE_ROW_ON_DUPKEY_INDEX(dr_part_date_sub_id_16(press_local_time, device_id, measurement_type_key, measurement))*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

-- Merge statement
ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
DROP TABLE ERR$_dr_part_date_sub_id_16;
BEGIN
  DBMS_ERRLOG.CREATE_ERROR_LOG(DML_TABLE_NAME => 'dr_part_date_sub_id_16', ERR_LOG_TABLE_OWNER => 'WHITLOCN'); 
END;
/
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

DROP INDEX local_prefix_unique;
--------------------------------------------------------------------------------
-- Unique index (Non-prefix)
--------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'LOCAL_UNIQUE_NONPREFIX');
END;
/

DROP INDEX local_nonpredix_unique;
CREATE UNIQUE INDEX local_nonprefix_unique ON dr_part_date_sub_id_16(device_id, press_local_time, measurement_type_key, measurement) LOCAL;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) IGNORE_ROW_ON_DUPKEY_INDEX(dr_part_date_sub_id_16(device_id, press_local_time, measurement_type_key, measurement))*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

-- Merge statement
ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
DROP TABLE ERR$_dr_part_date_sub_id_16;
BEGIN
  DBMS_ERRLOG.CREATE_ERROR_LOG(DML_TABLE_NAME => 'dr_part_date_sub_id_16', ERR_LOG_TABLE_OWNER => 'WHITLOCN'); 
END;
/
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

DROP INDEX local_nonpredix_unique;

--------------------------------------------------------------------------------
-- Non-unique index (Prefix)
--------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'LOCAL_NONUNIQUE_PREFIX');
END;
/

DROP INDEX local_prefix_nonunique;
CREATE INDEX local_prefix_nonunique ON dr_part_date_sub_id_16(press_local_time, device_id, measurement_type_key, measurement) LOCAL;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

-- Merge statement
ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
DROP TABLE ERR$_dr_part_date_sub_id_16;
BEGIN
  DBMS_ERRLOG.CREATE_ERROR_LOG(DML_TABLE_NAME => 'dr_part_date_sub_id_16', ERR_LOG_TABLE_OWNER => 'WHITLOCN'); 
END;
/
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

DROP INDEX local_prefix_nonunique;
--------------------------------------------------------------------------------
-- Non-unqiue index (Non-prefix)
--------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'LOCAL_NONUNIQUE_NONPREFIX');
END;
/

DROP INDEX local_nonprefix_nonunique;
CREATE INDEX local_nonprefix_nonunique ON dr_part_date_sub_id_16(device_id, press_local_time, measurement_type_key, measurement) LOCAL;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 (device_id,press_local_time,measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

-- Merge statement
ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
  INTO dr_part_date_sub_id_16 dr
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
DROP TABLE ERR$_dr_part_date_sub_id_16;
BEGIN
  DBMS_ERRLOG.CREATE_ERROR_LOG(DML_TABLE_NAME => 'dr_part_date_sub_id_16', ERR_LOG_TABLE_OWNER => 'WHITLOCN'); 
END;
/
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
MERGE /*+ PARALLEL(8)*/
  INTO dr_part_date_sub_id_16 dr
  USING (SELECT * FROM DATA_LOADER) dl
  ON (dr.device_id = dl.device_id 
      AND dr.press_local_time = dl.press_local_time
      AND dr.measurement_type_key = dl. measurement_type_key
      AND dr.measurement = dl.measurement)
  WHEN NOT MATCHED THEN
    INSERT (device_id, press_local_time, measurement_type_key, measurement)
    VALUES (dl.device_id, dl.press_local_time,dl.measurement_type_key,dl.measurement)
  LOG ERRORS INTO ERR$_dr_part_date_sub_id_16 REJECT LIMIT UNLIMITED;
ROLLBACK;

DROP INDEX local_nonprefix_nonunique;

DROP TABLE dr_part_date_sub_id_16;