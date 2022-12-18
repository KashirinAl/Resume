--Table: Transactions
--Client_id	Report_date	Txn_amount
--123	    2017.01.01	50000

--Table: Rates
--Report_date	Ccy_code	CCy_rate
--2016.12.30	840	        60,58
--2017.01.09	840	        61,01

--�������: �������� sql ������, ������� ����� ���������� ����� ���������� � usd (ccy_code = 840) � ������ ����, ��� � ������� rates ������ ������ �� ������� ���. 
--����������, ����������� � ��������, ��������������� �� ����� ���������� �������� ��� ����� ����������/��������. 
--���������: ������, ����, ����� �������� � usd.

With rates as (
SELECT Report_date, CCy_rate 
                    FROM Table.Rates WHERE C�y_code = 840
)
SELECT dates.Client_id as ������, 
       dates.Report_date as ����, 
       dates.Txn_amount * rates_1.CCy_rate as '����� �������� � usd'
FROM ( /* ������������ ���� ������ ��� ������ - ����� ��� �������-����������� ���������� ������� */
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
JOIN rates as rates_1 /* ����� �������� �� ����������� ���� */
ON rates_1.Report_date = dates.Max_week_day;