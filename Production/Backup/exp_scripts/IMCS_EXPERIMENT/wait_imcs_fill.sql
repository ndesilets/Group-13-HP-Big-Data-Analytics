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