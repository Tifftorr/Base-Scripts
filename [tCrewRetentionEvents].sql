SELECT 
	cre.ID AS [Retention Event ID],
	cre.CRW_ID AS [Crew ID],
	cr.RNK_Description AS [Crew Rank], 
	rk.CCA_Description AS [Crew Rank Category],
	cre.EVT_Date2 AS [Date],
	mt.STS_Desc AS [Status],
	cre.CLIENT_ID AS [Client ID],
	cre.VES_ID_BEFORE_LEAVE AS [Vessel ID before leaving],
	cre.Unavoidable AS [Is Unavoidable Leaver],
	cre.Beneficial AS [Is Beneficial Leaver],
	cre.StandardLeaver AS [Is Standart Leaver],
	cre.DAYS_REENGAGED AS [Days Reengaged],
	BINARY_CHECKSUM(cre.ID,
		cre.CRW_ID,
		cr.RNK_Description, 
		rk.CCA_Description,
		cre.EVT_Date,
		mt.STS_Desc,
		cre.CLIENT_ID,
		cre.VES_ID_BEFORE_LEAVE,
		cre.Unavoidable,
		cre.Beneficial,
		cre.StandardLeaver,
		cre.DAYS_REENGAGED) AS [ChangeIdentifier],
	cre.RNK_ID as [Rank ID],
	cre.SET_ID_ONBOARD as [Service Record ID Last Onboard],
	cre.[SET_ID_EVENT] as [Leave Service Record ID],
	cre.[CPL_ID] as [Mobilisation Cell ID],
	cre.[CPL_ID_PLAN] as [Planning Cell ID],
	cre.[SIGNED_OFF] as [Last Sign Off Date],
	cre.[EVT_CreatedOn] as [Event Created On],
	cre.[EVT_Cancelled] as [Event Cancelled]

FROM 
	Aggregates.[dbo].[CREW_RETENTION_EVENTS] cre
	LEFT JOIN ShipSure.[dbo].[CRWRanks] cr ON cr.RNK_ID = cre.RNK_ID and RNK_Active = 1
	LEFT JOIN ShipSure.[dbo].[CRWRankCategory] rk ON rk.CCA_ID = cr.CCA_ID
	LEFT JOIN ShipSure.[dbo].CRWMovementTypes mt ON mt.STS_ID = cre.STS_ID