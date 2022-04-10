IF (OBJECT_ID('spGenSurrogateKey') IS NOT NULL)
    DROP PROCEDURE spGenSurrogateKey
GO

CREATE PROCEDURE spGenSurrogateKey(@TableName VARCHAR(63), @NewPKCol VARCHAR(63), @BaseOnCols VARCHAR(2000), @Delimiter CHAR(1) = ',')
AS
BEGIN
  IF (COL_LENGTH(@TableName, @NewPKCol) IS NOT NULL)
  BEGIN
    RAISERROR('The column has already defined!', 16, 1)
    RETURN
  END --if

  DECLARE @ENTER CHAR(2) = CHAR(13) + CHAR(10),
          @AliasLeft CHAR(1) = 'C',
          @AliasRight CHAR(1) = 'T',
          @Join VARCHAR(2000)

  SELECT @BaseOnCols = @Delimiter + @BaseOnCols + @Delimiter,
         @BaseOnCols = REPLACE(@BaseOnCols, @Delimiter + @Delimiter, ','),
         @BaseOnCols = LEFT(@BaseOnCols, LEN(@BaseOnCols) - 1),
         @BaseOnCols = RIGHT(@BaseOnCols, LEN(@BaseOnCols) - 1),
         @Join = @BaseOnCols
  EXEC spGenJoinText @Join OUT, @BaseOnCols, @Delimiter, @AliasLeft, 'T'

  EXEC('ALTER TABLE ' + @TableName + @ENTER +
       '        ADD ' + @NewPKCol + ' UNIQUEIDENTIFIER')
  EXEC('WITH CTE AS(' + @ENTER +
       'SELECT DISTINCT ' + @BaseOnCols + @ENTER +
       '  FROM ' + @TableName + @ENTER +
       ')' + @ENTER +
       'UPDATE ' + @AliasRight + @ENTER +
       '   SET ' + @AliasRight + '.' + @NewPKCol + ' = ' + @AliasLeft + '.' + @NewPKCol + @ENTER +
       '  FROM (SELECT NEWID() ' + @NewPKCol + ', * FROM CTE) ' + @AliasLeft + ' RIGHT OUTER JOIN' + @ENTER +
       @TableName + ' ' + @AliasRight + ' ON' + @ENTER +
       @Join)
END
GO