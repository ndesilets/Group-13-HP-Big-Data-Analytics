alter session set tracefile_identifier='TEST-10053'; 

  alter session set timed_statistics = true;
  alter session set statistics_level=all;
  alter session set max_dump_file_size = unlimited;

  --alter session set events '10046 trace name context forever,level 12';
  
  alter session set events '10053 trace name context forever,level 12';
  
  --ALTER SESSION SET EVENTS '10390 trace name context forever, level 0x2000';
  
  --ALTER SESSION SET EVENTS '10391 trace name context forever, level 1';
  
  --ALTER SESSION SET EVENTS '10393 trace name context forever, level 1';

  -- Execute the queries or operations to be traced here --
  
  select /*+ PARALLEL(16) FIND_ME_124 */ device_id, avg(measurement), sum(measurement)
  from CAPSTONE_DEMO.CAPSTONE_PARALLEL_TEST_V1
  group by device_id
  order by device_id;
  
   
  alter session set events '10053 trace name context off';
  
