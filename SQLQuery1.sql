select * from Census.dbo.Data1;
select * from Census.dbo.Data2;

--Count the number of rows

select COUNT(*) from Census..Data1;
select COUNT(*) from Census..Data2;

--Dataset for Jharkand,Bihar and Maharashtra

select * from census..Data1
where state in ('jharkand','bihar','Maharashtra');

--Population of India

select SUM(population) as Population from Census..Data2;

--average growth

select AVG(growth)*100 as Avg_Growth from Census..Data1;

  --avg sex ratio

  select state,AVG(Sex_Ratio) as Ratio from Census..Data1 group by State;

   select state,round(AVG(Sex_Ratio),0) as Ratio from Census..Data1 group by State
   order by Ratio desc;

   --average literacy rate

    select state,AVG(Literacy) as Literacy_Rate from Census..Data1 group by State;

	select state,round(AVG(Literacy),0) as Literacy_Rate from Census..Data1 group by State order by Literacy_Rate desc;

	select state,round(AVG(Literacy),0) as Literacy_Rate from Census..Data1 
	group by State having round(AVG(Literacy),0)>90 order by Literacy_Rate desc;

	-- Top 3 states showing highest growth ratio

	select top 3 state, AVG(Growth) as growth from Census..Data1 group by State order by growth desc;

	-- Top 3 states showing highest sex ratio

	select top 5 state,round(avg(Sex_ratio),0) as ratio from Census..Data1 group by state order by ratio asc;

	--top 3 and bottom 3 states in literacy state

	create table #topstates	
	(

	state nvarchar(255),
	topstates float 
	)
	insert into #topstates
	select state,ROUND(avg(Literacy),0) as Avg_Literacy_Ratio from Census..Data1
	group by State order by Avg_Literacy_Ratio desc;

	select * from #topstates order by #topstates.topstates desc;



	create table #bottomstates	
	(

	state nvarchar(255),
	bottomstates float 
	)
	insert into #bottomstates
	select state,ROUND(avg(Literacy),0) as Avg_Literacy_Ratio from Census..Data1
	group by State order by Avg_Literacy_Ratio desc;

	select * from #bottomstates order by #bottomstates.bottomstates asc;

	--union operator
	select * from (
	select top 3 * from #topstates order by #topstates.topstates desc) a

	union
	select * from (
	select top 3 * from #bottomstates order by #bottomstates.bottomstates asc) b;

	--states starting with a

	select distinct state from Census..Data1 where LOWER(State) like 'a%' or lower(state) like 'b%'

	select distinct state from Census..Data1 where LOWER(State) like 'a%' and lower(state) like '%h'

	--Innerjoin

	Select a.district,a.state,a.sex_ratio,b.Population from Census..Data1 a
	inner join census..data2 b on a.District=b.district;

	--finding out the number of males and females based on population

	select d.state, sum(d.males) total_males,SUM(d.females) total_females from
	(select c.district,c.state, state, ROUND(c.population/(c.sex_ratio+1),0) males,round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
	(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from Census..Data1 a 
	inner join census..Data2 on a.district=b.district)c)d
	group by d.state;

	--total literacy rate

	select c.state,SUM(Literate_people) Total_literate_pop, SUM(illiterate_people) Total_Illiterate_Pop from
	(select d.district,d.state,ROUND(d.literacy_ratio*d.population,0) literate_people,round((1-d.literacy_ratio)*d.population,0) illiterate_people from
	(select a.district, a.state, a.literacy/100 literacy_ratio,b.population from Census..Data1 a
	inner join census..Data2 b on a.District=b.District) d) c
	group by c.State

	--population in previous census

	select sum(m.previous_census_population) previous_census_population, sum(m.current_census_population) current_census_population from(
	select e.state,sum(e.previous_census_population),SUM(e.current_census_population) from 
	(select d.district,d.state,round(population/(1+d.growth),0) previous_census_population,d.population current_census_population from
	(select a.district,a.state,a.growth, b.population from Census.dbo.Data1 a inner join Census.dbo.Data2 b on a.district=b.district)d)e
	group by e.State) m;

	--window

	output top 3 districts from each state with highest literacy rate

	select a.* from
	(select district,state,literacy,RANK() over (partition by state order by literacy desc) rnk from Census..Data1) a
	where a.rnk in (1,2,3) order  by  State

	




	


