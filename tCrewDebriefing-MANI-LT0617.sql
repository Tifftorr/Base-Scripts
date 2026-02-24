--tCrewDebriefing

SELECT DISTINCT TOP 10
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
	CDB_ContactedBy AS [Seafarer Contacted By ID],
	CDB_ContactedOn [Seafarer ContactedOn]

		FROM ShipSure..[CRWDebriefing] CDB
			WHERE CDB_Cancelled = 0


			select top 1000 * from ShipSure..[CRWDebriefing] CDB
			where cdb_statusid = 2
			and cast(cdb_createdon as date) >= '2024-01-01'

			-- 0 = Open
			-- 1 = Debriefing not required
			-- 2 = In-Progress
			-- 3 = Completed
