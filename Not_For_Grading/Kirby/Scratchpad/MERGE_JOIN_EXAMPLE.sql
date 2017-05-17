--Generic Dynamic SQL to build a merge statement based on a table and a primary key index
WITH ON_CLAUSE AS

(
SELECT --On Clause for tables with a primary key
  CASE
    WHEN LAG(COLUMN_POSITION) OVER(PARTITION BY INDEX_OWNER, TABLE_NAME, INDEX_NAME ORDER BY COLUMN_POSITION) IS NULL THEN 'T.' || COLUMN_NAME || ' = D.' || COLUMN_NAME 
    ELSE 'AND T.' || COLUMN_NAME || ' = D.' || COLUMN_NAME 
  END AS ON_CLAUSE
FROM ALL_IND_COLUMNS 
WHERE TABLE_OWNER = :OWNER
AND INDEX_NAME = 
(SELECT
  INDEX_NAME
FROM ALL_CONSTRAINTS
WHERE OWNER = :OWNER
AND TABLE_NAME = :TABLE_NAME
AND CONSTRAINT_TYPE = 'P')
ORDER BY
  COLUMN_POSITION
),

T_COLUMNS AS

(
SELECT --When Not Matched Then Insert
  CASE
    WHEN LEAD(COLUMN_ID) OVER(PARTITION BY OWNER, TABLE_NAME ORDER BY COLUMN_ID) IS NULL THEN 'T.' || COLUMN_NAME 
    ELSE 'T.' || COLUMN_NAME || ','
  END AS T_COLUMNS
FROM ALL_TAB_COLUMNS
WHERE TABLE_NAME = :TABLE_NAME
AND OWNER = :OWNER
ORDER BY
  COLUMN_ID
),

D_COLUMNS AS

(
SELECT --When Not Matched Then Insert
  CASE
    WHEN LEAD(COLUMN_ID) OVER(PARTITION BY OWNER, TABLE_NAME ORDER BY COLUMN_ID) IS NULL THEN 'D.' || COLUMN_NAME 
    ELSE 'D.' || COLUMN_NAME || ','
  END AS T_COLUMNS
FROM ALL_TAB_COLUMNS
WHERE TABLE_NAME = :TABLE_NAME
AND OWNER = :OWNER
ORDER BY
  COLUMN_ID
),

UPDATE_CLAUSE AS

(
SELECT --When Matched Then Update
  CASE
    WHEN LEAD(COLUMN_ID) OVER(PARTITION BY OWNER, TABLE_NAME ORDER BY COLUMN_ID) IS NULL THEN 'T.' || COLUMN_NAME || ' = D.' || COLUMN_NAME || ';' 
    ELSE 'T.' || COLUMN_NAME || ' = D.' || COLUMN_NAME || ','
  END AS T_EQUAL_D
FROM ALL_TAB_COLUMNS
WHERE TABLE_NAME = :TABLE_NAME
AND OWNER = :OWNER
AND COLUMN_NAME NOT IN (SELECT COLUMN_NAME FROM ALL_IND_COLUMNS WHERE INDEX_NAME = (SELECT INDEX_NAME FROM ALL_CONSTRAINTS WHERE OWNER = :OWNER AND TABLE_NAME = :TABLE_NAME AND CONSTRAINT_TYPE = 'P'))
ORDER BY
  COLUMN_ID
)

SELECT 'PROCEDURE ' || :TABLE_NAME || '_MERGE(FROMDATEPART NUMBER,TODATEPART NUMBER) AS' AS MERGE_JOIN FROM DUAL  UNION ALL
SELECT NULL FROM DUAL                                                                                             UNION ALL
SELECT 'BEGIN' FROM DUAL                                                                                          UNION ALL
SELECT NULL FROM DUAL                                                                                             UNION ALL
SELECT 'MERGE INTO ' || :OWNER || '.' || :TABLE_NAME || ' T USING' AS MERGE_STATEMENT FROM DUAL                   UNION ALL
SELECT NULL FROM DUAL                                                                                             UNION ALL 
SELECT '(' FROM DUAL                                                                                              UNION ALL
SELECT 'AND INS_DATE_PART BETWEEN FROMDATEPART AND TODATEPART' FROM DUAL                                          UNION ALL
SELECT ') D' FROM DUAL                                                                                            UNION ALL
SELECT NULL FROM DUAL                                                                                             UNION ALL 
SELECT 'ON' FROM DUAL                                                                                             UNION ALL
SELECT NULL FROM DUAL                                                                                             UNION ALL 
SELECT '(' FROM DUAL                                                                                              UNION ALL
SELECT * FROM ON_CLAUSE                                                                                           UNION ALL
SELECT ')' FROM DUAL                                                                                              UNION ALL
SELECT NULL FROM DUAL                                                                                             UNION ALL
SELECT 'WHEN NOT MATCHED THEN INSERT' FROM DUAL                                                                   UNION ALL
SELECT NULL FROM DUAL                                                                                             UNION ALL
SELECT '(' FROM DUAL                                                                                              UNION ALL
SELECT * FROM T_COLUMNS                                                                                           UNION ALL
SELECT ')' FROM DUAL                                                                                              UNION ALL
SELECT NULL FROM DUAL                                                                                             UNION ALL
SELECT 'VALUES' FROM DUAL                                                                                         UNION ALL
SELECT NULL FROM DUAL                                                                                             UNION ALL
SELECT '(' FROM DUAL                                                                                              UNION ALL
SELECT * FROM D_COLUMNS                                                                                           UNION ALL
SELECT ')' FROM DUAL                                                                                              UNION ALL
SELECT NULL FROM DUAL                                                                                             UNION ALL
SELECT 'WHEN MATCHED THEN UPDATE SET' FROM DUAL                                                                   UNION ALL
SELECT NULL FROM DUAL                                                                                             UNION ALL
SELECT * FROM UPDATE_CLAUSE                                                                                       UNION ALL
SELECT NULL FROM DUAL                                                                                             UNION ALL
SELECT 'COMMIT;' AS FROM DUAL                                                                                     UNION ALL
SELECT NULL FROM DUAL                                                                                             UNION ALL
SELECT 'END ' ||   :TABLE_NAME || '_MERGE;' AS FROM DUAL;

  
MERGE INTO OWNER.TABLE_NAME T USING

(
SELECT STATEMENT
) D

ON 

(
T.COLUMN_NAME = D.COLUMN_NAME
)
  
WHEN NOT MATCHED THEN INSERT

(
T.COLUMN_NAME
)

VALUES

(
D.COLUMN_NAME
)

WHEN MATCHED THEN UPDATE SET 

T.COLUMN_NAME = D.COLUMN_NAME;

COMMIT;