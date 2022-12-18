--Table: VSP_oper_data
--Client_id	Report_date	VSP_Number	Txn_type	Txn_amount
--1233455	2017.05.02	1234/0123	debit	    10000

--«адание: напишите sql запрос, который дл€ каждого клиента выведет долю debit операций клиента к debit операци€м всех клиентов по мес€цам. 
--–езультат в виде таблицы: 
--Client_id	Report_date	Ratio

SELECT Client_id, 
       Report_date,
       Debit / Sum(debit) OVER ( PARTITION BY Report_date ) as Ratio
FROM (
    SELECT Client_id, 
           DATE_TRUNC('MONTH', Report_date) AS Report_date, 
           SUM(txn_amount) as debit
    FROM Table.VSP_oper_data
    GROUP BY 1,2
) as Client_debits;