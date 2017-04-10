ALTER SESSION SET DB_FILE_MULTIBLOCK_READ_COUNT=32;
ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2147483647;
ALTER SESSION SET HASH_AREA_SIZE = 2147483647;
ALTER SESSION ENABLE PARALLEL DML;

-- Set up table

DROP TABLE dr_part_id_1_interval;

CREATE TABLE dr_part_id_1_interval
PARTITION BY RANGE (DEVICE_ID) 
  INTERVAL (1) 
  (PARTITION part_01 VALUES LESS THAN (1))
AS (SELECT DISTINCT device_id, press_local_time, measurement_type_key, measurement 
  FROM whitlocn.capstone_two_million
  WHERE (device_id IN ('11', '12','15','16','19','24') AND press_local_time < to_date(20171220, 'yyyymmdd'))
    OR (device_id IN ('14','23','20','25','26') AND press_local_time < to_date(20161212, 'yyyymmdd')
    OR (device_id IN ('13','17','18','21','22') AND press_local_time < to_date(20161221, 'yyyymmdd'))));


-- 0.05%
DROP TABLE data_loader;
CREATE TABLE data_loader AS (SELECT DISTINCT device_id, press_local_time, measurement_type_key, measurement 
from whitlocn.capstone_two_million
  WHERE (device_id IN ('11', '12','15','16','19','24') AND press_local_time >= to_date(20171220, 'yyyymmdd'))
    OR (device_id IN ('14','23','20','25','26') AND press_local_time >= to_date(20161212, 'yyyymmdd')
    OR (device_id IN ('13','17','18','21','22') AND press_local_time >= to_date(20161221, 'yyyymmdd'))));

--------------------------------------------------------------------------------
-- Heap table experiment
--------------------------------------------------------------------------------
INSERT /*+ PARALLEL(8) */
  INTO dr_part_id_1_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_id_1_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_id_1_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;
--------------------------------------------------------------------------------
-- Primary key experiment
--------------------------------------------------------------------------------
ALTER TABLE dr_part_id_1_interval DROP CONSTRAINT p_key;
ALTER TABLE dr_part_id_1_interval ADD CONSTRAINT p_key PRIMARY KEY(device_id, press_local_time,  measurement_type_key, measurement);

INSERT /*+ PARALLEL(8) */
  INTO dr_part_id_1_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_id_1_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_id_1_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER TABLE dr_part_id_1_interval DROP CONSTRAINT p_key;
--------------------------------------------------------------------------------
-- Unique index experiment
--------------------------------------------------------------------------------
DROP INDEX unique_index;
CREATE UNIQUE INDEX unique_index ON dr_part_id_1_interval(device_id, press_local_time,  measurement_type_key, measurement);

INSERT /*+ PARALLEL(8) */
  INTO dr_part_id_1_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_id_1_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_id_1_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;  
  
DROP INDEX unique_index;
--------------------------------------------------------------------------------
-- Nonunique index experiment
--------------------------------------------------------------------------------
DROP INDEX nonunique_index;
CREATE INDEX nonunique_index ON dr_part_id_1_interval(device_id, press_local_time,  measurement_type_key, measurement);

INSERT /*+ PARALLEL(8) */
  INTO dr_part_id_1_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_id_1_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_id_1_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;
  
DROP INDEX nonunique_index;
DROP TABLE dr_part_id_1_interval;