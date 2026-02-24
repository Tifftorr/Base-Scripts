use shipsure
go

select * from BUDGETHDR
where bgh_year = '2025'
and ves_id = 'VGR400022979'

select * from BUDGET_BudgetOptions --connect to BUDGETHDR by bgh_id
where bgh_id = 'VGR700008559'

select ccsp.CTS_Name, ccsp.CTS_Desc, cc.* from [dbo].[BUDGET_Crew_OtherCrewCost] cc --connect crew cost by bud_id
left join BUDGET_ChartTemplate_CostSplitUp ccsp on ccsp.[CTS_ID] = cc.CTS_ID -- connect costsplitup by cts_id
where bud_id = 'VGR700000684'

select distinct ccsp.CTS_Name, ccsp.CTS_Desc, cc.[bco_id] from [dbo].[BUDGET_Crew_OtherCrewCost] cc --connect crew cost by bud_id
left join BUDGET_ChartTemplate_CostSplitUp ccsp on ccsp.[CTS_ID] = cc.CTS_ID -- connect costsplitup by cts_id
where bud_id = 'VGR700000684'


select distinct cts_name, bco_id from BUDGET_ChartTemplate_CostSplitUp
where cts_name like '%ShipMoney%'

select distinct cts_id, cts_name, cts_desc from BUDGET_ChartTemplate_CostSplitUp
where cts_desc like '%ShipMoney%'

select top 10 * from vessel

--------------------------------------------------
Use shipsure
GO

Select
bud.[Ves_id] as [Vessel ID],
bud.[COY_ID],
vv.[ves_name] as [Vessel Name],
vv.[ves_imonumber] as [IMO],
vm.vmd_managestart,
vm.vmd_manageend,
budop.[Bud_id] as [Budget ID],
othcc.[Bco_id],
othcc.[bco_cost],
othcc.[bco_quantity],
othcc.[cts_id],
ccsp.cts_name,
ccsp.cts_desc

FROM BUDGETHDR Bud
left join BUDGET_BudgetOptions budop on budop.bgh_id = bud.bgh_id
left join [dbo].[BUDGET_Crew_OtherCrewCost] othcc on othcc.bud_id = budop.bud_id --and othcc.acc_id = '5060900'
left join BUDGET_ChartTemplate_CostSplitUp ccsp on ccsp.[CTS_ID] = othcc.CTS_ID
left join shipsure..vessel vv on vv.[ves_id] = bud.[ves_id]
outer apply (select top 1 * 
				from shipsure..vesmanagementdetails vmd
				where (vmd.vmd_manageend >= cast(GETDATE() as date) or vmd.vmd_manageend is NULL)
				and vmd.[ves_id] = bud.[VES_ID]
				order by vmd.vmd_managestart desc) vm 

WHERE
	bud.bgh_year = '2025'
	and ccsp.cts_name like '%ShipMoney%'
	and vv.VES_IMOnumber = '9749491' -- test
----------------------------------------------------------------

	select top 10 * from vesmanagementdetails

	select * from aggregates.[dbo].[CREW_ActiveCrew]
	where [Datekey] = '20250316'

	select top 10 * from shipsure.[dbo].[CRWPersonalDetailsExt]

	select top 10 * from shipsure.[dbo].[CRWPersonalEducationDetails]
	where CED_partnerinstituteid is not null