ALTER SESSION SET DB_FILE_MULTIBLOCK_READ_COUNT=32;
ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2147483647;
ALTER SESSION SET HASH_AREA_SIZE = 2147483647;
ALTER SESSION ENABLE PARALLEL DML;
ALTER SESSION SET CONTAINER = dbcap;
-- Set up table
DROP TABLE dr_part_date_day_interval;

CREATE TABLE  dr_part_date_day_interval
PARTITION BY RANGE (press_local_time) 
  INTERVAL (numtodsinterval(1,'DAY')) 
  (PARTITION part_01 VALUES LESS THAN (to_date('01/02/2007', 'MM/DD/YYYY'))) 
AS (SELECT DISTINCT device_id, press_local_time, measurement_type_key, measurement 
  FROM whitlocn.capstone_two_billion 
  WHERE (device_id IN ('11', '12','15','16','19','24') AND press_local_time < to_date(20171220, 'yyyymmdd'))
    OR (device_id IN ('14','23','20','25','26') AND press_local_time < to_date(20161212, 'yyyymmdd')
    OR (device_id IN ('13','17','18','21','22') AND press_local_time < to_date(20161221, 'yyyymmdd'))));

--------------------------------------------------------------------------------
-- DL with only new values
--------------------------------------------------------------------------------
-- 0.05% of DR
DROP TABLE data_loader;
CREATE TABLE data_loader AS (SELECT DISTINCT device_id, press_local_time, measurement_type_key, measurement 
FROM whitlocn.capstone_two_billion
  WHERE (device_id IN ('11', '12','15','16','19','24') AND press_local_time >= to_date(20171220, 'yyyymmdd'))
    OR (device_id IN ('14','23','20','25','26') AND press_local_time >= to_date(20161212, 'yyyymmdd')
    OR (device_id IN ('13','17','18','21','22') AND press_local_time >= to_date(20161221, 'yyyymmdd'))));
    
--------------------------------------------------------------------------------
-- Heap table experiment
--------------------------------------------------------------------------------
EXECUTE CAPSTONE_DEMO.RESOURCE_MONITOR.PARAMETERS_HISTORY_INSERT;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_DAY_NEW_DATA',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'HEAP_TABLE');
END;
/

INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

-- GLOBAL INDEX EXPERIMENTS
--------------------------------------------------------------------------------
-- Primary key experiment (Prefix)
--------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'PRIMARY_KEY_PREFIX');
END;
/

ALTER TABLE dr_part_date_day_interval DROP CONSTRAINT prefix_key;
ALTER TABLE dr_part_date_day_interval ADD CONSTRAINT prefix_key PRIMARY KEY(press_local_time,device_id, measurement_type_key, measurement);

INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;  

ALTER TABLE dr_part_date_day_interval DROP CONSTRAINT prefix_key;
----------------------------------------------------------------------------------
---- Primary key experiment (Non-prefix)
----------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'PRIMARY_KEY_NONPREFIX');
END;
/

ALTER TABLE dr_part_date_day_interval DROP CONSTRAINT non_prefix_key;
ALTER TABLE dr_part_date_day_interval ADD CONSTRAINT non_prefix_key PRIMARY KEY(device_id, press_local_time,  measurement_type_key, measurement);

INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;  

ALTER TABLE dr_part_date_day_interval DROP CONSTRAINT non_prefix_key;
----------------------------------------------------------------------------------
---- Unique index experiment (Prefix)
----------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'UNIQUE_INDEX_PREFIX');
END;
/

DROP INDEX unique_P_index;
CREATE UNIQUE INDEX unique_P_index ON dr_part_date_day_interval(press_local_time,device_id, measurement_type_key, measurement);

INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
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
CREATE UNIQUE INDEX unique_NP_index ON dr_part_date_day_interval(device_id, press_local_time,  measurement_type_key, measurement);

INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
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
CREATE INDEX nonunique_P_index ON dr_part_date_day_interval(press_local_time, device_id, measurement_type_key, measurement);

INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
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
CREATE INDEX nonunique_NP_index ON dr_part_date_day_interval(device_id, press_local_time,  measurement_type_key, measurement);

INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
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
CREATE UNIQUE INDEX local_prefix_unique ON dr_part_date_day_interval(press_local_time, device_id, measurement_type_key, measurement) LOCAL;

INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
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

DROP INDEX local_nonprefix_unique;
CREATE UNIQUE INDEX local_nonprefix_unique ON dr_part_date_day_interval(device_id, press_local_time, measurement_type_key, measurement) LOCAL;

INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

DROP INDEX local_nonprefix_unique;

--------------------------------------------------------------------------------
-- Non-unique index (Prefix)
--------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'LOCAL_NONUNIQUE_PREFIX');
END;
/

DROP INDEX local_prefix_nonunique;
CREATE INDEX local_prefix_nonunique ON dr_part_date_day_interval(press_local_time, device_id, measurement_type_key, measurement) LOCAL;

INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
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
CREATE INDEX local_nonprefix_nonunique ON dr_part_date_day_interval(device_id, press_local_time, measurement_type_key, measurement) LOCAL;

INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

ALTER SYSTEM FLUSH SHARED_POOL;
INSERT /*+ PARALLEL(8) */
  INTO dr_part_date_day_interval (device_id, press_local_time, measurement_type_key, measurement) 
  (SELECT device_id, press_local_time, measurement_type_key, measurement FROM data_loader);
ROLLBACK;

DROP INDEX local_nonprefix_nonunique;
