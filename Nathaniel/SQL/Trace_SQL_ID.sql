alter session set tracefile_identifier='99999'; 

  alter session set timed_statistics = true;
  alter session set statistics_level=all;
  alter session set max_dump_file_size = unlimited;

 alter session set events 'sql_trace [sql:b3c9c04dk66p6] level 12';

  -- Execute the queries or operations to be traced here --
  select avg(measurement)
  from CAPSTONE_DEMO.CAPSTONE_PARALLEL_TEST_V1
  group by MEASUREMENT_TYPE_KEY;
  
  alter session set events 'sql_trace off';

  select * from dual;
  exit;