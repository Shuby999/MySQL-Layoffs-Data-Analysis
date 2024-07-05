SELECT * FROM data.layoffs;
insert into data.layoffs
	select*from data.layoffs_data;
delete from data.layoffs;
    
alter table data.layoffs add column Row_num INT NULL AFTER `funds_raised_millions` ;


insert into data.layoffs select*from
(select *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`
,stage,country,funds_raised_millions) as Row_num 
from data.layoffs_data) as layoff;

-- delete duplicates
delete from data.layoffs where Row_num>1;

-- trim data of company
select distinct company,trim(company) from data.layoffs;

-- update table with trimmed data
update data.layoffs set company=trim(company);

-- Update date
-- alter table data.layoffs alter column `date``date` date;

select `date`,str_to_date(`date`,'%m/%d/%Y') from data.layoffs;

update data.layoffs set `date`=str_to_date(`date`,'%m/%d/%Y');

-- null values

select*from data.layoffs as lf1
join data.layoffs as lf2
on lf1.company=lf2.company
where lf1.industry is null or lf1.industry=" "
and lf2.industry is not null and lf2.industry !=" ";

update data.layoffs as lf1
	join data.layoffs as lf2
on lf1.company=lf2.company
set lf1.industry = lf2.industry
where lf1.industry is null or lf1.industry=" "
and lf2.industry is not null and lf2.industry !=" ";
 
 -- drop rows where values are null
 
 select*from data.layoffs where company =`Bally\'s Interactive`;
 delete from data.layoffs where company = `Bally\'s Interactive`;
 
-- drop rows where total_laid_off is null

select count(*)
from data.layoffs where total_laid_off is null and percentage_laid_off is null ;
delete from data.layoffs where total_laid_off is null and percentage_laid_off is null ;

-- sort comapny_name

select *from data.layoffs order by company;



