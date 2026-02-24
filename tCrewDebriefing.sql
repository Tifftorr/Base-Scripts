--tCrewDebriefing

Select distinct
	CDB_ID [Debriefing ID],
	CRW_ID [Crew ID],
	SET_ID [Service Record ID],
	CDB_StatusId [Debriefing Status ID],
	cdb_comments [Debriefing Comments],
	CDB_CreatedBy [Debriefing Created By ID],
	CDB_CreatedOn [Debriefing Created On],
	CDB_UpdatedBy [Debriefing Updated By ID],
	CDB_UpdatedOn [Debriefing Updated On],
	CDB_StatusUpdatedBy [Debriefing Status Updated By ID],
	CDB_StatusUpdatedOn [Debriefing Status UpdatedOn],
	CDB_ContactedBy as [Seafarer Contacted By ID],
	CDB_ContactedOn [Seafarer ContactedOn]

		from ShipSure..[CRWDebriefing] CDB
			where CDB_Cancelled = 0