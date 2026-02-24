USE [vgroup-onedata-preview]
GO

/****** Object:  View [ShipMgmt_Crewing].[Crew Current Status]    Script Date: 19/08/2024 10:05:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [ShipMgmt_Crewing].[Crew Current Status] AS


    -- Summarize vessel data -- verver 1.0
    WITH AV AS (
        SELECT
            sr.[Vessel Mgmt ID] as [Vessel Mgmt ID],
            v.[Vessel ID],
            sr.[Vessel Mgmt Type] as [Mgmt Type],
            sr.[Mgmt Status],
            smrc.[Client] AS [Vessel Client],
			sr.[Vessel Name] as [Vessel],
            smrc.[Vessel Business] AS [Segment],
            smrc.[General Type Group],
            COALESCE(smrc.[Vessel Type],v.[Vessel Type]) as [Vessel Type],
            smrc.[Fleet Name],
            smrc.[Technical Office]
        FROM Reference_Vessel.tVessel v
		INNER JOIN [ShipMgmt_VesselMgmt].[tShipMgmtRecords] sr ON sr.[Vessel ID] = v.[Vessel ID]
        LEFT JOIN [ShipMgmt_VesselMgmt].[tVesselMetricsPerDayNew] smrc
            ON smrc.[Vessel ID] = v.[Vessel ID]
            AND smrc.[Date] = (
                SELECT MAX([Date])
                FROM [ShipMgmt_VesselMgmt].[tVesselMetricsPerDayNew]
                WHERE [Vessel ID] = v.[Vessel ID]
                    AND [Mgmt Status] NOT IN ('Fairplay', 'MOTO & MOCO offices', 'Deleted')
            )
        WHERE sr.[Mgmt Status] NOT IN ('Fairplay', 'Deleted', 'MOTO & MOCO offices')
		--and v.[Vessel ID]='VGR400027403'

    ),

    -- GET LAST VESSEL
    LV AS (
        SELECT *
        FROM (
            SELECT DISTINCT
                [Crew ID],
                SR.[Vessel ID] AS [Last Vessel ID],
                [Start Date] AS [Last Vessel Sign On Date],
                [End Date] AS [Last Vessel Sign Off Date],
                VSRM.[Vessel Mgmt ID] AS [Last Vessel Vessel Mgmt ID],
                VSRM.[Vessel] AS [Last Vessel],
                VSRM.[Mgmt Type],
                VSRM.[Vessel Client],
                [Segment],
                VSRM.[General Type Group],
                VSRM.[Vessel Type],
                VSRM.[Fleet Name],
                VSRM.[Technical Office],
                DENSE_RANK() OVER (
                    PARTITION BY [Crew ID]
                    ORDER BY [Start Date] DESC, [Service Record Updated On], [service record id] DESC
                ) AS LV
            FROM [ShipMgmt_Crewing].[tCrewServiceRecords] SR
            LEFT JOIN AV VSRM ON VSRM.[Vessel Mgmt ID] = SR.[Vessel Mgmt ID] AND VSRM.[Vessel ID] = SR.[Vessel ID]
            WHERE [Service Active Status ID] = 2
                AND SR.[Active Status] = 0
                AND [Service Cancelled] = 0
                AND [Status ID] = 'OB'
                AND [Previous Experience] = 0
                AND [Sign Off Reason ID] IS NOT NULL
                AND [End Date] >= DATEADD(YEAR, -15, GETDATE())
        ) AA
        WHERE LV = 1
    ),

    -- GET NEXT PLANNED VESSEL
    NV AS (
        SELECT *
        FROM (
            SELECT DISTINCT
                [CREW ID],
				SR.[Service Record ID],
                [Planning Status],
                SR.[Vessel ID] AS [Next Vessel ID],
                [Start Date] AS [Plan To Join],
                SR.[Vessel Mgmt ID] AS [Next Vessel Vessel Mgmt ID],
                VSRM.[Vessel],
                VSRM.[Mgmt Type],
                VSRM.[Vessel Client],
                [Segment],
                VSRM.[General Type Group],
                VSRM.[Vessel Type],
                VSRM.[Fleet Name],
                VSRM.[Technical Office],
                DENSE_RANK() OVER (
                    PARTITION BY [Crew ID]
                    ORDER BY [Start Date], [Service Record Updated On] ASC
                ) AS LV
            FROM [ShipMgmt_Crewing].[tCrewServiceRecords] SR
            LEFT JOIN AV VSRM ON VSRM.[Vessel Mgmt ID] = SR.[Vessel Mgmt ID] AND VSRM.[Vessel ID] = SR.[Vessel ID]
            WHERE [Active Status] = 0
                AND [Service Active Status ID] = 3
                AND [Service Cancelled] = 0
                AND [Status ID] = 'OB'
                AND [Sign Off Reason ID] IS NULL
                AND SR.[Vessel ID] IS NOT NULL
                AND [Crew ID] IS NOT NULL
                AND [Planning Status ID] IN (
                    'VSHP00000001', 'VSHP00000002', 'VSHP00000004', 'VSHP00000011', 'VSHP00000013'
                )
                AND [Start Date] >= GETDATE() - 90
        ) AA
        WHERE LV = 1
    ),

    -- V.Ships services
    TCS AS (
        SELECT
            [Crew ID],
            COUNT([Service Record ID]) AS [Vships Service Count]
        FROM [ShipMgmt_Crewing].[tCrewServiceRecords]
        WHERE ([Service Active Status ID] IS NULL OR [Service Active Status ID] <> 3)
            AND [Active Status] = 0
            AND [Service Cancelled] = 0
            AND [Previous Experience] = 0
            AND [Status ID] IN ('OB', 'OV')
            AND [Vessel ID] IS NOT NULL
        GROUP BY [Crew ID]
    ),

    -- Last Contact Details
    CDO AS (
        SELECT 
            UN.[CREW ID], 
            UN.[CONTACT DATE], 
            DENSE_RANK() OVER (PARTITION BY UN.[CREW ID] ORDER BY UN.[CONTACT DATE] DESC) [Contact Date Order]
        FROM (
            SELECT [CREW ID], CAST([CONTACT DATE] AS DATE) AS [CONTACT DATE]
            FROM [ShipMgmt_Crewing].[tCrewContacts]
            WHERE YEAR([CONTACT DATE]) >= YEAR(GETDATE()) - 5
            UNION ALL
            SELECT [CREW ID], CAST([Debriefing Updated On] AS DATE) AS [CONTACT DATE]
            FROM [ShipMgmt_Crewing].[tCrewDebriefing]
            WHERE YEAR([Debriefing Updated On]) >= YEAR(GETDATE()) - 5
            UNION ALL
            SELECT [CREW ID], CAST([Briefing Date] AS DATE) AS [CONTACT DATE]
            FROM [ShipMgmt_Crewing].[tCrewJoiningBriefing] CJB
            INNER JOIN [ShipMgmt_Crewing].[tCrewServiceRecords] CSR ON CSR.[Service Record ID] = CJB.[Linked Service Record ID]
            WHERE [Was Briefing Done by Office] = 1 AND YEAR([Briefing Date]) >= YEAR(GETDATE()) - 5
        ) AS UN
    )

 SELECT DISTINCT
        [Crew].[Crew ID],
        [Crew].[Crew PID] AS [PCN],
        [Crew].[Crew Name],
        [Crew].[Crew Surname],
        [Crew].[DOB],
		SERV.[Service Record ID] as [Current Service Record ID],
        Ranks.[Rank ID],
        SERV.[Berth ID],
        NV.[Service Record ID] as [Planning Service Record ID],
        DATEDIFF(YEAR, [CREW].[DOB], GETDATE()) AS [Age],
        CASE WHEN [Crew].[Gender] = 'M' THEN 'Male' ELSE 'Female' END AS [Gender],
        [Crew].[Nationality],
        [RANKS].[Rank] as [Crew Rank],
        [RANKS].[Rank Category],
        [RANKS].[Rank Department],
        ISNULL([CREW].[Crew Contract Type], 'Internal Supply') AS [Supply Type],
        [Third Party Agent],
        [Pool Status],
        COALESCE(C2.[Company Shortname],C2.[Company Name]) as [Mobilisation Office],
        COALESCE(C1.[Company Shortname],C1.[Company Name]) as [Planning Office],
		CASE WHEN SERV.[Status ID] = 'OB' OR NV.[Planning Status] IS NOT NULL THEN COALESCE(VSRM.[Technical Office], NV.[Technical Office]) 
		ELSE COALESCE(C.[Company Shortname],C.[Company Name]) END AS [Technical Office],
        [Mobilisation Cell],
        [Recruitment Cell],
        [Planning Cell],
        [CMP Cell],
        CASE WHEN [CREW].[Is Ready For Promotion] = 1 THEN 'Yes' ELSE 'No' END AS [Is Ready For Promotion],
        SERV.[Status] as [Current Status],
        SERV.[Start Date] AS [Current Status Start Date],
        SERV.[End Date] AS [Current Status End Date],
		CREW.[Available From Date] AS [Availability],
        DATEDIFF(DAY, [SERV].[Start Date], [SERV].[End Date]) AS [Actual Service Days],
        DATEDIFF(DAY, [SERV].[Start Date], GETDATE()) AS [Current Service Days],
               CASE WHEN [SERV].[Service Contract Length Unit] = 'M' THEN [Service Contract Days] * 30
            WHEN [SERV].[Service Contract Length Unit] = 'W' THEN [Service Contract Days] * 7
            ELSE [Service Contract Days] END AS [Contract Days],
        'D' AS [Contract Unit],
        CASE WHEN [Extension Unit] = 'M' THEN [Extension Days] * 30
            WHEN [Extension Unit] = 'W' THEN [Extension Days] * 7
            ELSE [Extension Days] END AS [Extension],
        'D' AS [Extension Unit],
        DATEDIFF(DAY, GETDATE(), [SERV].[End Date]) + 1 AS [Days Remaining],
        CAST(
            DATEADD(
                DAY,
                CASE WHEN [SERV].[Service Contract Length Unit] = 'M' THEN [Service Contract Days] * 30
                    WHEN [SERV].[Service Contract Length Unit] = 'W' THEN [Service Contract Days] * 7
                    ELSE [SERV].[Service Contract Days] END,
                [SERV].[Start Date]
            ) + 1 AS DATE
        ) AS [Contract End Date],
        VSRM.[Vessel] AS [Current Vessel],
        NV.[Vessel] AS [Planned Vessel],
        NV.[Plan To Join],
        NV.[Planning Status],
		CDO.[Contact Date] AS [Last Contact Date],
        LV.[Last Vessel],
		LV.[Vessel Client] as [Last Client],
		LV.[Last Vessel Sign On Date],
        LV.[Last Vessel Sign Off Date],
        TCS.[Vships Service Count] AS [V.Ships Contracts],
        CASE WHEN SERV.[Status ID] = 'OB' OR NV.[Planning Status] IS NOT NULL THEN COALESCE(VSRM.[Fleet Name], NV.[Fleet Name]) ELSE CREW.[Crew Fleet] END AS [Fleet],
        CASE WHEN SERV.[Status ID] = 'OB' OR NV.[Planning Status] IS NOT NULL THEN COALESCE(VSRM.[Vessel Client], NV.[Vessel Client]) ELSE CREW.[Seafarer Client] END AS [Client],
        CASE WHEN SERV.[Status ID] = 'OB' OR NV.[Planning Status] IS NOT NULL THEN COALESCE(VSRM.[Mgmt Type], NV.[Mgmt Type]) ELSE LV.[Mgmt Type] END AS [Management Type],
        CASE WHEN SERV.[Status ID] = 'OB' OR NV.[Planning Status] IS NOT NULL THEN COALESCE(VSRM.[Segment], NV.[Segment]) ELSE LV.[Segment] END AS [Segment],
		CASE WHEN SERV.[Status ID] = 'OB' OR NV.[Planning Status] IS NOT NULL THEN COALESCE(VSRM.[Vessel Type], NV.[Vessel Type]) ELSE LV.[Vessel Type] END AS [Vessel Type],
		CASE WHEN SERV.[Status] in('ONBOARD')  then 'ONBOARD' WHEN SERV.[Planning Status] is not null then 'PLANNED' when [Last Vessel] is not null then 'LAST VESSEL' ELSE 'Open' end as [Seafarer Status],
		PP.[Promotion Record ID] as [Assessed Promotion Record ID],
		PP1.[Promotion Record ID] AS [Approved Promotion Record ID],


        CASE WHEN MT.[Status Valid Search] = 1 THEN 'Active Search Status' ELSE 'Inactive Search Status' END AS [Service Search Status],
        CASE WHEN RANKS.[Rank Is Supernumerary] = 0 AND RANKS.[Rank Department] NOT IN ('Supernumeray OB','Supernumeraries') 
		AND  (MT.[Status Valid Search] = 1 OR NV.[Planning Status] IS NOT NULL) AND (SERV.[Status ID] = 'OB' OR NV.[Planning Status] IS NOT NULL OR [Vships Service Count] > 0) 
		AND SERV.[End Date] > GETDATE() - 360 THEN 'Active' ELSE 'Inactive' END AS [Crew Pool Status],
		SERV.[Service Active Status]
    FROM [ShipMgmt_Crewing].[tCrew] CREW
    INNER JOIN [ShipMgmt_Crewing].[tCrewServiceRecords] SERV ON SERV.[Crew ID] = CREW.[Crew ID] 
	AND SERV.[Service Record Updated On] = (
        SELECT MAX([Service Record Updated On]) 
        FROM [ShipMgmt_Crewing].[tCrewServiceRecords] 
        WHERE [Crew ID] = SERV.[Crew ID] and [Active Status] = 1 AND [Service Cancelled]=0 AND ([Vessel ID] IS NULL OR [Vessel ID] not IN ('GLAX00012386', 'GLAT00000027'))
    )
    INNER JOIN [ShipMgmt_Crewing].[tCrewMovementTypes] MT ON MT.[Status ID] = SERV.[Status ID]
    INNER JOIN [ShipMgmt_Crewing].[tCrewRanks] RANKS ON RANKS.[Rank ID] = COALESCE( CREW.[Rank ID],SERV.[Rank ID Budgeted])
	LEFT JOIN CDO ON CDO.[CREW ID] = SERV.[Crew ID] AND CDO.[Contact Date Order]=1
    LEFT JOIN NV NV ON NV.[Crew ID] = CREW.[Crew ID]
    LEFT JOIN LV LV ON LV.[Crew ID] = CREW.[Crew ID]
    LEFT JOIN TCS TCS ON TCS.[Crew ID] = CREW.[Crew ID]
    LEFT JOIN AV VSRM ON VSRM.[Vessel Mgmt ID] = SERV.[Vessel Mgmt ID] AND VSRM.[Vessel ID] = SERV.[Vessel ID]
	LEFT JOIN [Reference_BusinessStructure].[tCompany] c ON C.[Company ID] = CREW.[Crew Ship Mgmt Office ID]
	LEFT JOIN [Reference_BusinessStructure].[tCompany] c1 ON C1.[Company ID] = CREW.[Planning Office ID] 
    LEFT JOIN [Reference_BusinessStructure].[tCompany] c2 ON C2.[Company ID] = CREW.[Mobilising Office ID]
	LEFT JOIN [ShipMgmt_Crewing].[tCrewPromotion] PP ON PP.[Crew ID] =CREW.[Crew ID] AND PP.[promotion status] in ('Assessment Passed') AND PP.[Is Promotion Record Deleted]=0 and PP.[Is Crew Excluded from Promotion]=0 AND PP.[Crew Current Rank ID]=CREW.[Rank ID] 
	LEFT JOIN [ShipMgmt_Crewing].[tCrewPromotion] PP1 ON PP1.[Crew ID] =CREW.[Crew ID] AND PP1.[promotion status] in ('Approved') AND PP1.[Is Promotion Record Deleted]=0 and PP1.[Is Crew Excluded from Promotion]=0 AND PP1.[Crew Current Rank ID]=CREW.[Rank ID]
    WHERE SERV.[Active Status] = 1
        AND SERV.[Service Cancelled] = 0
        AND (SERV.[Vessel ID] IS NULL OR SERV.[Vessel ID] NOT IN ('GLAX00012386', 'GLAT00000027'))
        AND ([Planning Cell] IS NULL OR [Planning Cell] NOT LIKE '%TEST%')
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique Identifier for the crew' , @level0type=N'SCHEMA',@level0name=N'ShipMgmt_Crewing', @level1type=N'VIEW',@level1name=N'Crew Current Status', @level2type=N'COLUMN',@level2name=N'Crew ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Current Status of Active Crew including onshore and onbaord' , @level0type=N'SCHEMA',@level0name=N'ShipMgmt_Crewing', @level1type=N'VIEW',@level1name=N'Crew Current Status'
GO


