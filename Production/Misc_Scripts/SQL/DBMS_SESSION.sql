EXEC DBMS_SESSION.set_sql_trace(sql_trace => TRUE);
  
--Andy's Query
select count(*) from (
  select  
          /*+ PARALLEL(32) */
          device_id, 
          measurement_type_key, 
          press_local_time,
          avg(measurement) over (partition by device_id, measurement_type_key order by device_id, measurement_type_key)
    from CAPSTONE_DEMO.CAPSTONE_PARALLEL_TEST_V1 
order by press_local_time desc);

EXEC DBMS_SESSION.set_sql_trace(sql_trace => TRUE);