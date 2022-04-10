# Automate ETL (SQL Server)
## _Add Surrogate Key to a Heap Table_


[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

```sql
CREATE PROCEDURE spGenSurrogateKey(
@TableName VARCHAR(63), --The Heap Table
@NewPKCol VARCHAR(63), --Enter New Column as Surrogate Key
@BaseOnCols VARCHAR(2000), --List of Columns to Generate the Key
@Delimiter CHAR(1) = ',' --Assign a Delimiter Related to the List
)
```

> The Result will apply to the Table which is
> passed as the first parameter.