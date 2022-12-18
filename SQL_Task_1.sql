--Table: Transactions
--Client_id	Report_date	Txn_amount
--123	    2017.01.01	50000

--Table: Rates
--Report_date	Ccy_code	CCy_rate
--2016.12.30	840	        60,58
--2017.01.09	840	        61,01

--Задание: Напишите sql запрос, который будет переводить сумму транзакций в usd (ccy_code = 840) с учетом того, что в таблице rates данные только за рабочие дни. 
--Транзакции, совершенные в выходные, пересчитываются по курсу последнего рабочего дня перед праздником/выходным. 
--Результат: Клиент, дата, сумма операций в usd.

With rates as (
SELECT Report_date, CCy_rate 
                    FROM Table.Rates WHERE CСy_code = 840
)
SELECT dates.Client_id as Клиент, 
       dates.Report_date as Дата, 
       dates.Txn_amount * rates_1.CCy_rate as 'Сумма операций в usd'
FROM ( /* Максимальный день недели для недели - чтобы для субботы-воскресенье выбиралась пятница */
            SELECT a.Report_date,  
            MAX( CASE WHEN a.Ccy_rate is null 
                      THEN null 
                      ELSE a.Report_date 
                       END ) 
            OVER ( Partition by WEEK(a.Report_date) ) as Max_week_day,
            a.Client_id, a.Txn_amount
            FROM Table.Transactions as a
            LEFT JOIN rates
            ON a.Report_date = rates.Report_date 
) as dates
JOIN rates as rates_1 /* Курсы крепятся на достроенные даты */
ON rates_1.Report_date = dates.Max_week_day;