------------------------------------------------------------------------------
--Setup external table
------------------------------------------------------------------------------
DROP TABLE ten053_xt;

CREATE TABLE ten053_xt
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
    FIELDS TERMINATED BY WHITESPACE
    (
      line RECNUM,
      text POSITION(1:4000)
    )
  )
  LOCATION('')
)
REJECT LIMIT UNLIMITED;

--Call procedure to look for recent
--tracefile to set as LOCATION
--CONSIDER GENERALIZING TABLENAME
--AS ARGUMENT
@Alter_XT 'ten053_xt'

--Read tkprof output for single tracefile
SELECT *
FROM ten053_xt;