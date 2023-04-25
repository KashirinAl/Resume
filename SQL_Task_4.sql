--������� dict (���� ������ ����������)
--id_dog     dt_beg_dog     dt_end_dog     region
--11111      01.01.2022      31.12.2022       ������
--22222      15.03.2022      30.09.2022       ������
--33333      01.06.2022      31.05.2023       �����-���������
--44444      01.09.2022      31.03.2023       �������
--55555      01.10.2022      28.02.2023       ���

--������� transact (���� ������ ����������)
--id_dog     dt_transact     transact_sum
--11111      15.01.2022     1500
--11111      01.02.2022     2500
--22222      01.04.2022     3000
--33333      01.07.2022     2000

--��������� ����������� sql-������ �� ���������� ����������:
--������� ���-3 ���������� �� ������� �� ���������, ������� ��������� ������ � ������/�����-����������, � ���� ������ �������� ��������� ���������� �� �������� 2022.
--��������� �������� ���������� ������������� �� ����� �� ��������.
--�������� ���:
--region     id_dog     dt_beg_dog     transact_sum


��������� ����������� sql-������ �� ���������� ����������:
������� ���-3 ���������� �� ������� �� ���������, ������� ��������� ������ � ������/�����-����������, � ���� ������ �������� ��������� ���������� �� �������� 2022.
��������� �������� ���������� ������������� �� ����� �� ��������.
�������� ���:
region     id_dog     dt_beg_dog     transact_sum

with t as (/* 
��� ������������� - �� ������ 1 ���������� ���������� ��� 2� ���������. 
��������� � CTE ��� �������� ����������� Transform-�������� 
*/
	select d.region, d.id_dog, d.dt_beg_dog, a.dt_transact, a.transact_sum, 
	       /* ��� ������� �������� ���������� ���-���������� ������� �������� */
		   row_number() over (partition by a.id_dog order by a.transact_sum desc) as top_transact
	from transact as a
	join (select /* ��� ��������, ������� � 1 �������� � ������ � �����-���������� */
	      id_dog, dt_beg_dog, region 
	      from dict 
		  where dt_beg_dog::date >= '01.09.2022'
	      and region in ('������','�����-���������')
	      ) as d
	on a.id_dog = d.id_dog
	)
select region, id_dog, dt_beg_dog, sum( transact_sum ) as transact_sum
from t
where top_transact <= 3 /* ��������� ������ 1,2,3 - ������� ������������� ����� ������� ���������� */
group by region, id_dog, dt_beg_dog
order by sum( transact_sum ) desc;