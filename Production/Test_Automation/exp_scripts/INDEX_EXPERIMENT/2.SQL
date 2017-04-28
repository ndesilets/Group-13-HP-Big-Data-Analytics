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
-- No-Index table experiment
--------------------------------------------------------------------------------
EXECUTE CAPSTONE_DEMO.RESOURCE_MONITOR.PARAMETERS_HISTORY_INSERT;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_ID_NEW_DATA_NOI',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD QUERY');
END;
/

@"/home/oracle/Group-13-HP-Big-Data-Analytics/Production/Test_Automation/exp_scripts/INDEX_EXPERIMENT/index_tests/Tests_NUI.sql" dr_part_id_1_interval

-- GLOBAL INDEX EXPERIMENTS
--------------------------------------------------------------------------------
-- Primary key experiment (Non-prefix)
--------------------------------------------------------------------------------
ALTER TABLE dr_part_id_1_interval DROP CONSTRAINT non_prefix_key;
ALTER TABLE dr_part_id_1_interval ADD CONSTRAINT non_prefix_key PRIMARY KEY(press_local_time,device_id, measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_ID_NEW_DATA_PK_NP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD QUERY');
END;
/

@"/home/oracle/Group-13-HP-Big-Data-Analytics/Production/Test_Automation/exp_scripts/INDEX_EXPERIMENT/index_tests/Tests_Date_Pre_UI.sql" dr_part_id_1_interval

ALTER TABLE dr_part_id_1_interval DROP CONSTRAINT non_prefix_key;
----------------------------------------------------------------------------------
---- Primary key experiment (Prefix)
----------------------------------------------------------------------------------
ALTER TABLE dr_part_id_1_interval DROP CONSTRAINT prefix_key;
ALTER TABLE dr_part_id_1_interval ADD CONSTRAINT prefix_key PRIMARY KEY(device_id, press_local_time,  measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_ID_NEW_DATA_PK_P',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD QUERY');
END;
/

@"/home/oracle/Group-13-HP-Big-Data-Analytics/Production/Test_Automation/exp_scripts/INDEX_EXPERIMENT/index_tests/Tests_ID_Pre_UI.sql" dr_part_id_1_interval

ALTER TABLE dr_part_id_1_interval DROP CONSTRAINT prefix_key;
----------------------------------------------------------------------------------
---- Unique index experiment (Non-prefix)
----------------------------------------------------------------------------------
DROP INDEX unique_NP_index;
CREATE UNIQUE INDEX unique_NP_index ON dr_part_id_1_interval(press_local_time,device_id, measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_ID_NEW_DATA_UI_NP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD QUERY');
END;
/

@"/home/oracle/Group-13-HP-Big-Data-Analytics/Production/Test_Automation/exp_scripts/INDEX_EXPERIMENT/index_tests/Tests_Date_Pre_UI.sql" dr_part_id_1_interval

DROP INDEX unique_NP_index;
----------------------------------------------------------------------------------
---- Unique index experiment (Prefix)
----------------------------------------------------------------------------------
DROP INDEX unique_P_index;
CREATE UNIQUE INDEX unique_P_index ON dr_part_id_1_interval(device_id, press_local_time,  measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_ID_NEW_DATA_UI_P',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD QUERY');
END;
/

@"/home/oracle/Group-13-HP-Big-Data-Analytics/Production/Test_Automation/exp_scripts/INDEX_EXPERIMENT/index_tests/Tests_ID_Pre_UI.sql" dr_part_id_1_interval

DROP INDEX unique_P_index;
--------------------------------------------------------------------------------
-- Nonunique index experiment (Non-Prefix)
--------------------------------------------------------------------------------
DROP INDEX nonunique_NP_index;
CREATE INDEX nonunique_NP_index ON dr_part_id_1_interval(press_local_time, device_id, measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_ID_NEW_DATA_NUI_NP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD QUERY');
END;
/

@"/home/oracle/Group-13-HP-Big-Data-Analytics/Production/Test_Automation/exp_scripts/INDEX_EXPERIMENT/index_tests/Tests_NUI.sql" dr_part_id_1_interval

DROP INDEX nonunique_NP_index;
--------------------------------------------------------------------------------
-- Nonunique index experiment (Prefix)
--------------------------------------------------------------------------------
DROP INDEX nonunique_P_index;
CREATE INDEX nonunique_P_index ON dr_part_id_1_interval(device_id, press_local_time,  measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_ID_NEW_DATA_NUI_P',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD QUERY');
END;
/

@"/home/oracle/Group-13-HP-Big-Data-Analytics/Production/Test_Automation/exp_scripts/INDEX_EXPERIMENT/index_tests/Tests_NUI.sql" dr_part_id_1_interval

DROP INDEX nonunique_P_index;

-- LOCAL INDEX EXPERIMENTS
--------------------------------------------------------------------------------
-- Unique index (Non-prefix)
--------------------------------------------------------------------------------
DROP INDEX local_NP_unique;
CREATE UNIQUE INDEX local_prefix_unique ON dr_part_id_1_interval(press_local_time, device_id, measurement_type_key, measurement) LOCAL;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_ID_NEW_DATA_LUI_NP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD QUERY');
END;
/

@"/home/oracle/Group-13-HP-Big-Data-Analytics/Production/Test_Automation/exp_scripts/INDEX_EXPERIMENT/index_tests/Tests_Date_Pre_UI.sql" dr_part_id_1_interval

DROP INDEX local_NP_unique;
--------------------------------------------------------------------------------
-- Unique index (Prefix)
--------------------------------------------------------------------------------
DROP INDEX local_P_unique;
CREATE UNIQUE INDEX local_P_unique ON dr_part_id_1_interval(device_id, press_local_time, measurement_type_key, measurement) LOCAL;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_ID_NEW_DATA_LUI_P',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD QUERY');
END;
/

@"/home/oracle/Group-13-HP-Big-Data-Analytics/Production/Test_Automation/exp_scripts/INDEX_EXPERIMENT/index_tests/Tests_ID_Pre_UI.sql" dr_part_id_1_interval

DROP INDEX local_P_unique;

--------------------------------------------------------------------------------
-- Non-unique index (Non-Prefix)
--------------------------------------------------------------------------------
DROP INDEX local_NP_nonunique;
CREATE INDEX local_NP_nonunique ON dr_part_id_1_interval(press_local_time, device_id, measurement_type_key, measurement) LOCAL;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_ID_NEW_DATA_LNUI_NP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD QUERY');
END;
/

@"/home/oracle/Group-13-HP-Big-Data-Analytics/Production/Test_Automation/exp_scripts/INDEX_EXPERIMENT/index_tests/Tests_NUI.sql" dr_part_id_1_interval

DROP INDEX local_NP_nonunique;
--------------------------------------------------------------------------------
-- Non-unqiue index (Prefix)
--------------------------------------------------------------------------------
DROP INDEX local_P_nonunique;
CREATE INDEX local_P_nonunique ON dr_part_id_1_interval(device_id, press_local_time, measurement_type_key, measurement) LOCAL;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_ID_NEW_DATA_LNUI_P',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD QUERY');
END;
/

@"/home/oracle/Group-13-HP-Big-Data-Analytics/Production/Test_Automation/exp_scripts/INDEX_EXPERIMENT/index_tests/Tests_NUI.sql" dr_part_id_1_interval

DROP INDEX local_P_nonunique;

DROP TABLE dr_part_id_1_interval;