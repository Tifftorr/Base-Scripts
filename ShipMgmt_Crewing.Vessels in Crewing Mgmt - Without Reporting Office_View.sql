/****** Object:  View [ShipMgmt_Crewing].[Vessels In Crewing Mgmt - Without Reporting Office]    Script Date: 29/02/2024 18:25:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [ShipMgmt_Crewing].[Vessels In Crewing Mgmt - Without Reporting Office]
AS 

WITH crew AS (

SELECT [Vessel ID] 
				         ,SUM([On Board]) AS [On Board]
						 ,SUM([On Board - Internal Supply]) AS [On Board - Internal Supply]
				  FROM [ShipMgmt_Crewing].[tCrewOnBoard]
				  WHERE CAST([Date] AS date) = CAST(GETDATE() AS date)
				  GROUP BY [Vessel ID]
)

,lastsignon AS (




    SELECT [Vessel ID]
         ,MAX([Activity Date]) AS [Last SignOn]
  FROM [ShipMgmt_Crewing].[tCrewMovement]
  WHERE [Action] = 'SignOn'
  GROUP BY [Vessel ID]

)


,lastsignoff AS (

  SELECT [Vessel ID]
         ,MAX([Activity Date]) AS [Last SignOff]
  FROM [ShipMgmt_Crewing].[tCrewMovement]
  WHERE [Action] = 'SignOff'
  GROUP BY [Vessel ID]


)

, overayear AS (

  SELECT DISTINCT [Vessel ID]
         ,DATEDIFF(month, [SET_StartDate], ISNULL([SET_EndDate], GETDATE())) AS [Length]
  FROM [ShipMgmt_Crewing].[tCrewMovement]
  WHERE DATEDIFF(month, [SET_StartDate], [SET_EndDate]) > 12


)
, maxdate AS (


SELECT vm.[Vessel ID]
,MAX([Date]) AS [Date]
FROM [ShipMgmt_VesselMgmt].[tVesselMetricValuesPerDay] vm
INNER JOIN Reference_Vessel.tVessel v ON v.[Vessel ID] = vm.[Vessel ID]
WHERE vm.[Mgmt Status] NOT IN ('Fairplay', 'MOTO & MOCO offices', 'Deleted')
GROUP BY vm.[Vessel ID] 

)

, extmgr AS (


SELECT DISTINCT [Office ID]
FROM Reference_BusinessStructure.tOfficeCommon 
WHERE EXTMGR = 1

)

SELECT DISTINCT 
	smrc.[Vessel ID]
	,smrc.[Vessel Mgmt ID]
	,smrc.[Technical Office ID]
	,smrc.[Reporting Office ID]
	,smrc.[IMO]	
	,smrc.[COY ID]
	--,smrc.[AUX]
	--,smrc.[Company ID]  
	--,smrc.[Official Number]
	,smrc.[Vessel]
	,smrc.[Mgmt Status]	  
	,cc.[On Board] AS [Current Crew Count]
	,cc.[On Board - Internal Supply] AS [Current Crew Supplied]
	,lso.[Last SignOn]
	,lsof.[Last SignOff]
	,CASE WHEN oay.[Length] IS NOT NULL THEN 1
		ELSE 0
		END AS [Had Contract Over 1 Year]
	,smrc.[Mgmt Type]
	--,smrc.[Current Mgmt Type]
	,smrc.[Mgmt Start]
	,smrc.[Mgmt End]
	  
	,smrc.[Crew Service Record Count]
	,smrc.[Ship Mgmt Record Count]	  
	,smrc.[Mgmt Service Record Count]

	--,smrc.[Business Office]
	,smrc.[Office Region]
	,smrc.[Reporting Office]
	,smrc.[Technical Office] AS [Tech Mgmt Office]
	,smrc.[Current Managing Director] AS [Current Managing Director]
	,smrc.[Responsible Office]
	--,smrc.[Accounting Office]
	,smrc.[DOC Holding Office]

	,smrc.[Fleet Name]
	,smrc.[Fleet Manager]
	,smrc.[Fleet Supt]
	,smrc.[Marine Supt]

	,smrc.[Vessel Business]
	,smrc.[General Type Group]
	,smrc.[Type Group]
	,smrc.[Vessel Type]
	--,smrc.[Size Class]
	--,smrc.[DWT (Summer)]
	  
	--,smrc.[Registered Owner]
	,smrc.[Group Effective Client]
	,smrc.[Client]

	,smrc.[Flag State]
	--,smrc.[Class Society]
	,smrc.[Average Crew]

	--,smrc.[Built]
	--,smrc.[Type Of Hull]
	--,smrc.[Main Engine Type]
	--,smrc.[Main Propulsion Type]

	--,smrc.[Call Sign]
	--,smrc.[MMSI Number]
	--,smrc.[Next Dry Dock Date]
	--,smrc.[Vessel Email]
	
				,e.[Office ID]
  FROM Reference_Vessel.tVesselCommon vc
  LEFT JOIN maxdate md ON md.[Vessel ID] = vc.[Vessel ID]
  LEFT JOIN (

  SELECT  vm.[Vessel ID]
  	,vm.[Vessel Mgmt ID]
	,vm.[Technical Office ID]
	,vm.[Reporting Office ID]
	,vm.[IMO]
				,vm.[Date]
				,vm.[Vessel]
				,vm.[Client]
				,vm.[COY ID]
				--,vm.[AUX]
				,vm.[Days in Management]
				,vm.[Group Effective Client]
				--,vm.[HSEQ Manager] AS [HSEQ Mgr]
				,vm.[Mgmt Type]
				,vm.[Mgmt Start]
				,vm.[Mgmt End]

				,v.[Crew Service Record Count]
				,v.[Ship Mgmt Record Count]	  
				,v.[Mgmt Service Record Count]
			   -- ,v.[DWT (Summer)]
				--,v.[Official Number]
	  
			  --,v.[Registered Owner]

			  ,v.[Flag State]
			  --,v.[Class ID]
			  --,v.[Class Society]
			  ,v.[Average Crew]

			  --,v.[Built]
			  --,v.[Built Date]
			  --,v.[Length]
			  --,v.[Beam]
			  --,v.[Gross Tonnage (GT)] 

			  --,v.[Type Of Hull]
			  --,v.[Main Engine Type]
			  --,v.[Main Propulsion Type]

			  --,v.[Call Sign]
			  --,v.[MMSI Number]
			  --,v.[Last Dry Dock Date]
			  --,v.[Next Dry Dock Date]
			  --,v.[Email] AS [Vessel Email]
			  
	--,v.[Vessel Picture]
				,vm.[Mgmt Status]
				--,vm.IMO
				--,vm.Vessel
				--,vm.[Mgmt Type]
	          --,v.[P&I Club]
			  --,vm.[Company ID]
				

				--,[Officer Nationality]
                --,[Rating Nationality]
			     --,vm.[Primary Purchasing Contact] AS [Primary Procurement Contact]

				,[Vessel Business]
				,[General Type Group]
				,[Type Group]
				,[Vessel Type]
				--,[Size Class]
				,vm.[Vessel Age]

				,vm.[Fleet Name]
				,vm.[Fleet Manager]
				,vm.[Fleet Supt]
				,vm.[Marine Supt]
				,vm.[Technical Office]
				,vm.[Responsible Office]
				,vm.[Reporting Office]
				,vm.[DoC Office] AS [DOC Holding Office]
				,vm.[Purchasing Office]
				,vm.[Crewing Office] AS [Crew Planning Office]
				,vm.[Office Region]
				,vm.[Current Managing Director]

FROM [ShipMgmt_VesselMgmt].[tVesselMetricsPerDayNew] vm
INNER JOIN Reference_Vessel.tVessel v ON v.[Vessel ID] = vm.[Vessel ID]
WHERE vm.[Mgmt Status] NOT IN ('Fairplay', 'MOTO & MOCO offices', 'Deleted')
  ) smrc ON smrc.[Vessel ID] = vc.[Vessel ID] AND smrc.[Date] = md.[Date]
  LEFT JOIN crew cc ON cc.[Vessel ID] = smrc.[Vessel ID]
  LEFT JOIN lastsignon lso ON lso.[Vessel ID] = smrc.[Vessel ID]
  LEFT JOIN lastsignoff lsof ON lsof.[Vessel ID] = smrc.[Vessel ID]
  LEFT JOIN overayear oay ON oay.[Vessel ID] = smrc.[Vessel ID]
  LEFT JOIN extmgr e ON e.[Office ID] = smrc.[Technical Office ID]
  WHERE [Mgmt Type] IN ('Full Management', 'Tech Mgmt', 'Crew Mgmt','TP Crew Supply', 'TP Crew Mgmt')
  AND ([Mgmt End] IS NULL OR CAST([Mgmt End] AS DATE) > '2019-01-01') AND [Mgmt Start] IS NOT NULL 
  AND CASE WHEN [Mgmt Type] IN ('Full Management', 'Tech Mgmt') AND smrc.[Technical Office] IS NOT NULL THEN 1
           WHEN [Mgmt Type] IN ('Crew Mgmt','TP Crew Supply', 'TP Crew Mgmt') THEN 1
		   ELSE 0
		   END = 1
  AND CASE WHEN e.[Office ID] IS NOT NULL AND [Technical Office] IS NOT NULL AND [Reporting Office] IS NULL THEN 1
           WHEN e.[Office ID] IS NULL AND COALESCE([Technical Office], [Reporting Office]) IS NULL THEN 1
		   ELSE 0
		   END = 1


GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IMO is a unique seven-digit ship identification number which remains unchanged through a vessel’s lifetime' , @level0type=N'SCHEMA',@level0name=N'ShipMgmt_Crewing', @level1type=N'VIEW',@level1name=N'Vessels In Crewing Mgmt - Without Reporting Office', @level2type=N'COLUMN',@level2name=N'IMO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Number of Crew currently signed on to the Vessel using ShipSure application' , @level0type=N'SCHEMA',@level0name=N'ShipMgmt_Crewing', @level1type=N'VIEW',@level1name=N'Vessels In Crewing Mgmt - Without Reporting Office', @level2type=N'COLUMN',@level2name=N'Current Crew Count'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Number of Crew supplied by V.Ships currently signed on to the Vessel using ShipSure application' , @level0type=N'SCHEMA',@level0name=N'ShipMgmt_Crewing', @level1type=N'VIEW',@level1name=N'Vessels In Crewing Mgmt - Without Reporting Office', @level2type=N'COLUMN',@level2name=N'Current Crew Supplied'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The business office within V.Group' , @level0type=N'SCHEMA',@level0name=N'ShipMgmt_Crewing', @level1type=N'VIEW',@level1name=N'Vessels In Crewing Mgmt - Without Reporting Office', @level2type=N'COLUMN',@level2name=N'Business Office'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DOC Holding Office refers to an Office that holds the Document of Compliance or DOC that is issued to a company based on the type of ship they own.' , @level0type=N'SCHEMA',@level0name=N'ShipMgmt_Crewing', @level1type=N'VIEW',@level1name=N'Vessels In Crewing Mgmt - Without Reporting Office', @level2type=N'COLUMN',@level2name=N'DOC Holding Office'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Maritime Mobile Service Identity (MMSI) numbers are a series of nine digits used to uniquely identify a DSC radio or a group of DSC radios on a vessel
' , @level0type=N'SCHEMA',@level0name=N'ShipMgmt_Crewing', @level1type=N'VIEW',@level1name=N'Vessels In Crewing Mgmt - Without Reporting Office', @level2type=N'COLUMN',@level2name=N'MMSI Number'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email used to contact the vessel' , @level0type=N'SCHEMA',@level0name=N'ShipMgmt_Crewing', @level1type=N'VIEW',@level1name=N'Vessels In Crewing Mgmt - Without Reporting Office', @level2type=N'COLUMN',@level2name=N'Vessel Email'
GO