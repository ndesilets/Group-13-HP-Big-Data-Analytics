--Create new temp tablespace
CREATE TEMPORARY TABLESPACE tempramdisk_noGrowth 
TEMPFILE '/mnt/ramdisk/tempramdisk1_01.dbf' 
SIZE 10240M;
-- REUSE AUTOEXTEND ON NEXT 28 MAXSIZE unlimited

--Set new tablespace
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE tempramdisk_noGrowth;

--Andy's Query
select count(*) from (
  select  
          /* FIND_ME_EXP */
          device_id, 
          measurement_type_key, 
          press_local_time,
          avg(measurement) over (partition by device_id, measurement_type_key order by device_id, measurement_type_key)
    from CAPSTONE_DEMO.CAPSTONE_PARALLEL_TEST_V1 
order by press_local_time desc)


--Utilities
--View that shows who is using tempspace
select *
from V$SORT_USAGE

--View that shows the memory allocated to tempspacee
select *
from V$SORT_SEGMENT

--Find default permanent tablespace
SELECT PROPERTY_VALUE
FROM DATABASE_PROPERTIES
WHERE PROPERTY_NAME = 'DEFAULT_PERMANENT_TABLESPACE';

--Find default temp tablespace
SELECT PROPERTY_VALUE
FROM DATABASE_PROPERTIES
WHERE PROPERTY_NAME = 'DEFAULT_TEMP_TABLESPACE';

--Both in one query
SELECT PROPERTY_NAME, PROPERTY_VALUE
FROM DATABASE_PROPERTIES
WHERE PROPERTY_NAME IN ('DEFAULT_PERMANENT_TABLESPACE','DEFAULT_TEMP_TABLESPACE');

--Set temp tablespace back to default
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE temp;

--Drop experimental tablespace
DROP TABLESPACE tempramdisk_noGrowth INCLUDING CONTENTS AND DATAFILES;
