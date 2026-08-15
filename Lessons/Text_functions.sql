SELECT CHAR_LENGTH('SQL'); -- 3

SELECT UPPER('sql'); -- SQL

SELECT LOWER('SQL'); -- sql

SELECT LEFT('SQL', 2); -- SQ

SELECT RIGHT('SQL', 2); -- QL

SELECT SUBSTRING('SQL', 2, 1); -- Q

SELECT CONCAT('SQL','-','FUNCTIONS'); -- SQL-FUNCTIONS

SELECT 'SQL' || '-' || 'FUNCTIONS'; -- SQL-FUNCTIONS

SELECT TRIM('   SQL'); -- SQL

SELECT REPLACE('SQL','Q','_'); -- S_L

SELECT REGEXP_REPLACE('data.engineer@gmail.com','^.*(@)','\1'); -- @gmail.com
