-- Preppin' Data 2023 Week 02
-- !! REQUIREMENTS !!

-- Requirements
-- Input the data
-- In the Transactions table, there is a Sort Code field which contains dashes. We need to remove these so just have a 6 digit string
-- Use the SWIFT Bank Code lookup table to bring in additional information about the SWIFT code and Check Digits of the receiving bank account
-- Add a field for the Country Code
    -- Hint: all these transactions take place in the UK so the Country Code should be GB
-- Create the IBAN as above 
    -- Hint: watch out for trying to combine sting fields with numeric fields - check data types
-- Remove unnecessary fields 
-- Output the data

-- !! WORKING !!

-- Learning how replace works.
SELECT REPLACE(SORT_CODE,'-','') AS "shortCode"
FROM PD2023_WK02_TRANSACTIONS;

-- Learning how joins and aliasing works.
SELECT * 
FROM PD2023_WK02_SWIFT_CODES AS SW
JOIN PD2023_WK02_TRANSACTIONS AS TR ON SW.bank = TR.bank;


-- !! OUTPUT !!
 
-- Pretty simple. Just a long concat.
SELECT transaction_id,
    CONCAT('GB',CHECK_DIGITS,SWIFT_CODE,REPLACE(SORT_CODE,'-',''),account_number) AS IBAN
FROM PD2023_WK02_SWIFT_CODES AS SW
JOIN PD2023_WK02_TRANSACTIONS AS TR ON SW.bank = TR.bank