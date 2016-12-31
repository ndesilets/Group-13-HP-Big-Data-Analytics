------------------------------------------------------------------------------
--Create directories and grant permissions
------------------------------------------------------------------------------

--Create directory from SQL
DROP DIRECTORY trace_dir;
CREATE DIRECTORY trace_dir AS '/u01/app/oracle/diag/rdbms/capstone/capstone/trace';

--Grant read and write privileges on new directory
--Cannot grant to yourself
GRANT READ, WRITE ON DIRECTORY trace_dir TO whitlocn;

--Create executable directory for preprocessor scripts
DROP DIRECTORY bin_dir;
CREATE DIRECTORY bin_dir AS '/u01/app/oracle/bin_dir';

--Grant executable privileges
GRANT EXECUTE ON DIRECTORY bin_dir TO whitlocn;

------------------------------------------------------------------------------
--Generate and read tkprof reports
------------------------------------------------------------------------------
DROP TABLE tkprof_xt;

CREATE TABLE tkprof_xt
(
  line NUMBER,
  text VARCHAR2(4000)
)
ORGANIZATION EXTERNAL
(
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY trace_dir
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE
    NOLOGFILE
    PREPROCESSOR bin_dir: 'runTrcSum.sh'
    FIELDS TERMINATED BY WHITESPACE
    (
      line RECNUM,
      text POSITION(1:4000)
    )
  )
  LOCATION('%')
)
REJECT LIMIT UNLIMITED;

------------------------------------------------------------------------------
--Test external table
------------------------------------------------------------------------------
ALTER SESSION SET tracefile_identifier='TEST-10046';

ALTER SESSION SET EVENTS '10046 trace name context forever, level 12';

SELECT * FROM CAPSTONE_DEMO.CAPSTONE_PARALLEL_TEST_V1 ORDER BY PRESS_LOCAL_TIME DESC;

ALTER SESSION SET EVENTS '10046 trace name context off';

--Get trace filename
SELECT REGEXP_SUBSTR(value, '[^/]+$') AS trace_file
FROM   v$diag_info
WHERE  name = 'Default Trace File';

--Set external tablespace to tracefile
ALTER TABLE tkprof_xt LOCATION('capstone_ora_15458_TEST-10046.trc');

--Read tkprof output for single tracefile
SELECT *
FROM tkprof_xt;

--Problem is possibly due to permissions issue for my user.
--I cannot grant permission to myself, I attempted to log
--into the server as sys in order to grant myself permissions.
--Though the query completed, I am not sure it worked.

--I have tried to login to sqlplus as sysdba and grant myself
--permissions but I get an error message saying my user does not
--exist. This sounds like a container issue, do you have any
--insight?








--Attempt at subquery structure
WITH FINDING_TRACE AS
(
  --Get trace filename
  SELECT REGEXP_SUBSTR(value, '[^/]+$') AS trace_file
  FROM   v$diag_info
  WHERE  name = 'Default Trace File';
),
--Set external tablespace to tracefile
ALTER TABLE tkprof_xt LOCATION(FINDING_TRACE);