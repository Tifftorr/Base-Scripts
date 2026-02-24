--tCrewPool

Select distinct
	cpl.CPL_ID [CPL ID],
	cpl.CPL_Description [CPL Description],
	cpl.CPL_UpdatedBy [CPL UpdatedBy ID],
	cpl.CPL_UpdateOn [CPL Updated On],
	cpl.sit_id [Office ID],
	cpl.CPL_Active [CPL Is Active],
	cpl.CPL_Type [CPL Type ID],
	cpt.CPT_Description [CPL Type Description]



	from shipsure.dbo.CRWPool (NOLOCK) cpl
	left join shipsure.[dbo].[CRWPoolType] (NOLOCK) cpt on cpt.cpt_id = cpl.CPL_Type
		where cpl.CPL_Cancelled = 0