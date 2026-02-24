/****** Object:  View [ShipMgmt_Crewing].[Vessels In Crewing Mgmt]    Script Date: 08/03/2024 20:03:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [ShipMgmt_Crewing].[Vessels In Crewing Mgmt] AS 

WITH crew AS (

SELECT [Vessel ID] 
				         ,SUM([On Board]) AS [On Board]
						 ,SUM([On Board - Internal Supply]) AS [On Board - Internal Supply]
				  FROM [ShipMgmt_Crewing].[tCrewOnBoard]
				  WHERE CAST([Date] AS date) = CAST(GETDATE() AS date)
				  GROUP BY [Vessel ID]
)

, bottom AS (


SELECT c.[Vessel ID]
      ,c.[Expiry Date]
	  ,c.[End of Window Date]
      ,c.[Issue Date]
	  ,c.[Certificate Name] 
FROM [ShipMgmt_Certificates].tCertificate c 
WHERE c.[Certificate Name] IN ( 'Dry Dock - Special survey (bottom)', 'Dry Dock - Intermediate survey (bottom)')
AND c.IsActive = 1
AND c.Inactive = 'No'


)
, maxdate AS (


SELECT vm.[Vessel ID]
,MAX([Date]) AS [Date]
FROM [ShipMgmt_VesselMgmt].[tVesselMetricsPerDayNew] vm
INNER JOIN Reference_Vessel.tVessel v ON v.[Vessel ID] = vm.[Vessel ID]
WHERE vm.[Mgmt Status] NOT IN ('Fairplay', 'MOTO & MOCO offices', 'Deleted')
GROUP BY vm.[Vessel ID] 

)

SELECT DISTINCT smrc.[Vessel ID]
      ,smrc.[IMO]	
	  ,smrc.[COY ID]
	  ,smrc.[AUX]
	  ,smrc.[Company ID]
      ,smrc.[Official Number]
	  ,smrc.[Vessel]
      ,smrc.[Mgmt Status]	  
	  ,cc.[On Board] AS [Current Crew Count]
	  ,cc.[On Board - Internal Supply] AS [Current Crew Supplied]
	  ,smrc.[Mgmt Type]
	  ,smrc.[Mgmt Start]
	  ,smrc.[Mgmt End]
	  ,smrc.[Crew Service Record Count]
	  ,smrc.[Ship Mgmt Record Count]	  
	  ,smrc.[Mgmt Service Record Count]
	  ,smrc.[Business Office]
	  ,smrc.[Office Region]
	  ,smrc.[Reporting Office]
	  ,smrc.[Technical Office] AS [Tech Mgmt Office]
	  ,smrc.[Current Managing Director]
	  ,smrc.[HSEQ Mgr] AS [HSEQ Manager (DPA)]
	  ,smrc.[Responsible Office]
	  ,smrc.[Accounting Office]
	  ,smrc.[DOC Holding Office]
	  ,smrc.[Purchasing Office]
	  ,smrc.[Crew Planning Office]
	  ,smrc.[Fleet Name]
	  ,smrc.[Fleet Manager]
	  ,smrc.[Fleet Supt]
	  ,smrc.[Marine Supt]
	  ,smrc.[Vessel Business]
      ,smrc.[General Type Group]
      ,smrc.[Type Group]
      ,smrc.[Vessel Type]
      ,smrc.[Size Class]
	  ,smrc.[DWT (Summer)]
	  ,smrc.[Vessel Age]
      ,smrc.[Registered Owner]
	  ,smrc.[Group Effective Client]
	  ,smrc.[Client]
	  ,smrc.[Flag State]
	  ,smrc.[Class ID]
	  ,smrc.[Class Society]
	  ,smrc.[P&I Club]
      ,smrc.[Average Crew]
      ,smrc.[Built] AS [Built Yard]
	  ,smrc.[Built Date]
	  ,YEAR(smrc.[Built Date]) AS [Built Year]
	  ,MONTH(smrc.[Built Date]) AS [Built Month]
	  ,smrc.[Gross Tonnage (GT)] 
	  ,smrc.[Length]
	  ,smrc.[Beam]
	  ,smrc.[Type Of Hull]
	  ,smrc.[Main Engine Type]
      ,smrc.[Main Propulsion Type]
      ,smrc.[Call Sign]
	  ,smrc.[MMSI Number]
	  ,smrc.[Last Dry Dock Date]
      ,smrc.[Next Dry Dock Date]
	  ,bc.[Expiry Date] AS [Bottom Certificate Expiry]
      ,smrc.[Vessel Email]
	  ,resp.[Responsible Person]
	  ,smrc.[Company Cell]
FROM Reference_Vessel.tVesselCommon vc
	LEFT JOIN maxdate md ON md.[Vessel ID] = vc.[Vessel ID]
	LEFT JOIN (SELECT  vm.[Vessel ID]
				,vm.[Date]
				,vm.[Vessel]
				,vm.[Client]
				,vm.[COY ID]
				,vm.[AUX]
				,vm.[Days in Management]
				,vm.[Group Effective Client]
				,vm.[HSEQ Manager] AS [HSEQ Mgr]
				,vm.[Mgmt Type]
				,vm.[Mgmt Start]
				,vm.[Mgmt End]
				,v.[Crew Service Record Count]
				,v.[Ship Mgmt Record Count]	  
				,v.[Mgmt Service Record Count]
				,v.[DWT (Summer)]
				,v.[Official Number]
				,v.[Registered Owner]
				,v.[Flag State]
				,v.[Class ID]
				,v.[Class Society]
				,v.[Average Crew]
				,v.[Built]
				,v.[Built Date]
				,v.[Length]
				,v.[Beam]
				,v.[Gross Tonnage (GT)] 
				,v.[Type Of Hull]
				,v.[Main Engine Type]
				,v.[Main Propulsion Type]
				,v.[Call Sign]
				,v.[MMSI Number]
				,v.[Last Dry Dock Date]
				,v.[Next Dry Dock Date]
				,v.[Email] AS [Vessel Email]
				,v.[Vessel Picture]
				,vm.[Mgmt Status]
				,vm.IMO
				--,vm.Vessel
				--,vm.[Current Mgmt Type]
				,v.[P&I Club]
				,vm.[Company ID]
				,[Officer Nationality]
				,[Rating Nationality]
				,vm.[Primary Purchasing Contact] AS [Primary Procurement Contact]
				,[Vessel Business]
				,[General Type Group]
				,[Type Group]
				,[Vessel Type]
				,[Size Class]
				,vm.[Vessel Age]
				,vm.[Fleet Name]
				,vm.[Fleet Manager]
				,vm.[Fleet Supt]
				,vm.[Marine Supt]
				,vm.[Responsible Office] as [Business Office]
				,vm.[Technical Office]
				,vm.[Responsible Office]
				,vm.[Accounting Office]
				,vm.[Reporting Office]
				,vm.[DoC Office] AS [DOC Holding Office]
				,vm.[Purchasing Office]
				,vm.[Crewing Office] AS [Crew Planning Office]
				,vm.[Office Region]
				,vm.[Current Managing Director]
				,vm.[Company Cell]
			FROM [ShipMgmt_VesselMgmt].[tVesselMetricsPerDayNew] vm
				INNER JOIN Reference_Vessel.tVessel v ON v.[Vessel ID] = vm.[Vessel ID]
			WHERE vm.[Mgmt Status] NOT IN ('Fairplay', 'MOTO & MOCO offices', 'Deleted')) smrc ON smrc.[Vessel ID] = vc.[Vessel ID] AND smrc.[Date] = md.[Date]
  LEFT JOIN crew cc ON cc.[Vessel ID] = smrc.[Vessel ID]
  OUTER APPLY ( SELECT TOP (1) [Expiry Date] AS [Expiry Date]
				FROM bottom b
				WHERE b.[Vessel ID] = smrc.[Vessel ID]
				ORDER BY [Expiry Date] DESC) bc
	outer apply (SELECT TOP 1 [Responsible Person]
				FROM ShipMgmt_VesselMgmt.tShipMgmtRecordsResponsibilities resp_inner
				WHERE [Responsibility] = 'Crew Contact - CMP'
					and resp_inner.[Valid From] <= md.[Date]
					and ISNULL(resp_inner.[Valid To], GETDATE()) >= md.[Date]
					and resp_inner.[Vessel ID] = smrc.[Vessel ID]
				ORDER BY resp_inner.[Valid From] DESC
	) resp
WHERE [Mgmt Type] IN ('Full Management', 'Tech Mgmt', 'Crew Mgmt', 'TP Crew Supply', 'TP Crew Mgmt')
	AND ([Mgmt End] IS NULL OR [Mgmt End] > GETDATE()) AND [Mgmt Start] IS NOT NULL 
	AND CASE WHEN [Mgmt Type] IN ('Full Management', 'Tech Mgmt') AND smrc.[Technical Office] IS NOT NULL THEN 1
			WHEN [Mgmt Type] IN ('Crew Mgmt','TP Crew Supply', 'TP Crew Mgmt') THEN 1
			ELSE 0
			END = 1
GO

