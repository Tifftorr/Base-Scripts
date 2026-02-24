SELECT
	ETT.ETT_ID as [Cloud Entity Scanned ID],
	ETT.FK_MATCHED_ID as [FK Matched ID],
	ETT.ETX_ID as [Cloud Documents Extension ID],
	ETT.ETT_SEQUENCE as [Sequence],
	ETT.ETT_FileName as [File Name],
	ETT.ETT_Desc as [Linked Description],
	ETT.ETT_Size as [File Size],
	ETT.ETT_Reference_2 as [Reference 2 ID],
	DSG.[DSG_CAPTION] as [Reference 2 Type],
	att.[AttributeDesc] as [Cloud Status],
	ETT.ETT_Scan_SIT_ID as [Scanned Office ID],
	usr.USR_DisplayName as [Updated By],
	ETT.[ETT_UpdateOn] as [Updated On],
	usr2.[USR_DisplayName] as [Created By],
	ETT.[ETT_CreatedOn] as [Created On],
	ETT.[Ves_ID] as [Vessel ID],
	ETT.[Crw_ID] as [Crew ID],
	ETT.[CMP_ID] as [CMP ID],
	ETT.[Coy_ID] as [Coy ID],
	ETT.[Bud_ID] as [Budget ID]
	
FROM 
	shipsure.dbo.CLOUD_ENTITY_SCANNED ETT
	LEFT JOIN shipsure..attributedef att on att.[BitValue] = ETT.[CloudStatus] and att.[TableName] = 'CloudStatus'
	LEFT JOIN shipsure.[dbo].[CRWDocScannedGroup] DSG on DSG.DSG_ID = ETT.ETT_Reference_2
	LEFT JOIN [dbo].[USERID] usr on usr.[USR_ID] = ett.[ett_updateby]
	LEFT JOIN [dbo].[USERID] usr2 on usr2.[USR_ID] = ett.[ett_createdby]

WHERE ETT.ETT_Cancelled = 0