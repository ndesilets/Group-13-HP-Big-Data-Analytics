--This is a procedure to modify the location variable within an
--external table, this variable points at the target flatfile.

DECLARE 
statement VARCHAR2(1000);
traceFile VARCHAR2(100);
BEGIN
  SELECT REGEXP_SUBSTR(value, '[^/]+$') into traceFile
  FROM   V$DIAG_INFO
  WHERE  name = 'Default Trace File';
  statement := 'ALTER TABLE ' || '&1' || ' LOCATION(''' || traceFile || ''')';
  DBMS_OUTPUT.PUT_LINE('Statement is: ' || statement);
  EXECUTE IMMEDIATE(statement); 
END;