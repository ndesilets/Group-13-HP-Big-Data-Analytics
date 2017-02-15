alter session set container = dbcap;

EXECUTE CAPSTONE_DEMO.RESOURCE_MONITOR.PARAMETERS_HISTORY_INSERT;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'IMCS_EXPERIMENT',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'IN-MEMORY populating');
END;
/

declare 
 
 run_param varchar2(5 char) := 'TRUE';
 
begin

while run_param = 'TRUE'
loop
  DBMS_LOCK.SLEEP(SECONDS => 5);
  select status into run_param from capstone_demo.resource_monitor_Status;
end loop;

end;
/
