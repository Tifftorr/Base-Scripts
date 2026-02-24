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


SELECT 
MAX([Date]) AS [Date]

FROM [ShipMgmt_VesselMgmt].[tVesselMetricsPerDayNew] vm
WHERE vm.[Mgmt Status] NOT IN ('Fairplay', 'MOTO & MOCO offices', 'Deleted')
)

SELECT DISTINCT smrc.[Vessel ID]
      ,smrc.[IMO]	
	  ,smrc.[COY ID]
	  ,smrc.[AUX]
	  ,smrc.[Company ID]
      ,v.[Official Number]
	  ,smrc.[Vessel]
      ,smrc.[Mgmt Status]	  
	  ,cc.[On Board] AS [Current Crew Count]
	  ,cc.[On Board - Internal Supply] AS [Current Crew Supplied]
	  ,smrc.[Mgmt Type]
	  ,smrc.[Mgmt Start]
	  ,smrc.[Mgmt End]
	  ,v.[Crew Service Record Count]
	  ,v.[Ship Mgmt Record Count]	  
	  ,v.[Mgmt Service Record Count]
	  ,smrc.[Responsible Office] as [Business Office]
	  ,smrc.[Office Region]
	  ,smrc.[Reporting Office]
	  ,smrc.[Technical Office] AS [Tech Mgmt Office]
	  ,smrc.[Current Managing Director]
	  ,smrc.[HSEQ Manager] AS [HSEQ Manager (DPA)]
	  ,smrc.[Responsible Office]
	  ,smrc.[Accounting Office]
	  ,smrc.[DoC Office] as [DOC Holding Office]
	  ,smrc.[Purchasing Office]
	  ,smrc.[Crewing Office] as [Crew Planning Office]
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
      ,v.[Registered Owner]
	  ,smrc.[Group Effective Client]
	  ,smrc.[Client]
	  ,v.[Flag State]
	  ,v.[Class ID]
	  ,v.[Class Society]
	  ,v.[P&I Club]
      ,v.[Average Crew]
      ,v.[Built] AS [Built Yard]
	  ,v.[Built Date]
	  ,YEAR(v.[Built Date]) AS [Built Year]
	  ,MONTH(v.[Built Date]) AS [Built Month]
	  ,v.[Gross Tonnage (GT)] 
	  ,v.[Length]
	  ,v.[Beam]
	  ,v.[Type Of Hull]
	  ,v.[Main Engine Type]
      ,v.[Main Propulsion Type]
      ,v.[Call Sign]
	  ,v.[MMSI Number]
	  ,v.[Last Dry Dock Date]
      ,v.[Next Dry Dock Date]
	  ,bc.[Expiry Date] AS [Bottom Certificate Expiry]
      ,v.Email as [Vessel Email]
	 ,resp.[Responsible Person]
	  ,smrc.[Company Cell]
FROM [ShipMgmt_VesselMgmt].[tVesselMetricsPerDayNew] smrc
left JOIN Reference_Vessel.tVessel v ON v.[Vessel ID] = smrc.[Vessel ID]
inner join maxdate md on md.Date = smrc.Date
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

WHERE smrc.[Mgmt Type] IN ('Full Management', 'Tech Mgmt', 'Crew Mgmt', 'TP Crew Supply', 'TP Crew Mgmt')
	AND (smrc.[Mgmt End] IS NULL OR smrc.[Mgmt End] > GETDATE()) AND smrc.[Mgmt Start] IS NOT NULL 
	
	AND CASE WHEN smrc.[Mgmt Type] IN ('Full Management', 'Tech Mgmt') /*AND smrc.[Technical Office] IS NOT NULL*/ THEN 1
			WHEN smrc.[Mgmt Type] IN ('Crew Mgmt','TP Crew Supply', 'TP Crew Mgmt') THEN 1
			ELSE 0
			END = 1

GO