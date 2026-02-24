--tCrewPlanningHistory

SELECT DISTINCT
	cph.cph_id [Crew Planning History ID],
	cph.CRW_ID [Crew ID],
	cph.set_id [Service Record ID],
	cph.csa_id_previous [Planning Status ID Previous],
	csa1.csa_description [Planning Status Previous],
	cph.csa_id_new [Planning Status ID New],
	csa2.csa_description [Planning Status New],
	cph_createdon [Planning History Created On],
	CPH_CreatedBy [Planning History Created By ID],
	usr.USR_DisplayName [Planning History Created By],
	CPH_UpdatedOn [Planning History Updated On],
	CPH_UpdatedBy [Planning History Updated By ID],
	USR2.USR_DisplayName [Planning History Updated By],
	CPH_Notes [Notes],
	BINARY_CHECKSUM (
		cph.cph_id,
		cph.CRW_ID,
		cph.set_id,
		cph.csa_id_previous,
		csa1.csa_description,
		cph.csa_id_new,
		csa2.csa_description,
		cph_createdon,
		CPH_CreatedBy,
		usr.USR_DisplayName,
		CPH_UpdatedOn,
		CPH_UpdatedBy,
		USR2.USR_DisplayName,
		CPH_Notes
	) [ChangeIdentifier]

FROM Shipsure..CRWPlanningHistory (NOLOCK) cph
	left join shipsure.[dbo].CRWAssignedStatus (NOLOCK) csa1 ON csa1.csa_id = cph.csa_id_previous
	left join shipsure.[dbo].CRWAssignedStatus (NOLOCK) csa2 ON csa2.csa_id = cph.csa_id_new
	left join shipsure..USERID (NOLOCK) usr ON usr.USR_ID = cph.CPH_CreatedBy AND USR.USR_DELETED = 0
	left join shipsure..USERID (NOLOCK) usr2 ON usr2.USR_ID = cph.CPH_UpdatedBy AND USR2.USR_DELETED = 0
WHERE cph.cph_cancelled = 0