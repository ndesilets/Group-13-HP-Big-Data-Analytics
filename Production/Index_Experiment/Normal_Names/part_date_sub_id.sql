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
  FROM whitlocn.capstone_two_billion
  WHERE (device_id IN ('11', '12','15','16','19','24') AND press_local_time < to_date(20171220, 'yyyymmdd'))
    OR (device_id IN ('14','23','20','25','26') AND press_local_time < to_date(20161212, 'yyyymmdd')
    OR (device_id IN ('13','17','18','21','22') AND press_local_time < to_date(20161221, 'yyyymmdd'))));


-- 0.05%
DROP TABLE data_loader;
CREATE TABLE data_loader AS (SELECT DISTINCT device_id, press_local_time, measurement_type_key, measurement 
from whitlocn.capstone_two_billion
  WHERE (device_id IN ('11', '12','15','16','19','24') AND press_local_time >= to_date(20171220, 'yyyymmdd'))
    OR (device_id IN ('14','23','20','25','26') AND press_local_time >= to_date(20161212, 'yyyymmdd')
    OR (device_id IN ('13','17','18','21','22') AND press_local_time >= to_date(20161221, 'yyyymmdd'))));

--------------------------------------------------------------------------------
-- No-Index experiment
--------------------------------------------------------------------------------
EXECUTE CAPSTONE_DEMO.RESOURCE_MONITOR.PARAMETERS_HISTORY_INSERT;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'P_DATE_S_ID_NEW_DATA_NOI',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_NUI.sql dr_part_date_sub_id_16

-- GLOBAL INDEX EXPERIMENTS
--------------------------------------------------------------------------------
-- Primary key experiment (Prefix)
--------------------------------------------------------------------------------
ALTER TABLE dr_part_date_sub_id_16 DROP CONSTRAINT prefix_key;
ALTER TABLE dr_part_date_sub_id_16 ADD CONSTRAINT prefix_key PRIMARY KEY(press_local_time,device_id, measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  BMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'P_DATE_S_ID_NEW_DATA_PK_P',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_Date_Pre_UI.sql dr_part_date_sub_id_16

ALTER TABLE dr_part_date_sub_id_16 DROP CONSTRAINT prefix_key;
----------------------------------------------------------------------------------
---- Primary key experiment (Non-prefix)
----------------------------------------------------------------------------------
ALTER TABLE dr_part_date_sub_id_16 DROP CONSTRAINT non_prefix_key;
ALTER TABLE dr_part_date_sub_id_16 ADD CONSTRAINT non_prefix_key PRIMARY KEY(device_id, press_local_time,  measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  BMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'P_DATE_S_ID_NEW_DATA_PK_NP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_ID_Pre_UI.sql dr_part_date_sub_id_16

ALTER TABLE dr_part_date_sub_id_16 DROP CONSTRAINT non_prefix_key;
----------------------------------------------------------------------------------
---- Unique index experiment (Prefix)
----------------------------------------------------------------------------------
DROP INDEX unique_P_index;
CREATE UNIQUE INDEX unique_P_index ON dr_part_date_sub_id_16(press_local_time,device_id, measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  BMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'P_DATE_S_ID_NEW_DATA_UI_P',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_Date_Pre_UI.sql dr_part_date_sub_id_16

DROP INDEX unique_P_index;
----------------------------------------------------------------------------------
---- Unique index experiment (Non-prefix)
----------------------------------------------------------------------------------
DROP INDEX unique_NP_index;
CREATE UNIQUE INDEX unique_NP_index ON dr_part_date_sub_id_16(device_id, press_local_time,  measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  BMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'P_DATE_S_ID_NEW_DATA_UI_NP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_ID_Pre_UI.sql dr_part_date_sub_id_16

DROP INDEX unique_NP_index;
--------------------------------------------------------------------------------
-- Nonunique index experiment (Prefix)
--------------------------------------------------------------------------------
DROP INDEX nonunique_P_index;
CREATE INDEX nonunique_P_index ON dr_part_date_sub_id_16(press_local_time, device_id, measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  BMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'P_DATE_S_ID_NEW_DATA_NUI_P',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_NUI.sql dr_part_date_sub_id_16

DROP INDEX nonunique_P_index;
--------------------------------------------------------------------------------
-- Nonunique index experiment (Non-prefix)
--------------------------------------------------------------------------------
DROP INDEX nonunique_NP_index;
CREATE INDEX nonunique_NP_index ON dr_part_date_sub_id_16(device_id, press_local_time,  measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  BMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'P_DATE_S_ID_NEW_DATA_NUI_NP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_NUI.sql dr_part_date_sub_id_16

DROP INDEX nonunique_NP_index;

-- LOCAL INDEX EXPERIMENTS
--------------------------------------------------------------------------------
-- Unique index (Prefix)
--------------------------------------------------------------------------------
DROP INDEX local_prefix_unique;
CREATE UNIQUE INDEX local_prefix_unique ON dr_part_date_sub_id_16(press_local_time, device_id, measurement_type_key, measurement) LOCAL;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  BMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'P_DATE_S_ID_NEW_DATA_LUI_P',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_Date_Pre_UI.sql dr_part_date_sub_id_16

DROP INDEX local_prefix_unique;
--------------------------------------------------------------------------------
-- Unique index (Non-prefix)
--------------------------------------------------------------------------------
DROP INDEX local_nonprefix_unique;
CREATE UNIQUE INDEX local_nonprefix_unique ON dr_part_date_sub_id_16(device_id, press_local_time, measurement_type_key, measurement) LOCAL;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  BMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'P_DATE_S_ID_NEW_DATA_LUI_NP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_ID_Pre_UI.sql dr_part_date_sub_id_16

DROP INDEX local_nonprefix_unique;

--------------------------------------------------------------------------------
-- Non-unique index (Prefix)
--------------------------------------------------------------------------------
DROP INDEX local_prefix_nonunique;
CREATE INDEX local_prefix_nonunique ON dr_part_date_sub_id_16(press_local_time, device_id, measurement_type_key, measurement) LOCAL;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  BMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'P_DATE_S_ID_NEW_DATA_LNUI_P',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_NUI.sql dr_part_date_sub_id_16

DROP INDEX local_prefix_nonunique;
--------------------------------------------------------------------------------
-- Non-unqiue index (Non-prefix)
--------------------------------------------------------------------------------
DROP INDEX local_nonprefix_nonunique;
CREATE INDEX local_nonprefix_nonunique ON dr_part_date_sub_id_16(device_id, press_local_time, measurement_type_key, measurement) LOCAL;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  BMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'P_DATE_S_ID_NEW_DATA_LNUI_NP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_NUI.sql dr_part_date_sub_id_16

DROP INDEX local_nonprefix_nonunique;
