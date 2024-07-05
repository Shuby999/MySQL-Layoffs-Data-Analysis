SELECT * FROM data.layoffs;
-- max min laid_off
select max(total_laid_off) as max,min(total_laid_off) as min from data.layoffs ;
select company,max(total_laid_off) as max from data.layoffs group by company order by max desc limit 5 ;
-- max date min laidoff
select max(`date`),min(`date`) from data.layoffs;

-- yearwise laidoff
select  YEAR(`date`) as Yea,sum(total_laid_off) from data.layoffs group by Yea ;



-- year n month laidoff with rolling laidoff(cum_sum)
with monthly_laid as (select  date_format(`date`,'%Y-%m') as `month`, sum(total_laid_off) as 'month_laid_off'
from data.layoffs group by `month` order by `month`)
select *, sum(month_laid_off) over (order by `month`) AS `rolling_sum` from monthly_laid; 


-- laidoff with stage of fund_raised
select company,stage,sum(total_laid_off) as stage_laid_off
 from data.layoffs
 group by company,stage
 order by company;
 
 -- company avg percentage laidoff
select company,round(sum(total_laid_off)/(select sum(total_laid_off) from data.layoffs) *100,2) as total
from data.layoffs group by company order by total desc ;

-- rank of top 5 company in year who has laid of most
with ans as ( with temp as (select company,Year(`date`) as `year`,sum(total_laid_off) as total
from data.layoffs group by company,`year`)
select*,row_number() over(partition by `year` order by `year`,total desc) as `rank` from temp)
select* from ans where `rank`<6 ;