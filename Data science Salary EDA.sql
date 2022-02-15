Select *
From [dbo].[data_cleaned_2021$]
order by 3,4

--Select *
--From [dbo].[data_cleaned_2021$]
--order by 3,4


Select [Industry],[Location],[Sector],[job_title_sim],Max (([Avg Salary(K)])) as [Max Avg Sal], Max (([Rating])) as [Max Rating]
From [dbo].[data_cleaned_2021$]
--WHERE [Industry] like '%Health%'
Group by [Industry], [job_title_sim], [Sector],[Location],[Avg Salary(K)]
order by [Max Rating] desc
  
Select [Job Title],[Rating],[Company Name],[Location],[Industry],[Sector],[Revenue],Max (([Avg Salary(K)])) as [Max Avg Sal]
From [dbo].[data_cleaned_2021$]
WHERE [Avg Salary(K)]  > 40
order by 1,2

Select [Job Title],[Rating],[Company Name],[Location],[Industry],[Sector],Max (([Avg Salary(K)])) as [Max Avg Sal]
From [dbo].[data_cleaned_2021$]
WHERE [Rating]  > 4.5
Group by [Job Title],[Rating],[Company Name],[Location],[Industry],[Sector]
order by [Max Avg Sal] desc


Select [Job Title],[Location],[Sector],[Industry], Max (([Avg Salary(K)])) as [Max Avg Sal]
From [dbo].[data_cleaned_2021$]
WHERE [Job Title] like '%Data Scientist%'
Group by [Location], [Job Title], [Sector],[Industry]
order by [Max Avg Sal] desc

Select [Sector],[Job Title],[Industry], Max (([Avg Salary(K)])) as [Max Avg Sal]
From [dbo].[data_cleaned_2021$]
WHERE [Job Title] like '%Analyst%'
Group by [Sector],[Industry],[Job Title]
order by [Max Avg Sal] desc


Select [aws],[sql],[bi],[tableau],[Python],[excel],Max (([Avg Salary(K)])) as [Max Avg Sal]
From [dbo].[data_cleaned_2021$]
--WHERE [job_title_sim] like '%Analyst%'
Group by [aws],[sql],[bi],[tableau],[Python],[excel]
order by [Max Avg Sal] desc

Select [Industry],[aws],[sql],[bi],[tableau],[Python],[excel],Max (([Avg Salary(K)])) as [Max Avg Sal]
From [dbo].[data_cleaned_2021$]
--WHERE [job_title_sim] like '%Analyst%'
Group by [Industry],[aws],[sql],[bi],[tableau],[Python],[excel]
order by [Max Avg Sal] desc

Select [Industry],[Location],[Sector],[job_title_sim], Max (([Rating])) as [Max Rating]
From [dbo].[data_cleaned_2021$]
--WHERE [Industry] like '%Health%'
Group by [Industry], [job_title_sim], [Sector],[Location]
order by [Max Rating] desc