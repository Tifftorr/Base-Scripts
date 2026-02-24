SELECT DISTINCT
	POT.POT_ID as [Crew Pool Team ID],
	POT.CPL_ID as [Crew Pool ID],
	CPL.CPL_Description as [Crew Pool Description],
	CPL.CPL_Type as [Crew Pool Type ID],
	CPT.CPT_Description as [Crew Pool Type],
	POT.USR_ID as [Crew Pool Team User ID],
	USR.USR_DisplayName as [User Display Name],
	USR.USR_Email as [User Email Address],
	POT.POT_Manager as [Cell Manager],
	POT.POT_MemberRole as [Member Role ID],
	CASE 
		WHEN CPL.CPL_Type = 1 THEN atd.AttributeDesc
		WHEN CPL.CPL_Type = 6 THEN ATD1.AttributeDesc
		WHEN CPL.CPL_Type not in (1,6) THEN ATD2.AttributeDesc
	END AS [Member Role],
	POT.POT_Default as [Default Cell],
	POT.POT_DisplayAsContact as [Display as Contact]
FROM 
	shipsure.[dbo].[CRWPoolTeam] POT
	LEFT JOIN shipsure.[dbo].[CRWPool] CPL ON CPL.[CPL_ID] = POT.CPL_ID AND CPL.CPL_Cancelled = 0
	LEFT JOIN shipsure.[dbo].[CRWPoolType] CPT on CPT.CPT_ID = CPL.CPL_Type
	LEFT JOIN shipsure..USERID USR ON USR.USR_ID = POT.USR_ID AND USR.USR_DELETED = 0
	LEFT JOIN shipsure..AttributeDef ATD ON ATD.BitValue = POT.POT_MemberRole AND ATD.TableName = 'CrewCell' AND ATD.AttributeName <> 'SRM' -- connection for Mobilsation Cell
	LEFT JOIN shipsure..AttributeDef ATD1 ON ATD1.BitValue = POT.POT_MemberRole AND ATD1.TableName = 'CrewCell' AND Atd1.AttributeName <> 'DOCV' -- connection for Recruitment Cell
	LEFT JOIN shipsure..AttributeDef ATD2 ON ATD2.BitValue = POT.POT_MemberRole AND ATD2.TableName = 'CrewCell' -- connection for Rest of cell types
WHERE
	POT.POT_Cancelled = 0