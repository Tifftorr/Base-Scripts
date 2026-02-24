--tCrewPlanningHistory

select distinct
	
	cph.cph_id [CPH ID],
	cph.CRW_ID [Crew ID],
	cph.set_id [Service Record ID],
	cph.csa_id_previous as [Planning Status ID Previous],
	csa1.csa_description as [Planning Status Previous],
	cph.csa_id_new as [Planning Status ID New],
	csa2.csa_description [Planning Status New],
	cph_createdon as [Planning History CreatedOn],
	CPH_CreatedBy as [Planning History Created by ID],
	CPH_UpdatedOn as  [Planning History UpdatedOn],
	CPH_UpdatedBy as [Planning History Updated By ID],
	CPH_Notes as [Notes]

		from Shipsure..CRWPlanningHistory (NOLOCK) cph
		left join shipsure.[dbo].CRWAssignedStatus (NOLOCK) csa1 on csa1.csa_id = cph.csa_id_previous
		left join shipsure.[dbo].CRWAssignedStatus (NOLOCK) csa2 on csa2.csa_id = cph.csa_csa_id_new
			where cph.cph_cancelled = 0