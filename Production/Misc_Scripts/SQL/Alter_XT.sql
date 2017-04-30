--This is a procedure to modify the location variable within an
--external table, this variable points at the target flatfile.
CREATE OR REPLACE PROCEDURE Alter_ExtTab(tableName IN CHARACTER)
IS
  statement VARCHAR2(1000);
  traceFile VARCHAR2(100);
BEGIN
  SELECT REGEXP_SUBSTR(value, '[^/]+$') into traceFile
  FROM   V$DIAG_INFO
  WHERE  name = 'Default Trace File';
  statement := 'ALTER TABLE ' || tableName || ' LOCATION(''' || traceFile || ''')';
  DBMS_OUTPUT.PUT_LINE('Statement is: ' || statement);
  EXECUTE IMMEDIATE(statement); 
END Alter_ExtTab;
/