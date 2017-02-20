alter session set container = dbcap;

EXECUTE CAPSTONE_DEMO.RESOURCE_MONITOR.PARAMETERS_HISTORY_INSERT;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'IMCS_EXPERIMENT',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'IN-MEMORY populating');
END;
/

DECLARE
    populated boolean := false;
    completed number := 0;
BEGIN
    WHILE populated != true
    LOOP
        SELECT
            COUNT(*)
        INTO
            completed
        FROM V$IM_SEGMENTS
        WHERE POPULATE_STATUS = 'COMPLETED';

        IF completed = 4 THEN
            populated := true;
        END IF;

        DBMS_LOCK.SLEEP(SECONDS => 30);
    END LOOP;
END;
/

