SELECT
	SET_ID AS [Service Record ID Event],
	CRW_ID AS [Crew ID],
	CLIENT_IMPACTED AS [Client Impacted],
	GAP_BETWEEN_CLIENTS_IN_DAYS AS [Gap Between Client in Days],
	END_DATE AS [End Date],
	NEW_CLIENT AS [New Client],
	NEW_CLIENT_STARTDATE AS [New Client Start Date],
	DateKey AS [DateKey]
FROM 
	[Aggregates].[dbo].[CREW_RETENTION_EVENTS_CLIENT]