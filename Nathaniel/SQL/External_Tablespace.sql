------------------------------------------------------------------------------
--Create directories and grant permissions
------------------------------------------------------------------------------
--sqlplus sys@dbcap as sysdba
--Create directory from SQL
DROP DIRECTORY trace_dir;
CREATE DIRECTORY trace_dir AS '/u01/app/oracle/diag/rdbms/capstone/capstone/trace';

--Grant read and write privileges on new directory
--Cannot grant to yourself
GRANT READ, WRITE ON DIRECTORY trace_dir TO whitlocn;

--Create executable directory for preprocessor scripts
DROP DIRECTORY bin_dir;
CREATE DIRECTORY bin_dir AS '/u01/app/oracle/bin_dir';

--Grant executable pcrivileges
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
    PREPROCESSOR bin_dir: 'tkprof.sh'
    FIELDS TERMINATED BY WHITESPACE
    (
      line RECNUM,
      text POSITION(1:4000)
    )
  )
  LOCATION('')
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

--Get Recent Trace Name
SELECT REGEXP_SUBSTR(value, 'T([A-Z]+)-\d+') AS trace_file
FROM   v$diag_info
WHERE  name = 'Default Trace File';

--Set external tablespace to tracefile
ALTER TABLE tkprof_xt LOCATION('test.sess');

--Read tkprof output for single tracefile
SELECT text
FROM tkprof_xt;









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