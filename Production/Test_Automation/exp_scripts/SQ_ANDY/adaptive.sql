ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER SYSTEM SET PARALLEL_DEGREE_POLICY = ADAPTIVE ;
ALTER SESSION SET CONTAINER = DBCAP;
ALTER SYSTEM SET PARALLEL_DEGREE_POLICY = ADAPTIVE ;
exit;
