--Table: VSP_oper_data
--Client_id	Report_date	VSP_Number	Txn_type	Txn_amount
--1233455	2017.05.02	1234/0123	debit	    10000

--В таблице VSP_oper_data txn_type принимает значения debit, credit
--Задание: напишите sql запрос, который для каждого клиента выводит сумму debit, credit операций и последнее посещенное VSP по месяцам. 
--Результат представьте в виде: 
--Client_id	Report_date	Debit_amount	Credit_amount	Last_VSP

SELECT Client_id, 
       MAX(Report_date), 
SUM( CASE WHEN Txn_type = 'debit'
          THEN Debit_amount 
          ELSE 0 END) as Debit_amount, 
SUM( CASE WHEN Txn_type = 'credit' 
          THEN Credit_amount 
          ELSE 0 END) as Credit_amount,
Last_VSP
FROM Table.VSP_oper_data as tab_a
JOIN (
SELECT DISTINCT Client_id, LAST_VALUE(VSP_Number)
       OVER (PARTITION BY Client_id ORDER BY Report_date) AS Last_VSP
FROM Table.VSP_oper_data
) as tab_b
ON tab_a.Client_id = tab_b.Client_id
GROUP BY Client_id, Last_VSP;
