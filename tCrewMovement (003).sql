;WITH Onsigners as (

		
SELECT DISTINCT
	SD.[Crew ID],
	PD.[Crew PID] as PCN,
	SD.[Service Record ID],
	PD.[Crew Surname],
	PD.[Crew Name] as [Crew Forename],
	CASE WHEN SD.[Service Active Status ID] = 1 THEN 'Onboard'
		 WHEN SD.[Service Active Status ID] = 2 THEN 'History'
		 WHEN SD.[Service Active Status ID] = 3 THEN 'Planned'
		 ELSE 'Unmapped'
	END AS [Crew Movement Status],
	PD.[Nationality],
	PD.[Country Of Nationality],
	SD.[Start Date] as [Activity Date],
	SD.[Start Date],
	SD.[End Date],
	ISNULL(SD.[Rank], SD.[Rank Budgeted]) AS [Crew Rank],
	P.[Port Name] as [Load Port],
	CT.[Country Name] as [Load Port Country],
	SD.[Vessel ID],
	VMS.[Vessel Name],
	PD.[Mobilisation Cell],
	PD.[Planning Cell],
	pd.[CMP Cell],
	SGT.[SignOff Reason],
	'SignOn' [Action],
	RNK.[Rank],
	RNK.[Rank Category],
	RNK.[Rank Department],
	VMS.[Vessel Mgmt Type],
	Tech.[Office Name] as [Technical Office],
	VV.[Vessel Business] as [Sector],
	CL.[Company Name] as [Client],
	PD.[Crew Contract Type] AS [Contract Type],
	CMM.[Arrival Date],
	CMM.[Departure Date],
	CMM.[Destination From],
	CMM.[Destination To],
	CMM.[Booking Reference],
	CMM.[Travel Provider],
	CMM.[Booking Status],
	LNP.[Line Up ID],
	lnp.[Line Up Description],
	lnp.[Line Up Completed On],
	lnp.[Line Up Notes],
	lnp.[Line Up Created By],
	CMM.[Flight Details]

FROM [ShipMgmt_Crewing].[tCrewServiceRecords] SD (NOLOCK)
INNER JOIN [ShipMgmt_Crewing].[tCrew] PD (NOLOCK) ON PD.[Crew ID] = SD.[Crew ID]
LEFT JOIN [Reference_Position].[tPort] P (NOLOCK) ON P.[Port ID] = SD.[Load Port ID]
LEFT JOIN [Reference_Position].[tCountry] CT (NOLOCK) ON CT.[Country ID] = P.[Country ID]
OUTER APPLY (SELECT TOP (1) VMS.[Vessel Mgmt ID], VMS.[Vessel Name], VMS.[Vessel Mgmt Type], VMS.[Client ID]
				FROM [ShipMgmt_VesselMgmt].[tShipMgmtRecords] vms (nolock)  
				WHERE VMS.[Vessel ID] = SD.[Vessel ID]
					AND CAST(SD.[Start Date] as DATE) BETWEEN vms.[Mgmt Start] AND ISNULL(vms.[Mgmt End], GETDATE())					
				ORDER BY COALESCE(vms.[Mgmt Start], vms.[Purchasing Start Date]) DESC) VMS
LEFT JOIN [ShipMgmt_Crewing].[tCrewSignOffType] SGT (NOLOCK) ON SGT.[SignOff Reason ID] = SD.[Sign Off Reason ID]
LEFT JOIN [ShipMgmt_Crewing].[tCrewRanks] RNK (NOLOCK) ON RNK.[Rank ID] = SD.[Rank ID]
OUTER APPLY (SELECT TOP (1) Tech.[Office Name]
			 FROM [ShipMgmt_VesselMgmt].[tShipMgmtRecordsOffices] TECH
			 WHERE TECH.[Vessel Mgmt ID] = VMS.[Vessel Mgmt ID]
			 AND TECH.[Office Type] = 'Technical Office'
			 AND CAST(SD.[Start Date] as DATE) BETWEEN TECH.[Valid From] AND ISNULL(TECH.[Valid To], GETDATE())
			 ORDER BY TECH.[VALID FROM] DESC) Tech
LEFT JOIN [Reference_Vessel].[tVessel] VV ON VV.[Vessel ID] = SD.[VESSEL ID]
LEFT JOIN [Reference_BusinessStructure].[tCompany] CL ON CL.[Company ID] = VMS.[Client ID]
LEFT JOIN [ShipMgmt_Crewing].[tCrewTravelDetails] CMM ON CMM.[Service Record ID] = SD.[Service Record ID] AND CMM.[Travel Type] = 'Onsigner' and CMM.[Booking Status] = 'Issued'
LEFT JOIN [ShipMgmt_Crewing].[tCrewLineUps] LNP ON LNP.[Line Up ID] = SD.[Lineup ID Joiner]
WHERE SD.[Service Cancelled] = 0
	AND SD.[Previous Experience] = 0
	AND (SD.[Service Active Status ID] is null or SD.[Service Active Status ID] <> (3) )
	AND SD.[Status ID] in ('OB','OV')
	and SD.[Start Date] <= GETDATE()
	AND (SD.[Sign On Reason] IS NULL OR SD.[Sign On Reason] = 'Standard')

),

Offsigners AS (



SELECT DISTINCT
	SD.[Crew ID],
	PD.[Crew PID] as PCN,
	SD.[Service Record ID],
	PD.[Crew Surname],
	PD.[Crew Name] as [Crew Forename],
	CASE WHEN SD.[Service Active Status ID] = 1 THEN 'Onboard'
		 WHEN SD.[Service Active Status ID] = 2 THEN 'History'
		 WHEN SD.[Service Active Status ID] = 3 THEN 'Planned'
		 ELSE 'Unmapped'
	END AS [Crew Movement Status],
	PD.[Nationality],
	PD.[Country Of Nationality],
	SD.[End Date] as [Activity Date],
	SD.[Start Date],
	SD.[End Date],
	ISNULL(SD.[Rank], SD.[Rank Budgeted]) AS [Crew Rank],
	P.[Port Name] as [Load Port],
	CT.[Country Name] as [Load Port Country],
	SD.[Vessel ID],
	VMS.[Vessel Name],
	PD.[Mobilisation Cell],
	PD.[Planning Cell],
	pd.[CMP Cell],
	SGT.[SignOff Reason],
	'Signoff' [Action],
	RNK.[Rank],
	RNK.[Rank Category],
	RNK.[Rank Department],
	VMS.[Vessel Mgmt Type],
	Tech.[Office Name] as [Technical Office],
	VV.[Vessel Business] as [Sector],
	CL.[Company Name] as [Client],
	PD.[Crew Contract Type] AS [Contract Type],
	CMM.[Arrival Date],
	CMM.[Departure Date],
	CMM.[Destination From],
	CMM.[Destination To],
	CMM.[Booking Reference],
	CMM.[Travel Provider],
	CMM.[Booking Status],
	LNP.[Line Up ID],
	lnp.[Line Up Description],
	lnp.[Line Up Completed On],
	lnp.[Line Up Notes],
	lnp.[Line Up Created By],
	CMM.[Flight Details]

FROM [ShipMgmt_Crewing].[tCrewServiceRecords] SD (NOLOCK)
INNER JOIN [ShipMgmt_Crewing].[tCrew] PD (NOLOCK) ON PD.[Crew ID] = SD.[Crew ID]
LEFT JOIN [Reference_Position].[tPort] P (NOLOCK) ON P.[Port ID] = SD.[Disport ID]
LEFT JOIN [Reference_Position].[tCountry] CT (NOLOCK) ON CT.[Country ID] = P.[Country ID]
OUTER APPLY (SELECT TOP (1) VMS.[Vessel Mgmt ID], VMS.[Vessel Name], VMS.[Vessel Mgmt Type], VMS.[Client ID]
				FROM [ShipMgmt_VesselMgmt].[tShipMgmtRecords] vms (nolock)  
				WHERE VMS.[Vessel ID] = SD.[Vessel ID]
					AND CAST(SD.[End Date] as DATE) BETWEEN vms.[Mgmt Start] AND ISNULL(vms.[Mgmt End], GETDATE())					
				ORDER BY COALESCE(vms.[Mgmt Start], vms.[Purchasing Start Date]) DESC) VMS
LEFT JOIN [ShipMgmt_Crewing].[tCrewSignOffType] SGT (NOLOCK) ON SGT.[SignOff Reason ID] = SD.[Sign Off Reason ID]
LEFT JOIN [ShipMgmt_Crewing].[tCrewRanks] RNK (NOLOCK) ON RNK.[Rank ID] = SD.[Rank ID]
OUTER APPLY (SELECT TOP (1) Tech.[Office Name]
			 FROM [ShipMgmt_VesselMgmt].[tShipMgmtRecordsOffices] TECH
			 WHERE TECH.[Vessel Mgmt ID] = VMS.[Vessel Mgmt ID]
			 AND TECH.[Office Type] = 'Technical Office'
			 AND CAST(SD.[End Date] as DATE) BETWEEN TECH.[Valid From] AND ISNULL(TECH.[Valid To], GETDATE())
			 ORDER BY TECH.[VALID FROM] DESC) Tech
LEFT JOIN [Reference_Vessel].[tVessel] VV ON VV.[Vessel ID] = SD.[VESSEL ID]
LEFT JOIN [Reference_BusinessStructure].[tCompany] CL ON CL.[Company ID] = VMS.[Client ID]
LEFT JOIN [ShipMgmt_Crewing].[tCrewTravelDetails] CMM ON CMM.[Service Record ID] = SD.[Service Record ID] AND CMM.[Travel Type] = 'Offsigner' AND CMM.[Booking Status] = 'Issued'
LEFT JOIN [ShipMgmt_Crewing].[tCrewLineUps] LNP ON LNP.[Line Up ID] = SD.[Lineup ID Leaver]
WHERE SD.[Service Cancelled] = 0
	AND SD.[Previous Experience] = 0
	AND (SD.[Service Active Status ID] is null or SD.[Service Active Status ID] <> (3) )
	AND SD.[Status ID] in ('OB','OV')
	and SD.[End Date] <= GETDATE()
	AND SD.[Active Status] = 0
)

SELECT ons.*, GETDATE() AS [Date Updated in ODP]
FROM Onsigners ons
WHERE ([SignOff Reason] is null or [SignOff Reason]  not in ('Promotion', 'Transfer'))
	AND CASE 
				WHEN (@{CONCAT('''',pipeline().parameters.DateFrom,'''')}!='NULL' OR @{CONCAT('''',pipeline().parameters.DateTo,'''')}!='NULL') AND 
					(CAST([Start Date] AS DATE) BETWEEN COALESCE(NULLIF(@{CONCAT('''',pipeline().parameters.DateFrom,'''')},''), '1900-01-01') 
					AND COALESCE(NULLIF(@{CONCAT('''',pipeline().parameters.DateTo,'''')},''), GETDATE())) 
					THEN 1
				WHEN @{CONCAT('''',pipeline().parameters.DateFrom,'''')}='NULL' AND @{CONCAT('''',pipeline().parameters.DateTo,'''')}='NULL' 
					THEN 1
				ELSE 0
				END = 1

UNION

SELECT offs.*, GETDATE() AS [Date Updated in ODP]
FROM Offsigners offs
WHERE ([SignOff Reason] is null or [SignOff Reason]  not in ('Promotion', 'Transfer'))
	AND CASE 
			WHEN (@{CONCAT('''',pipeline().parameters.DateFrom,'''')}!='NULL' OR @{CONCAT('''',pipeline().parameters.DateTo,'''')}!='NULL') AND 
				(CAST([Start Date] AS DATE) BETWEEN COALESCE(NULLIF(@{CONCAT('''',pipeline().parameters.DateFrom,'''')},''), '1900-01-01') 
				AND COALESCE(NULLIF(@{CONCAT('''',pipeline().parameters.DateTo,'''')},''), GETDATE())) 
				THEN 1
			WHEN @{CONCAT('''',pipeline().parameters.DateFrom,'''')}='NULL' AND @{CONCAT('''',pipeline().parameters.DateTo,'''')}='NULL' 
				THEN 1
			ELSE 0
			END = 1