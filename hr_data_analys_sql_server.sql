use HR
go

--------------------------------------------------------------------------

-- Ümumi işçi sayı və ayrılma statistikası
select count(*) as [Ümumi işçi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrılan işçilər],
	sum(case when Attrition = 'No' then 1 else 0 end ) as [qalan işçilər],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %],
	cast(sum(case when Attrition = 'No' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [qalma %]
from dbo.EmployeeAttrition

--------------------------------------------------------------------------

-- yaş statistikası
with age as(
select 'ümumi' as [kateqoriya],
	round(avg(cast(Age as float)), 1) AS [Orta Yaş] ,
	min(Age) as [min yaş],
	max(Age) as [max yaş],
	round(stdev(Age), 3) as [standart sapma]
from dbo.EmployeeAttrition

union all

select 'ayrıldı',
	round(avg(cast(Age as float)), 1),
	min(Age),
	max(Age),
	round(stdev(Age), 3)
from dbo.EmployeeAttrition 
where Attrition = 'Yes'

union all

select 'qaldı',
	round(avg(cast(Age as float)), 1),
	min(Age),
	max(Age),
	round(stdev(Age), 3)
from dbo.EmployeeAttrition
where Attrition = 'No')

select * from age

--------------------------------------------------------------------------

-- Cins üzrə ayrılma
select Gender as [cins],
	count(*) as [ümumi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	sum(case when Attrition = 'No' then 1 else 0 end) as [qaldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %]
from dbo.EmployeeAttrition
group by Gender
order by [ayrılma %] desc

--------------------------------------------------------------------------

-- Nikah statusu üzrə ayrılma
select MaritalStatus as [nikah statusu],
	count(*) as [ümumi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %]
from dbo.EmployeeAttrition
group by MaritalStatus
order by [ayrılma %] desc

--------------------------------------------------------------------------

-- Departament üzrə ayrılma
select Department as [departament],
	count(*) as [ümumi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	sum(case when Attrition = 'No' then 1 else 0 end) as [qaldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrıldı %]
from dbo.EmployeeAttrition
group by Department
order by [ayrıldı %]

--------------------------------------------------------------------------

-- Vəzifə (Job Role) üzrə ayrılma
select JobRole as [vəzifə],
	count(*) as [ümumi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	sum(case when Attrition = 'No' then 1 else 0 end) as [qaldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %]	 
from dbo.EmployeeAttrition
group by JobRole
order by [ayrılma %]

--------------------------------------------------------------------------

-- Vəzifə səviyyəsi üzrə ayrılma
select JobLevel as [vəzifə Səviyyəsi],
    count(*) as [ümumi Sayı],
    avg(cast(MonthlyIncome as float)) as [orta əmək haqqı],
    sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
    cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100.0 / count(*) as decimal(5,2)) as [ayrılma %]
from dbo.EmployeeAttrition
group by JobLevel
order by [ayrılma %] desc

--------------------------------------------------------------------------

-- Əmək haqqı statistikası
with salary as(
select 'ümumi' as [kateqoriya],
	round(avg(cast(MonthlyIncome as float)), 2) as [orta əmək haqqı],
	min(MonthlyIncome) as [min əmək haqqı],
	max(MonthlyIncome) as [max əmək haqqı],
	round(stdev(MonthlyIncome), 2) as [standart sapma]
from dbo.EmployeeAttrition

union all

select 'ayrıldı',
	round(avg(cast(MonthlyIncome as float)), 2),
	min(MonthlyIncome),
	max(MonthlyIncome),
	round(stdev(MonthlyIncome), 2)
from dbo.EmployeeAttrition
where Attrition = 'Yes'

union all

select 'qaldı',
	round(avg(cast(MonthlyIncome as float)), 2),
	min(MonthlyIncome),
	max(MonthlyIncome),
	round(stdev(MonthlyIncome), 2)
from dbo.EmployeeAttrition
where Attrition = 'No')

select * from salary

--------------------------------------------------------------------------

-- Əmək haqqı fərqi (Ayrılanlar vs Qalanlar)
select 
	round(avg(case when Attrition = 'Yes' then cast(MonthlyIncome as float) end), 2) as [ayrılanların orta əmək haqqı],
	round(avg(case when Attrition = 'No' then cast(MonthlyIncome as float) end), 2) as [qalanların orta əmək haqqı],
	round(avg(case when Attrition = 'No' then cast(MonthlyIncome as float) end) - avg(case when Attrition = 'Yes' then cast(MonthlyIncome as float) end), 2) as [əmək haqqı fərqi],
	round(cast((avg(case when Attrition = 'No' then cast(MonthlyIncome as float) end) - avg(case when Attrition = 'Yes' then cast(MonthlyIncome as float) end)) * 100 / avg(case when Attrition = 'No' then cast(MonthlyIncome as float) end) as decimal(5,2)), 2) as [fərq %]
from dbo.EmployeeAttrition

--------------------------------------------------------------------------

-- Departament üzrə əmək haqqı və ayrılma
select Department as [departament],
	Attrition as [ayrılma],
	count(*) as [sayı],
	round(avg(cast(MonthlyIncome as float)), 2) as [orta əmək haqqı],
	min(MonthlyIncome) as [min],
	max(MonthlyIncome) as [max]
from dbo.EmployeeAttrition
group by Department, Attrition
order by Department, Attrition

--------------------------------------------------------------------------

-- Overtime üzrə ayrılma
select OverTime, 
	count(*) as [ümumi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	sum(case when Attrition = 'No' then 1 else 0 end) as [qaldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %]
from dbo.EmployeeAttrition
group by OverTime
order by [ayrılma %] desc

--------------------------------------------------------------------------

-- Overtime və Əmək Haqqı kombinasiyası
select OverTime, 
	count(*) as [ümumi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	sum(case when Attrition = 'No' then 1 else 0 end) as [qaldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %]
from dbo.EmployeeAttrition
group by OverTime 
order by [ayrılma %]

--------------------------------------------------------------------------

-- Risk hesablaması (Overtime edənlər vs etməyənlər)
with over_time_risk as (
select OverTime,
	count(*) as [ümumi],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %]
from dbo.EmployeeAttrition
group by OverTime )

select * , 
	(select [ayrılma %] from over_time_risk where OverTime = 'Yes') / (select [ayrılma %] from over_time_risk where OverTime = 'No') as [risk artımı (x dəfə)]
from over_time_risk

--------------------------------------------------------------------------

-- İş razılığı üzrə ayrılma
select JobSatisfaction as [iş razılığı (1-4)],
	count(*) as [ümumi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %]
from dbo.EmployeeAttrition
group by JobSatisfaction
order by JobSatisfaction

--------------------------------------------------------------------------

-- İş-həyat balansı üzrə ayrılma
select WorkLifeBalance as [iş həyat balansı (1-4)],
	count(*) as [ümumi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %]
from dbo.EmployeeAttrition
group by WorkLifeBalance
order by WorkLifeBalance

--------------------------------------------------------------------------

-- Ətraf mühit razılığı
select EnvironmentSatisfaction as [ətraf mühit razılığı (1-4)],
	count(*) as [ümumi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %]
from dbo.EmployeeAttrition
group by EnvironmentSatisfaction
order by EnvironmentSatisfaction

--------------------------------------------------------------------------

-- Razılıq göstəriciləri üzrə ümumi analiz
select 'iş razılığı' as [göstərici],
	round(avg(cast(JobSatisfaction as float)), 2) as [ümumi orta],
	round(avg(case when Attrition = 'Yes' then cast(JobSatisfaction as float) end), 2) as [ayrılanlar],
	round(avg(case when Attrition = 'No' then cast(JobSatisfaction as float) end), 2) as [qalanlar]
from dbo.EmployeeAttrition

union all

select 
    'iş - həyat balansı',
    round(avg(cast(WorkLifeBalance as float)), 2),
    round(avg(case when Attrition = 'Yes' then cast(WorkLifeBalance as float) end), 2),
    round(avg(case when Attrition = 'No' then cast(WorkLifeBalance AS float) end), 2)
from dbo.EmployeeAttrition

union all
 
select 'ətraf mühit razılığı',
	round(avg(cast(EnvironmentSatisfaction as float)), 2),
	round(avg(case when Attrition = 'Yes' then cast(EnvironmentSatisfaction as float) end), 2),
	round(avg(case when Attrition = 'No' then cast(EnvironmentSatisfaction as float) end), 2)
from dbo.EmployeeAttrition

--------------------------------------------------------------------------

-- Evdən məsafə statistikası
select 'ümumi' as [kateqoriya],
	round(avg(cast(DistanceFromHome as float)), 2) as [orta məsafə (mil)],
	min(DistanceFromHome) as [min],
	max(DistanceFromHome) as [max]
from dbo.EmployeeAttrition

union all

select 'ayrıldı',
	round(avg(cast(DistanceFromHome as float)), 2),
	min(DistanceFromHome) as [min],
	max(DistanceFromHome) as [max]
from dbo.EmployeeAttrition
where Attrition = 'Yes'

union all

select 'qaldı',
	round(avg(cast(DistanceFromHome as float)), 2),
	min(DistanceFromHome) as [min],
	max(DistanceFromHome) as [max]
from dbo.EmployeeAttrition
where Attrition = 'No'

--------------------------------------------------------------------------

-- İş səyahəti üzrə ayrılma
select BusinessTravel as [səyahət tipi],
	count(*) as [ümumi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %]
from dbo.EmployeeAttrition
group by BusinessTravel
order by [ayrılma %] desc

--------------------------------------------------------------------------

-- Məsafə qrupları üzrə ayrılma
select 
	case 
		when DistanceFromHome <= 5 then '0 - 5 mil'
		when DistanceFromHome <= 10 then '6 - 10 mil'
		when DistanceFromHome <= 20 then '11 - 20 mil'
		else '20 + mil'
	end as [məsafə qrupu],
	count(*) as [ümumi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %]
from dbo.EmployeeAttrition
group by case
		when DistanceFromHome <= 5 then '0 - 5 mil'
		when DistanceFromHome <= 10 then '6 - 10 mil'
		when DistanceFromHome <= 20 then '11 - 20 mil'
		else '20 + mil'
	end
order by [ayrılma %] desc

--------------------------------------------------------------------------

-- Təcrübə statistikası
select 'ümumi iş tecrübesi' as [təcrübə tipi],
	round(avg(cast(YearsAtCompany as float)), 2) as [ümumi orta],
	round(avg(case when Attrition = 'Yes' then cast(TotalWorkingYears as float) end), 2) as [ayrılanlar],
	round(avg(case when Attrition = 'No' then cast(TotalWorkingYears as float) end), 2) as [qalanlar]
from dbo.EmployeeAttrition

union all

select 'şirketde işleme',
	round(avg(cast(YearsAtCompany as float)), 2),
	round(avg(case when Attrition = 'Yes' then cast(YearsAtCompany as float) end), 2),
	round(avg(case when Attrition = 'No' then cast(YearsAtCompany as float) end), 2)
from dbo.EmployeeAttrition

union all

select 
    'cari vezifede işleme',
    round(avg(cast(YearsInCurrentRole as float)), 2),
    round(avg(case when Attrition = 'Yes' then cast(YearsInCurrentRole as float) end), 2),
    round(avg(case when Attrition = 'No' then cast(YearsInCurrentRole as float) end), 2)
from dbo.EmployeeAttrition

union all

select 'son teqibden beri',
	avg(cast(YearsSinceLastPromotion as float)),
	avg(case when Attrition = 'Yes' then cast(YearsSinceLastPromotion as float) end),
	avg(case when Attrition = 'No' then cast(YearsSinceLastPromotion as float) end)
from dbo.EmployeeAttrition

--------------------------------------------------------------------------

-- Şirkətdə işləmə müddəti qrupları
select 
    case 
        when YearsAtCompany <= 2 then '0 - 2 il'
        when YearsAtCompany <= 5 then '2 - 5 il'
        when YearsAtCompany <= 10 then '5 - 10 il'
        when YearsAtCompany <= 20 then '10 - 20 il'
        else '20 + il'
    end as [işleme müddeti],
    count(*) AS [ümumi Sayı],
    sum(case when Attrition = 'Yes' then 1 else 0 end) AS [ayrıldı],
    cast(sum(case when Attrition = 'Yes' then 1 else 0) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS [ayrılma %]
from dbo.EmployeeAttrition
group by case 
    when YearsAtCompany <= 2 then '0-2 il'
    when YearsAtCompany <= 5 then '2-5 il'
    when YearsAtCompany <= 10 then '5-10 il'
    when YearsAtCompany <= 20 then '10-20 il'
    else '20+ il'
end
order by [ayrılma %] desc;

--------------------------------------------------------------------------

-- Risk balı hesablaması (cox faktorlu)
with risk_analiz as (
select EmployeeNumber, Age, Department, JobRole, MonthlyIncome, Attrition,
	(
	case when OverTime = 'Yes' then 1 else 0 end + 
	case when MonthlyIncome < (select avg(MonthlyIncome) from dbo.EmployeeAttrition) then 1 else 0 end + 
	case when JobSatisfaction <=2 then 1 else 0 end +
	case when WorkLifeBalance <=2 then 1 else 0 end +
	case when YearsAtCompany <=3 then 1 else 0 end
	) as risk_bali 
from dbo.EmployeeAttrition)
select risk_bali,
	count(*) as [işçi sayi],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %]
	from risk_analiz
group by risk_bali
order by risk_bali

--------------------------------------------------------------------------

-- Yüksək riskli işçilərin siyahısı 
with risk as (
select EmployeeNumber, Age, Gender, Department, JobRole, MonthlyIncome,
	YearsAtCompany, Attrition, OverTime, JobSatisfaction, WorkLifeBalance,
	(case when OverTime = 'Yes' then 1 else 0 end + 
	case when MonthlyIncome < (select avg(MonthlyIncome) from dbo.EmployeeAttrition) then 1 else 0 end + 
	case when JobSatisfaction <=2 then 1 else 0 end + 
	case when WorkLifeBalance <= 2 then 1 else 0 end +
	case when YearsAtCompany <3 then 1 else 0 end ) as risk_bali
from dbo.EmployeeAttrition)
select top 50 * from risk
where risk_bali >= 3 and Attrition = 'No' 
order by risk_bali desc , MonthlyIncome asc

--------------------------------------------------------------------------

-- Departament və Vəzifə Səviyyəsi üzrə ayrılma
select Department as [departament],
	JobLevel as [vezife seviyyesi],
	count(*) as [ümumi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / COUNT(*) as decimal(5,2)) as [ayrılma %],
	round(avg(CAST(MonthlyIncome as float)), 2) as [orta aylıq emek haqqı]
from dbo.EmployeeAttrition
group by Department, JobLevel
order by Department, JobLevel

--------------------------------------------------------------------------

-- Overtime və İş Razılığı kombinasiyası
select OverTime, 
	JobSatisfaction as [iş razılıgı],
	count(*) as [ümumi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %]
from dbo.EmployeeAttrition
group by OverTime, JobSatisfaction
order by OverTime, JobSatisfaction

--------------------------------------------------------------------------

-- Statistika və Ayrılma korrelyasiya
select 'Age' as [deyişen],
	round(avg(cast(Age as float)), 2) as [ümumi orta],
	round(avg(case when Attrition = 'Yes' then cast(Age as float) end), 2) as [orta (ayrıldı)],
	round(avg(case when Attrition = 'No' then cast(Age as float) end), 2) as [qaldı (orta)],
	round(STDEV(Age), 2) as [standart sapma]
from dbo.EmployeeAttrition

union all

select 'Monthly Income',
	round(avg(cast(MonthlyIncome as float)), 2),
	round(avg(case when Attrition = 'Yes' then cast(MonthlyIncome as float) end), 2),
	round(avg(case when Attrition = 'No' then cast(MonthlyIncome as float) end), 2),
	round(STDEV(DistanceFromHome), 2)
from dbo.EmployeeAttrition

union all

select 'Distance from Home',
	round(avg(cast(DistanceFromHome as float)), 2),
	round(avg(case when Attrition = 'Yes' then cast(DistanceFromHome as float) end), 2),
	round(avg(case when Attrition = 'No' then cast(DistanceFromHome as float) end), 2),
	round(STDEV(DistanceFromHome), 2)
from dbo.EmployeeAttrition

union all 

select 'Years at Company',
	round(avg(cast(YearsAtCompany as float)), 2),
	round(avg(case when Attrition = 'Yes' then cast(YearsAtCompany as float) end), 2),
	round(avg(case when Attrition = 'No' then cast(YearsAtCompany as float) end), 2),
	round(STDEV(YearsAtCompany), 2)
from dbo.EmployeeAttrition

union all

select 'Job Satisfaction',
	round(avg(cast(JobSatisfaction as float)), 2),
	round(avg(case when Attrition = 'Yes' then cast(YearsAtCompany as float) end), 2),
	round(avg(case when Attrition = 'No' then cast(YearsAtCompany as float) end), 2),
	round(STDEV(JobSatisfaction), 2)
from dbo.EmployeeAttrition

--------------------------------------------------------------------------

-- View 1: Əsas Statistika
if OBJECT_ID('statistika', 'V') is not null
	drop view statistika
go

create view statistika as 
select count(*) as [ümumi işçi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrıldı],
	sum(case when Attrition = 'No' then 1 else 0 end) as [qaldı],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %]
from dbo.EmployeeAttrition
go

select * from statistika
go

--------------------------------------------------------------------------

-- View 2: Departament Analizi
if OBJECT_ID ('departament_analizi', 'V') is not null
	drop view departament_analizi
go

create view departament_analizi as 
select Department,
	count(*) as [ümumi işçi sayı],
	sum(case when Attrition = 'Yes' then 1 else 0 end) as [ayrılma],
	cast(sum(case when Attrition = 'Yes' then 1 else 0 end) * 100 / count(*) as decimal(5,2)) as [ayrılma %],
	round(avg(cast(MonthlyIncome as float)), 2) as [ortalama_emek_haqqi],
	round(avg(cast(Age as float)), 2) as [ortalama_yaş]
from dbo.EmployeeAttrition
group by Department
go

select * from departament_analizi
go

--------------------------------------------------------------------------

-- View 3: Yüksək Risk Profili
if OBJECT_ID('yuksek_riskli_isciler', 'V') is not null
	drop view yuksek_riskli_isciler
go

create view yuksek_riskli_isciler as
select EmployeeNumber, Age, Gender, Department, JobRole, MonthlyIncome, 
	YearsAtCompany, OverTime, JobSatisfaction, WorkLifeBalance,
	(case when OverTime = 'Yes' then 1 else 0 end +
	case when MonthlyIncome < (select avg(MonthlyIncome) from dbo.EmployeeAttrition) then 1 else 0 end + 
	case when JobSatisfaction <=2 then 1 else 0 end +
	case when WorkLifeBalance <=2 then 1 else 0 end +
	case when YearsAtCompany <3 then 1 else 0 end) as risk_bali
from dbo.EmployeeAttrition
where Attrition = 'No'
go

select * from yuksek_riskli_isciler
go

--------------------------------------------------------------------------
