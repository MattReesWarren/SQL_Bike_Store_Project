-- NULL & DISTINCT Count --
-- a.--
SET SESSION group_concat_max_len = 1000000;

-- b. --
SELECT
  GROUP_CONCAT(
    CONCAT(
      'SELECT ',
        QUOTE(TABLE_NAME), ' AS tbl, ',
        QUOTE(COLUMN_NAME), ' AS col, ',
        'COUNT(*) - COUNT(`', COLUMN_NAME, '`) AS null_count, ',
        'COUNT(DISTINCT `', COLUMN_NAME, '`) AS distinct_count ',
      'FROM `', TABLE_SCHEMA, '`.`', TABLE_NAME, '`'
    )
    ORDER BY TABLE_NAME, ORDINAL_POSITION
    SEPARATOR ' UNION ALL '
  ) 
INTO @dynamic_sql
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'clean'
  AND IS_NULLABLE = 'YES';
  
-- c. --
PREPARE dyn_stmt FROM @dynamic_sql;
-- d. --
EXECUTE dyn_stmt;
-- d(1). remove --
DEALLOCATE PREPARE dyn_stmt;