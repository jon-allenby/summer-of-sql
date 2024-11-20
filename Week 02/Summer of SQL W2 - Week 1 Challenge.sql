-- Preppin' Data 2023 Week 01

-- !! REQUIREMENTS !!

-- Requirements
-- Input the data
-- Split the Transaction Code to extract the letters at the start of the transaction code. These identify the bank who processes the transaction
    -- Rename the new field with the Bank code 'Bank'. 
-- Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values. 
-- Change the date to be the day of the week
-- Different levels of detail are required in the outputs. You will need to sum up the values of the transactions in three ways (help):
    -- 1. Total Values of Transactions by each bank
    -- 2. Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)
    -- 3. Total Values by Bank and Customer Code
-- Output each data file

-- !! OUTPUT 1 !!

-- I originally tried this with taking the left 3 characters and spent a while trying to figure out how to regex remove non-alphabetic characters.
-- Thank god for Will's hint for SPLIT_PART

SELECT split_part(transaction_code,'-',1) AS Bank,
    SUM(value) as Value,
FROM pd2023_wk01
GROUP BY Bank;

-- !! OUTPUT 2 !!

-- First time using case statements.
-- Tried a variety of date parsing functions hoping to avoid a CASE like statement.
-- Why are there so many options for getting date parts? What's the difference between CASE and DECODE?
-- Spent a while wondering why I was getting NULL week days before discovering that Sundays = 0 and not 7.

SELECT split_part(transaction_code,'-',1) AS Bank,
    SUM(value) as Value,
    CASE 
        WHEN online_or_in_person = 1 THEN 'Online'
        ELSE 'In-Person'
    END AS "Online or In-Person",
    DECODE( EXTRACT( dayofweek FROM DATE(split_part(transaction_date,' ',1),'dd/mm/yyyy')),
        1, 'Monday',
        2, 'Tuesday',
        3, 'Wednesday',
        4, 'Thursday',
        5, 'Friday',
        6, 'Saturday',
        0, 'Sunday') AS "Day of Week",
//      EXTRACT(dayofweek FROM DATE(split_part(transaction_date,' ',1),'dd/mm/yyyy')) AS Dow,
//      DAYNAME(DATE(split_part(transaction_date,' ',1),'dd/mm/yyyy')) AS "Day of Week 2"
FROM pd2023_wk01
GROUP BY Bank, online_or_in_person, "Day of Week";

//OUTPUT 3

SELECT split_part(transaction_code,'-',1) AS Bank,
    SUM(value) as Value,
    CUSTOMER_CODE as "Customer Code"
FROM pd2023_wk01
GROUP BY Bank, CUSTOMER_CODE;