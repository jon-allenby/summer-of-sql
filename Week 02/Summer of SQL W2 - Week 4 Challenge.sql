-- Preppin' Data 2023 Week 04
-- REQUIREMENTS

--Input the data
--We want to stack the tables on top of one another, since they have the same fields in each sheet. We can do this one of 2 ways:
    --Drag each table into the canvas and use a union step to stack them on top of one another
    --Use a wildcard union in the input step of one of the tables
--Some of the fields aren't matching up as we'd expect, due to differences in spelling. Merge these fields together
--Make a Joining Date field based on the Joining Day, Table Names and the year 2023
--Now we want to reshape our data so we have a field for each demographic, for each new customer
--Make sure all the data types are correct for each field
--Remove duplicates
    --If a customer appears multiple times take their earliest joining date
--Output the data

-- Working

-- Check the input

SELECT * FROM PD2023_WK04_JANUARY;

-- Try a pivot

SELECT *
FROM PD2023_WK04_JANUARY
PIVOT( MAX(VALUE) FOR DEMOGRAPHIC IN (ANY ORDER BY DEMOGRAPHIC) );

-- Try adding the date as string

SELECT *,
    JOINING_DAY::string || '-01-2023' AS Joining_Date -- getting used to ::type and || concat
FROM PD2023_WK04_JANUARY
PIVOT( MAX(VALUE) FOR DEMOGRAPHIC IN (ANY ORDER BY DEMOGRAPHIC) );

-- Try adding the date as a date

SELECT *,
    TO_DATE(JOINING_DAY::string || '-01-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JANUARY
PIVOT( MAX(VALUE) FOR DEMOGRAPHIC IN (ANY ORDER BY DEMOGRAPHIC) );

-- Testing the first union

SELECT * FROM PD2023_WK04_JANUARY
UNION 
SELECT * FROM PD2023_WK04_FEBRUARY;

-- Testing a combined union

SELECT *,
    TO_DATE(JOINING_DAY::string || '-01-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JANUARY
PIVOT( MAX(VALUE) FOR DEMOGRAPHIC IN (ANY ORDER BY DEMOGRAPHIC) )
UNION 
SELECT *,
    TO_DATE(JOINING_DAY::string || '-02-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_FEBRUARY
PIVOT( MAX(VALUE) FOR DEMOGRAPHIC IN (ANY ORDER BY DEMOGRAPHIC) );

-- Testing getting the table name

SELECT * FROM INFORMATION_SCHEMA.PD2023_WK04_JANUARY;
/*002003 (42S02): SQL compilation error:
Object 'TIL_PLAYGROUND.INFORMATION_SCHEMA.PD2023_WK04_JANUARY' does not exist or not authorized. */

-- Nvm, back to unioning. Seeing if pivoting after will be a pain.

SELECT *,
    TO_DATE(JOINING_DAY::string || '-01-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JANUARY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-02-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_FEBRUARY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-03-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_MARCH
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-04-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_APRIL
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-05-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_MAY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-06-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JUNE
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-07-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JULY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-08-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_AUGUST
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-09-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_SEPTEMBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-10-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_OCTOBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-11-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_NOVEMBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-12-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_DECEMBER;

-- Checking where the issues may lay

WITH BigUnion AS (
SELECT *,
    TO_DATE(JOINING_DAY::string || '-01-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JANUARY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-02-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_FEBRUARY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-03-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_MARCH
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-04-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_APRIL
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-05-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_MAY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-06-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JUNE
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-07-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JULY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-08-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_AUGUST
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-09-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_SEPTEMBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-10-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_OCTOBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-11-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_NOVEMBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-12-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_DECEMBER
) 
SELECT DISTINCT DEMOGRAPHIC FROM BigUnion;

-- No issues apparently? Lets give the big pivot a go.

WITH BigUnion AS (
SELECT *,
    TO_DATE(JOINING_DAY::string || '-01-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JANUARY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-02-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_FEBRUARY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-03-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_MARCH
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-04-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_APRIL
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-05-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_MAY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-06-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JUNE
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-07-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JULY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-08-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_AUGUST
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-09-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_SEPTEMBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-10-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_OCTOBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-11-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_NOVEMBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-12-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_DECEMBER
) 
SELECT * 
FROM BigUnion
PIVOT( MAX(VALUE) FOR DEMOGRAPHIC IN (ANY ORDER BY DEMOGRAPHIC) );

-- Looks good? Lets clean up.

WITH BigUnion AS (
SELECT *,
    TO_DATE(JOINING_DAY::string || '-01-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JANUARY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-02-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_FEBRUARY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-03-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_MARCH
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-04-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_APRIL
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-05-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_MAY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-06-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JUNE
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-07-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JULY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-08-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_AUGUST
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-09-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_SEPTEMBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-10-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_OCTOBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-11-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_NOVEMBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-12-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_DECEMBER
) 
SELECT ID,
    JOINING_DATE AS "Joining Date",
    "'Account Type'" AS "Account Type",
    "'Date of Birth'" AS "Date of Birth",
    "'Ethnicity'" AS "Ethnicity"
FROM BigUnion
PIVOT( MAX(VALUE) FOR DEMOGRAPHIC IN (ANY ORDER BY DEMOGRAPHIC) )
ORDER BY ID;

-- Just realised there might be duplicates. Lets check UNION ALL?

WITH BigUnion AS (
SELECT *,
    TO_DATE(JOINING_DAY::string || '-01-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JANUARY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-02-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_FEBRUARY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-03-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_MARCH
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-04-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_APRIL
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-05-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_MAY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-06-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JUNE
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-07-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JULY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-08-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_AUGUST
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-09-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_SEPTEMBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-10-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_OCTOBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-11-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_NOVEMBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-12-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_DECEMBER
) 
SELECT ID,
MIN(Joining_date) AS Min_Date,
MAX(Joining_date) AS Max_Date,
Min_Date = Max_Date AS MyBool
    
/*ID,
    JOINING_DATE AS "Joining Date",
    "'Account Type'" AS "Account Type",
    "'Date of Birth'" AS "Date of Birth",
    "'Ethnicity'" AS "Ethnicity" */
FROM BigUnion
//PIVOT( MIN(VALUE) FOR DEMOGRAPHIC IN (ANY ORDER BY DEMOGRAPHIC) );
GROUP BY ID;
//This shows that we have one ID (878212) with a Min Date of 2023-12-08 and a Max date of 2023-12-22

-- Checking the pivots above reveals it appears as two different rows. In that case surely we can use a Min function

WITH BigUnion AS (
SELECT *,
    TO_DATE(JOINING_DAY::string || '-01-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JANUARY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-02-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_FEBRUARY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-03-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_MARCH
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-04-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_APRIL
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-05-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_MAY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-06-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JUNE
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-07-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_JULY
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-08-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_AUGUST
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-09-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_SEPTEMBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-10-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_OCTOBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-11-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_NOVEMBER
UNION
SELECT *,
    TO_DATE(JOINING_DAY::string || '-12-2023','DD-MM-YYYY') AS Joining_Date
FROM PD2023_WK04_DECEMBER
) 
SELECT ID,
    MIN(JOINING_DATE) AS "Joining Date",
    "'Account Type'" AS "Account Type",
    "'Date of Birth'" AS "Date of Birth",
    "'Ethnicity'" AS "Ethnicity"
FROM BigUnion
PIVOT( MAX(VALUE) FOR DEMOGRAPHIC IN (ANY ORDER BY DEMOGRAPHIC) )
GROUP BY ID, "Account Type", "Date of Birth", "Ethnicity"
ORDER BY ID;