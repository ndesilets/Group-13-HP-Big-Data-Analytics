alter session set tracefile_identifier='TEST-10053'; 

  alter session set timed_statistics = true;
  alter session set statistics_level=all;
  alter session set max_dump_file_size = unlimited;


  --alter session set events '10046 trace name context forever,level 12';
  
  alter session set events '10053 trace name context forever,level 1';
  
  --ALTER SESSION SET EVENTS '10390 trace name context forever, level 12';
  
  --ALTER SESSION SET EVENTS '10391 trace name context forever, level 12';
  
  --ALTER SESSION SET EVENTS '10393 trace name context forever, level 1';

  -- Execute the queries or operations to be traced here --
  
  --EXEC DBMS_SESSION.set_sql_trace(sql_trace => TRUE);

 --select count(*) from (
 -- select /*+ PARALLEL(16) MONITOR */ device_id, avg(measurement), sum(measurement)
 -- from CAPSTONE_DEMO.CAPSTONE_PARALLEL_TEST_V1
 -- group by device_id
 -- order by device_id);
  
  --Andy's Query
select count(*) from (
  select  
          /*+ MONITOR PARALLEL(16) */
          device_id, 
          measurement_type_key, 
          press_local_time,
          avg(measurement) over (partition by device_id, measurement_type_key order by device_id, measurement_type_key),
          sum(measurement) over (partition by device_id, measurement_type_key order by device_id, measurement_type_key)
    from CAPSTONE_DEMO.CAPSTONE_PARALLEL_TEST_V1 
order by press_local_time);

 --EXEC DBMS_SESSION.set_sql_trace(sql_trace => TRUE);
alter session set events '10053 trace name context off';

---------------------------------------------------------------------------------------------
--Suggested views to check
---------------------------------------------------------------------------------------------
--SELECT VALUE FROM V$DIAG_INFO WHERE NAME = 'Default Trace File';

--SELECT VALUE FROM V$DIAG_INFO WHERE NAME = 'Diag Enabled';
