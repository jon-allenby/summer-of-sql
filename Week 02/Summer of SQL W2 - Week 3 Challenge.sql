-- Preppin' Data 2023 Week 03
-- !! REQUIREMENTS !!

-- Requirements
-- Input the data
-- For the transactions file:
    -- Filter the transactions to just look at DSB
        -- These will be transactions that contain DSB in the Transaction Code field
    -- Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values
    -- Change the date to be the quarter
    -- Sum the transaction values for each quarter and for each Type of Transaction (Online or In-Person) 
-- For the targets file:
    -- Pivot the quarterly targets so we have a row for each Type of Transaction and each Quarter
    -- Rename the fields
    -- Remove the 'Q' from the quarter field and make the data type numeric
-- Join the two datasets together
    -- You may need more than one join clause!
-- Remove unnecessary fields
-- Calculate the Variance to Target for each row
-- Output the data

-- !! Working !!

SELECT *
FROM PD2023_WK01;

SELECT * 
FROM PD2023_WK03_TARGETS;

-- Learning filtering
SELECT SPLIT_PART(transaction_code,'-',1) AS TR_C
FROM PD2023_WK01
WHERE TR_C = 'DSB';

-- Getting everything from the first table
SELECT CASE 
        WHEN online_or_in_person = 1 
            THEN 'Online'
            ELSE 'In-Person'
    END AS "Online or In-Person",
    EXTRACT( quarter FROM DATE(split_part(transaction_date,' ',1),'dd/mm/yyyy')) AS "Quarter",
    SUM(value) AS Value
FROM PD2023_WK01
WHERE SPLIT_PART(transaction_code,'-',1) = 'DSB'
GROUP BY ONLINE_OR_IN_PERSON, "Quarter";

-- Learning how to unpivot the second table
SELECT online_or_in_person,
    "Quarterly Targets",
    "Quarter"
FROM PD2023_WK03_TARGETS
UNPIVOT INCLUDE NULLS ("Quarterly Targets" for "Quarter" in (Q1,Q2,Q3,Q4));

-- Trying out the join
SELECT CASE 
        WHEN TR.online_or_in_person = 1 
            THEN 'Online'
            ELSE 'In-Person'
    END AS "Online or In-Person",
    EXTRACT( quarter FROM DATE(split_part(transaction_date,' ',1),'dd/mm/yyyy')) AS "Quarter",
    SUM(value) AS Value
FROM PD2023_WK01 AS TR
JOIN (  
        SELECT TA.online_or_in_person,
            "Quarterly Targets",
            "Quarter" 
        FROM PD2023_WK03_TARGETS AS TA
        UNPIVOT INCLUDE NULLS ("Quarterly Targets" for "Quarter" in (Q1,Q2,Q3,Q4)) 
    ) AS P 
    ON TR.ONLINE_OR_IN_PERSON = P.online_or_in_person
WHERE SPLIT_PART(transaction_code,'-',1) = 'DSB'
GROUP BY TR.ONLINE_OR_IN_PERSON, "Quarter";

-- Well that failed. Learning CTEs

WITH Targets_CTE AS
(
    SELECT online_or_in_person,
        "Quarterly Targets",
        "Quarter" 
    FROM PD2023_WK03_TARGETS AS TA
    UNPIVOT INCLUDE NULLS ("Quarterly Targets" for "Quarter" in (Q1,Q2,Q3,Q4)) 
)
SELECT CASE 
        WHEN TR.online_or_in_person = 1 
            THEN 'Online'
            ELSE 'In-Person'
    END AS "Online or In-Person",
    EXTRACT( quarter FROM DATE(split_part(transaction_date,' ',1),'dd/mm/yyyy')) AS "Quarter",
    SUM(value) AS Value
FROM PD2023_WK01 AS TR
JOIN Targets_CTE AS CTE ON TR.ONLINE_OR_IN_PERSON = CTE.online_or_in_person
WHERE SPLIT_PART(transaction_code,'-',1) = 'DSB'
GROUP BY TR.ONLINE_OR_IN_PERSON, TR.Quarter;  --Error: invalid identifier 'TR.QUARTER' (line 94)

-- Lets simplify.

WITH Targets_CTE AS
(
    SELECT online_or_in_person,
        "Quarterly Targets",
        "Quarter" 
    FROM PD2023_WK03_TARGETS AS TA
    UNPIVOT INCLUDE NULLS ("Quarterly Targets" for "Quarter" in (Q1,Q2,Q3,Q4)) 
) 
SELECT *,
    CASE 
        WHEN TR.online_or_in_person = 1 
            THEN 'Online'
            ELSE 'In-Person'
    END AS "Online or In-Person 2",
FROM PD2023_WK01 AS TR
JOIN Targets_CTE AS CTE ON TR."Online or In-Person 2" = CTE.online_or_in_person; --Error: invalid identifier 'TR."Online or In-Person 2"' (line 113)

-- Going back and fixing the Quarters to join on Quarters

WITH Targets_CTE AS 
(
    SELECT online_or_in_person,
        "Quarterly Targets",
        "Quarter"
    FROM PD2023_WK03_TARGETS
    UNPIVOT INCLUDE NULLS ("Quarterly Targets" for "Quarter" in (Q1,Q2,Q3,Q4))
)
SELECT online_or_in_person,
    "Quarterly Targets",
    TO_NUMBER(REPLACE("Quarter",'Q','')) AS "Quarter"
FROM TARGETS_CTE;