ALTER SESSION SET DB_FILE_MULTIBLOCK_READ_COUNT=32;
ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2147483647;
ALTER SESSION SET HASH_AREA_SIZE = 2147483647;   
ALTER SESSION ENABLE PARALLEL DML;

-- Set up table
DROP TABLE dr_part_id_sub_date_16; 

CREATE TABLE dr_part_id_sub_date_16
PARTITION BY range(DEVICE_ID)
INTERVAL (1)
SUBPARTITION BY range(PRESS_LOCAL_TIME)
SUBPARTITION TEMPLATE
  (
    SUBPARTITION PART1 VALUES LESS THAN (TO_DATE('1-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART2 VALUES LESS THAN (TO_DATE('2-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART3 VALUES LESS THAN (TO_DATE('3-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART4 VALUES LESS THAN (TO_DATE('4-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART5 VALUES LESS THAN (TO_DATE('5-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART6 VALUES LESS THAN (TO_DATE('6-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART7 VALUES LESS THAN (TO_DATE('7-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART8 VALUES LESS THAN (TO_DATE('8-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART9 VALUES LESS THAN (TO_DATE('9-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART10 VALUES LESS THAN (TO_DATE('10-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART11 VALUES LESS THAN (TO_DATE('11-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART12 VALUES LESS THAN (TO_DATE('12-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART13 VALUES LESS THAN (TO_DATE('13-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART14 VALUES LESS THAN (TO_DATE('14-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART15 VALUES LESS THAN (TO_DATE('15-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART16 VALUES LESS THAN (TO_DATE('16-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART17 VALUES LESS THAN (TO_DATE('17-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART18 VALUES LESS THAN (TO_DATE('18-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART19 VALUES LESS THAN (TO_DATE('19-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART20 VALUES LESS THAN (TO_DATE('20-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART21 VALUES LESS THAN (TO_DATE('21-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART22 VALUES LESS THAN (TO_DATE('22-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART23 VALUES LESS THAN (TO_DATE('23-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART24 VALUES LESS THAN (TO_DATE('24-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART25 VALUES LESS THAN (TO_DATE('25-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART26 VALUES LESS THAN (TO_DATE('26-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART27 VALUES LESS THAN (TO_DATE('27-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART28 VALUES LESS THAN (TO_DATE('28-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART29 VALUES LESS THAN (TO_DATE('29-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART30 VALUES LESS THAN (TO_DATE('30-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART31 VALUES LESS THAN (TO_DATE('31-7-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART32 VALUES LESS THAN (TO_DATE('1-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART33 VALUES LESS THAN (TO_DATE('2-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART34 VALUES LESS THAN (TO_DATE('3-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART35 VALUES LESS THAN (TO_DATE('4-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART36 VALUES LESS THAN (TO_DATE('5-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART37 VALUES LESS THAN (TO_DATE('6-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART38 VALUES LESS THAN (TO_DATE('7-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART39 VALUES LESS THAN (TO_DATE('8-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART40 VALUES LESS THAN (TO_DATE('9-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART41 VALUES LESS THAN (TO_DATE('10-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART42 VALUES LESS THAN (TO_DATE('11-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART43 VALUES LESS THAN (TO_DATE('12-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART44 VALUES LESS THAN (TO_DATE('13-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART45 VALUES LESS THAN (TO_DATE('14-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART46 VALUES LESS THAN (TO_DATE('15-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART47 VALUES LESS THAN (TO_DATE('16-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART48 VALUES LESS THAN (TO_DATE('17-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART49 VALUES LESS THAN (TO_DATE('18-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART50 VALUES LESS THAN (TO_DATE('19-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART51 VALUES LESS THAN (TO_DATE('20-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART52 VALUES LESS THAN (TO_DATE('21-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART53 VALUES LESS THAN (TO_DATE('22-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART54 VALUES LESS THAN (TO_DATE('23-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART55 VALUES LESS THAN (TO_DATE('24-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART56 VALUES LESS THAN (TO_DATE('25-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART57 VALUES LESS THAN (TO_DATE('26-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART58 VALUES LESS THAN (TO_DATE('27-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART59 VALUES LESS THAN (TO_DATE('28-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART60 VALUES LESS THAN (TO_DATE('29-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART61 VALUES LESS THAN (TO_DATE('30-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART62 VALUES LESS THAN (TO_DATE('31-8-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART63 VALUES LESS THAN (TO_DATE('1-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART64 VALUES LESS THAN (TO_DATE('2-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART65 VALUES LESS THAN (TO_DATE('3-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART66 VALUES LESS THAN (TO_DATE('4-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART67 VALUES LESS THAN (TO_DATE('5-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART68 VALUES LESS THAN (TO_DATE('6-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART69 VALUES LESS THAN (TO_DATE('7-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART70 VALUES LESS THAN (TO_DATE('8-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART71 VALUES LESS THAN (TO_DATE('9-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART72 VALUES LESS THAN (TO_DATE('10-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART73 VALUES LESS THAN (TO_DATE('11-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART74 VALUES LESS THAN (TO_DATE('12-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART75 VALUES LESS THAN (TO_DATE('13-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART76 VALUES LESS THAN (TO_DATE('14-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART77 VALUES LESS THAN (TO_DATE('15-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART78 VALUES LESS THAN (TO_DATE('16-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART79 VALUES LESS THAN (TO_DATE('17-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART80 VALUES LESS THAN (TO_DATE('18-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART81 VALUES LESS THAN (TO_DATE('19-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART82 VALUES LESS THAN (TO_DATE('20-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART83 VALUES LESS THAN (TO_DATE('21-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART84 VALUES LESS THAN (TO_DATE('22-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART85 VALUES LESS THAN (TO_DATE('23-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART86 VALUES LESS THAN (TO_DATE('24-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART87 VALUES LESS THAN (TO_DATE('25-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART88 VALUES LESS THAN (TO_DATE('26-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART89 VALUES LESS THAN (TO_DATE('27-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART90 VALUES LESS THAN (TO_DATE('28-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART91 VALUES LESS THAN (TO_DATE('29-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART92 VALUES LESS THAN (TO_DATE('30-9-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART93 VALUES LESS THAN (TO_DATE('1-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART94 VALUES LESS THAN (TO_DATE('2-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART95 VALUES LESS THAN (TO_DATE('3-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART96 VALUES LESS THAN (TO_DATE('4-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART97 VALUES LESS THAN (TO_DATE('5-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART98 VALUES LESS THAN (TO_DATE('6-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART99 VALUES LESS THAN (TO_DATE('7-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART100 VALUES LESS THAN (TO_DATE('8-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART101 VALUES LESS THAN (TO_DATE('9-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART102 VALUES LESS THAN (TO_DATE('10-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART103 VALUES LESS THAN (TO_DATE('11-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART104 VALUES LESS THAN (TO_DATE('12-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART105 VALUES LESS THAN (TO_DATE('13-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART106 VALUES LESS THAN (TO_DATE('14-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART107 VALUES LESS THAN (TO_DATE('15-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART108 VALUES LESS THAN (TO_DATE('16-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART109 VALUES LESS THAN (TO_DATE('17-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART110 VALUES LESS THAN (TO_DATE('18-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART111 VALUES LESS THAN (TO_DATE('19-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART112 VALUES LESS THAN (TO_DATE('20-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART113 VALUES LESS THAN (TO_DATE('21-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART114 VALUES LESS THAN (TO_DATE('22-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART115 VALUES LESS THAN (TO_DATE('23-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART116 VALUES LESS THAN (TO_DATE('24-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART117 VALUES LESS THAN (TO_DATE('25-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART118 VALUES LESS THAN (TO_DATE('26-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART119 VALUES LESS THAN (TO_DATE('27-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART120 VALUES LESS THAN (TO_DATE('28-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART121 VALUES LESS THAN (TO_DATE('29-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART122 VALUES LESS THAN (TO_DATE('30-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART123 VALUES LESS THAN (TO_DATE('31-10-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART124 VALUES LESS THAN (TO_DATE('1-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART125 VALUES LESS THAN (TO_DATE('2-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART126 VALUES LESS THAN (TO_DATE('3-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART127 VALUES LESS THAN (TO_DATE('4-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART128 VALUES LESS THAN (TO_DATE('5-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART129 VALUES LESS THAN (TO_DATE('6-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART130 VALUES LESS THAN (TO_DATE('7-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART131 VALUES LESS THAN (TO_DATE('8-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART132 VALUES LESS THAN (TO_DATE('9-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART133 VALUES LESS THAN (TO_DATE('10-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART134 VALUES LESS THAN (TO_DATE('11-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART135 VALUES LESS THAN (TO_DATE('12-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART136 VALUES LESS THAN (TO_DATE('13-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART137 VALUES LESS THAN (TO_DATE('14-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART138 VALUES LESS THAN (TO_DATE('15-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART139 VALUES LESS THAN (TO_DATE('16-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART140 VALUES LESS THAN (TO_DATE('17-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART141 VALUES LESS THAN (TO_DATE('18-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART142 VALUES LESS THAN (TO_DATE('19-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART143 VALUES LESS THAN (TO_DATE('20-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART144 VALUES LESS THAN (TO_DATE('21-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART145 VALUES LESS THAN (TO_DATE('22-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART146 VALUES LESS THAN (TO_DATE('23-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART147 VALUES LESS THAN (TO_DATE('24-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART148 VALUES LESS THAN (TO_DATE('25-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART149 VALUES LESS THAN (TO_DATE('26-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART150 VALUES LESS THAN (TO_DATE('27-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART151 VALUES LESS THAN (TO_DATE('28-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART152 VALUES LESS THAN (TO_DATE('29-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART153 VALUES LESS THAN (TO_DATE('30-11-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART154 VALUES LESS THAN (TO_DATE('1-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART155 VALUES LESS THAN (TO_DATE('2-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART156 VALUES LESS THAN (TO_DATE('3-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART157 VALUES LESS THAN (TO_DATE('4-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART158 VALUES LESS THAN (TO_DATE('5-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART159 VALUES LESS THAN (TO_DATE('6-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART160 VALUES LESS THAN (TO_DATE('7-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART161 VALUES LESS THAN (TO_DATE('8-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART162 VALUES LESS THAN (TO_DATE('9-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART163 VALUES LESS THAN (TO_DATE('10-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART164 VALUES LESS THAN (TO_DATE('11-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART165 VALUES LESS THAN (TO_DATE('12-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART166 VALUES LESS THAN (TO_DATE('13-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART167 VALUES LESS THAN (TO_DATE('14-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART168 VALUES LESS THAN (TO_DATE('15-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART169 VALUES LESS THAN (TO_DATE('16-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART170 VALUES LESS THAN (TO_DATE('17-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART171 VALUES LESS THAN (TO_DATE('18-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART172 VALUES LESS THAN (TO_DATE('19-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART173 VALUES LESS THAN (TO_DATE('20-12-2016', 'dd-mm-yyyy')),
    SUBPARTITION PART174 VALUES LESS THAN (TO_DATE('21-12-2016', 'dd-mm-yyyy'))
  )
(PARTITION part_01 VALUES LESS THAN (1))
AS (SELECT DISTINCT device_id, press_local_time, measurement_type_key, measurement 
  FROM whitlocn.capstone_two_billion
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
EXECUTE CAPSTONE_DEMO.RESOURCE_MONITOR.PARAMETERS_HISTORY_INSERT;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'P_ID_S_DATE_NEW_DATA',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'HEAP_TABLE');
END;
/

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

-- GLOBAL INDEX EXPERIMENTS
--------------------------------------------------------------------------------
-- Primary key experiment (Non-prefix)
--------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'PRIMARY_KEY_NONPREFIX');
END;
/

ALTER TABLE dr_part_id_1_interval DROP CONSTRAINT non_prefix_key;
ALTER TABLE dr_part_id_1_interval ADD CONSTRAINT non_prefix_key PRIMARY KEY(press_local_time,device_id, measurement_type_key, measurement);

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

ALTER TABLE dr_part_id_1_interval DROP CONSTRAINT non_prefix_key;
----------------------------------------------------------------------------------
---- Primary key experiment (Prefix)
----------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'PRIMARY_KEY_PREFIX');
END;
/

ALTER TABLE dr_part_id_1_interval DROP CONSTRAINT prefix_key;
ALTER TABLE dr_part_id_1_interval ADD CONSTRAINT prefix_key PRIMARY KEY(device_id, press_local_time,  measurement_type_key, measurement);

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

ALTER TABLE dr_part_id_1_interval DROP CONSTRAINT prefix_key;
----------------------------------------------------------------------------------
---- Unique index experiment (Non-prefix)
----------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'UNIQUE_INDEX_NONPREFIX');
END;
/

DROP INDEX unique_NP_index;
CREATE UNIQUE INDEX unique_NP_index ON dr_part_id_1_interval(press_local_time,device_id, measurement_type_key, measurement);

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

DROP INDEX unique_NP_index;
----------------------------------------------------------------------------------
---- Unique index experiment (Prefix)
----------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'UNIQUE_INDEX_PREFIX');
END;
/

DROP INDEX unique_P_index;
CREATE UNIQUE INDEX unique_P_index ON dr_part_id_1_interval(device_id, press_local_time,  measurement_type_key, measurement);

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

DROP INDEX unique_P_index;
--------------------------------------------------------------------------------
-- Nonunique index experiment (Non-Prefix)
--------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'NONUNIQUE_INDEX_NONPREFIX');
END;
/

DROP INDEX nonunique_NP_index;
CREATE INDEX nonunique_NP_index ON dr_part_id_1_interval(press_local_time, device_id, measurement_type_key, measurement);

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

DROP INDEX nonunique_NP_index;
--------------------------------------------------------------------------------
-- Nonunique index experiment (Prefix)
--------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'NONUNIQUE_INDEX_PREFIX');
END;
/

DROP INDEX nonunique_P_index;
CREATE INDEX nonunique_P_index ON dr_part_id_1_interval(device_id, press_local_time,  measurement_type_key, measurement);

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

DROP INDEX nonunique_P_index;

-- LOCAL INDEX EXPERIMENTS
--------------------------------------------------------------------------------
-- Unique index (Non-prefix)
--------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'LOCAL_UNIQUE_NONPREFIX');
END;
/

DROP INDEX local_NP_unique;
CREATE UNIQUE INDEX local_prefix_unique ON dr_part_id_1_interval(press_local_time, device_id, measurement_type_key, measurement) LOCAL;

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

DROP INDEX local_NP_unique;
--------------------------------------------------------------------------------
-- Unique index (Prefix)
--------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'LOCAL_UNIQUE_PREFIX');
END;
/

DROP INDEX local_P_unique;
CREATE UNIQUE INDEX local_P_unique ON dr_part_id_1_interval(device_id, press_local_time, measurement_type_key, measurement) LOCAL;

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

DROP INDEX local_P_unique;

--------------------------------------------------------------------------------
-- Non-unique index (Non-Prefix)
--------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'LOCAL_NONUNIQUE_NONPREFIX');
END;
/

DROP INDEX local_NP_nonunique;
CREATE INDEX local_NP_nonunique ON dr_part_id_1_interval(press_local_time, device_id, measurement_type_key, measurement) LOCAL;

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

DROP INDEX local_NP_nonunique;
--------------------------------------------------------------------------------
-- Non-unqiue index (Prefix)
--------------------------------------------------------------------------------
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'LOCAL_NONUNIQUE_PREFIX');
END;
/

DROP INDEX local_P_nonunique;
CREATE INDEX local_P_nonunique ON dr_part_id_1_interval(device_id, press_local_time, measurement_type_key, measurement) LOCAL;

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

DROP INDEX local_P_nonunique;