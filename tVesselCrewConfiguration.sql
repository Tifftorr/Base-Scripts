SELECT *
FROM (

	SELECT

		VEC.VEC_ID as [Vessel Crew Configuration ID], --varchar
		VEC.VES_ID as [Vessel ID], --varchar
		VEC.VEC_PHLevel1FromWeeks as [Level 1 Planning Horizon Weeks From], --int
		VEC.VEC_PHLevel1ToWeeks as [Level 1 Planning Horizon Weeks To], --int
		VEC.VEC_PHLevel2FromWeeks as [Level 2 Planning Horizon Weeks From], --int
		VEC.VEC_PHLevel2ToWeeks as [Level 2 Planning Horizon Weeks To], --int
		VEC.VEC_PHLevel3FromWeeks as [Level 3 Planning Horizon Weeks From], --int
		VEC.VEC_PHLevel3ToWeeks as [Level 3 Planning Horizon Weeks To],--int
		VEC.VEC_NAN_BerthSpecific as [NAN Berth Specific], --bit
		VEC.VEC_UseNANProcess as [Using NAN Process], --bit
		VEC.VEC_NANExpiryDays as [NAN Expiry Days], --int
		VEC.VEC_NANWarningFlagDays as [NAN Warning Flag Days], --int
		VEC.VEC_CreatedOn as [Vessel Crew Configuration Created On], --datetime
		VEC.VEC_UpdatedBy as [Vessel Crew Configuration Updated By ID], --varchar
		USR.Usr_DisplayName as [Vessel Crew Configuration Updated By], --varchar long
		VEC.VEC_RestrictNAN as [NAN Restricted], --bit
		VEC.VEC_POP_DESC as [POP Description], --varchar
		VEC.VEC_ConsiderForOptimiser as [Consider for Optimizer], --bit
		VEC.[VEC_IsForwardPlanningApplicable] as [Is Forward Planning Applicable], --bit
		Att.[AttributeDesc] as [Payscale Requirement Type], --varchar
		Att2.[AttributeDesc] as [MGT], --varchar
		VEC.[VEC_IsPOEAPrintingEnable] as [Is POEA Printing Enabled], --bit
		VEC.[IsDebriefingEnabled] as [Is Debriefing Enabled], --btit
		VEC.[VEC_TravelDays] as [Travel Days], --int
		VEC.[CLI_IsVesselOSARequired] as [Is Vessel OSA Required], --bit
		VEC.[VEC_IsFly2cEnable] as [Is Fly2C Enabled], --bit
		VEC.VEC_Fly2cVesselName as [Fly2C Vessel Name], --varchar
		VEC.[VEC_ShowCBA] as [Show CBA], --bit
		VEC.VEC_IsLOCHighlightEnable as [Is LOC Highlight Enabled], --bit
		VEC.[VEC_IsTemporaryRankEnabled] as [Is Temporary Rank Enabled], --bit
		VEC.VEC_IsPersonalisedWagesEnabled as [Is Personalized Wages Enabled], --bit
		VEC.VEC_ExcludeTPAForWagescale as [Exclude TPA Enabled], --bit
		VEC.VEC_SignedContractMandatoryEnabled as [Signed Contract Mandatory Enabled], --bit
		VEC.[VEC_GanttChangeOBEndDate] as [Change OB End Date in Gantt View], --bit
		VEC.VEC_AllowSameDayPlanningForReliever as [Allow Same Day Planning for Reliever], --bit
		VEC.VEC_CBAMandatory as [CBA Mandatory], --bit
		VEC.VEC_ContractAttachmentMandatory as [Contract Attachment Mandatory], --bit
		VEC.VEC_APSValidateCrew as [APS Validated Crew],
		VEC.VEC_ReusePersonalisedWageScaleEnabled as [Reuse Personalized Wage Scale Enabled], --bit
		VEC.VEC_PersonalisedWageScaleThresholdMonth as [Personalized Wage Scale Threshold (Months)],
		VEC.VEC_TravelClusterId as [Travel Cluster ID],
		CPL.[CPL_Description] as [Travel Cluster],
		VEC.VES_TravelPIC as [Travel PIC ID],
		USR2.USR_DisplayName as [Travel PIC],
		VEC.VEC_IsBugetedBerthMobCellRestricted as [Is Budgeted Berth Mob Cell Restricted], --bit
		VEC.[VEC_CrewChangeSkipPreJoinChecks] as [Crew Change Skip Pre-Join Checks],
		VEC.VEC_CrewChangeShowReplan as [Crew Change Show Replan], --bit
		VEC.VEC_CrewChangeShowBacktoBackCrew as [Crew Change Back to Back Crew], --bit
		VEC.VEC_CrewChangeAddTravelDays as [Crew Change Add Travel Days], --bit
		VEC.VEC_CrewChangeAutoCreateLineup as [Crew Change Auto Create Lineup], --bit
		VEC.VEC_TravelTargetCost as [Travel Target Cost (USD)], --int
		ROW_NUMBER() OVER(PARTITION BY VEC.[ves_id] ORDER BY VEC.VEC_CreatedOn desc) as RN 

	FROM 
		shipsure..vesselcrewconfiguration VEC
		LEFT JOIN shipsure.[dbo].[USERID] USR on USR.[USR_ID] = VEC.[VEC_UpdatedBy]
		LEFT JOIN shipsure..attributedef Att ON Att.[BitValue] = VEC.VEC_WagesReqType AND Att.[TableName] = 'VesWageScaleReqType'
		LEFT JOIN shipsure..attributedef Att2 ON Att2.[BitValue] = VEC.SFC_Type AND Att2.[TableName] = 'SFC_TYPE'
		LEFT JOIN shipsure.[dbo].[CRWPool] CPL on CPL.[CPL_ID] = VEC.VEC_TravelClusterId and CPL.cpl_type = 7 and cpl.cpl_Cancelled = 0
		LEFT JOIN shipsure.[dbo].[USERID] USR2 on USR2.[USR_ID] = VEC.[VES_TravelPIC] ) FIN

WHERE 
	FIN.RN = 1