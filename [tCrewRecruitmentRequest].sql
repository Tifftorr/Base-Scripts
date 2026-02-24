SELECT [Request ID] = [REQ_ID]
	,[Rank ID] = [RNK_ID]
	,[Number of Berths] = [REQ_NumberOfBerths]
	,[Vessel ID] = [VES_ID]
	,[Berth ID] =[SVL_ID] 
	,[Nationality]= NAT.[NAT_DESCription]
	,[Request Raised By] = U.[USR_DisplayName]
	,[Planning Cell] = CP.[CPL_Description]
	,[Office] = GS.[SIT_NAME]
	,[Contract Length] =[REQ_ContractLengthValue]
	,[Contract Unit] = [REQ_ContractLengthUnit]
	,[Employment Type] = CT.[CCN_DESCRIPTION]
	,[Is US Visa Required] = [REQ_USVisa_Required]
	,[Date Received] = [REQ_DateReceived]  
	,[Is Request Critcal] =[REQ_CriticalRequirement]
	,[Request Status] = CASE WHEN [REQ_Status]= 10 THEN 'Draft'
							 WHEN [REQ_Status]= 20 THEN 'Sent To Recruitment'
							 WHEN [REQ_Status]= 30 THEN 'In Progress'
							 WHEN [REQ_Status]= 40 THEN 'Completed'
							 WHEN [REQ_Status]= 50 THEN 'Cancelled'
							 WHEN [REQ_Status]= 60 THEN 'Endorsed' END
	,[Assigned Recruiter] = U2.[USR_DisplayName]
	,[Request Created On]=[REQ_CreatedOn]
	,[Request Created By] = U1.[USR_DisplayName]
	,[REQ_SRM_USER_ID]
	,[Join Date] = [JoiningDate]
	,[Recruitment Cell]=CP1.[CPL_Description]
	,[Request ID Notes] =CR.[REQ_Notes]
	,[Request ID Sub Status]= AD.[AttributeName]
	,[Request ID Cancellation notes]=CR.[REQ_CancelNotes]
	,[Request Updated On] = CR.[REQ_UpdatedOn]
FROM 
	[Shipsure].[dbo].[CRWRequirement] CR
	LEFT JOIN  [Shipsure].[dbo].[attributedef] AD ON AD.BitValue=CR.REQ_SubStatus AND tablename ='CrewRequirementSubStatus'
	LEFT JOIN  [Shipsure].[dbo].[Nationality] NAT ON NAT.NAT_ID=CR.NAT_ID
	LEFT JOIN  [Shipsure].[dbo].[USERID] U ON U.USR_ID=CR.[REQ_RaisedByUserID]
	LEFT JOIN  [Shipsure].[dbo].[USERID] U1 ON U1.USR_ID=CR.[REQ_CreatedBy]
	LEFT JOIN  [Shipsure].[dbo].[USERID] U2 ON U2.USR_ID=CR.[REQ_AssignedRecruiter]
	LEFT JOIN  [Shipsure].[dbo].[Crwpool] CP ON CP.CPL_ID=CR.[CPL_ID]
	LEFT JOIN  [Shipsure].[dbo].[Crwpool] CP1 ON CP1.CPL_ID=CR.[REQ_CPL_ID_Recruitment]
	LEFT JOIN  [Shipsure].[dbo].[GlobalSite] GS ON GS.SIT_ID=CR.SIT_ID
	LEFT JOIN  [Shipsure].[dbo].[CRWSrvContractType] CT ON CT.CCN_ID=CR.CCN_ID
WHERE 
	CASE 
		WHEN (@{CONCAT('''',pipeline().parameters.DateFrom,'''')}!='NULL' OR @{CONCAT('''',pipeline().parameters.DateTo,'''')}!='NULL') 
		AND (CAST([REQ_CreatedOn] AS DATE) BETWEEN COALESCE(NULLIF(@{CONCAT('''',pipeline().parameters.DateFrom,'''')},''), '1900-01-01') 
		AND COALESCE(NULLIF(@{CONCAT('''',pipeline().parameters.DateTo,'''')},''), GETDATE())) 
			THEN 1
		WHEN @{CONCAT('''',pipeline().parameters.DateFrom,'''')}='NULL' AND @{CONCAT('''',pipeline().parameters.DateTo,'''')}='NULL' 
			THEN 1
		ELSE 0
		END = 1
