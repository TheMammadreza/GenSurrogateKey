IF (OBJECT_ID('spGenJoinText') IS NOT NULL)
    DROP PROCEDURE spGenJoinText
GO

CREATE PROCEDURE spGenJoinText(@Result VARCHAR(2000) OUT, @ColList VARCHAR(2000), @Delimiter CHAR(1) = ',', @LeftAlias VARCHAR(31) = 'L', @RightAlias VARCHAR(31) = 'R')
AS
BEGIN
  DECLARE @Pattern VARCHAR(2000) = 'ISNULL(' + @LeftAlias + '.xCol, '''') = ISNULL(' + @RightAlias + '.xCol, '''')',
          @Operator CHAR(5) = ' AND '
  SELECT @ColList = @ColList + @Delimiter,
         @ColList = REPLACE(@ColList, @Delimiter + @Delimiter, ','),
         @Result = ''

  ;WITH CTE AS
  (
    SELECT @ColList ColList,
           CAST(NULL AS VARCHAR(2000)) Col,
           CHARINDEX(',', @ColList) Idx
    UNION ALL
    SELECT SUBSTRING(ColList, Idx + 1, LEN(ColList)) ColList,
           TRIM(CAST(SUBSTRING(ColList, 1, Idx - 1) AS VARCHAR(2000))) Col,
           CHARINDEX(',', SUBSTRING(ColList, CHARINDEX(',', ColList) + 1, LEN(ColList))) Idx
      FROM CTE
     WHERE CHARINDEX(',', ColList) > 0
  )
    SELECT @Result = @Result + REPLACE(@Pattern, 'xCol', Col) + @Operator
      FROM CTE
     WHERE Col IS NOT NULL
  
  SET @Result = LEFT(@Result, LEN(@Result) - LEN(@Operator))
END
GO