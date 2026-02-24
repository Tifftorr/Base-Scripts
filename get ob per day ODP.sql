     DECLARE @Date DATETIME
	 Declare @VesselIDInt varchar(12) = 'VGRP00018308'
	 DECLARE @DateInt DATE = '2023-11-12'

					/*SELECT cm.[Crew ID]
					        ,COALESCE(cm.[Rank], c.[Crew Rank]) AS [Rank]
							,rnk.[Start Date] AS [Rank Start Date]
					INTO #rank
					 FROM [ShipMgmt_Crewing].[Crew Movement] cm				  
                      INNER JOIN [ShipMgmt_Crewing].[tCrew] c ON c.[Crew ID] = cm.[Crew ID]					  
					 
					 LEFT JOIN (

                     SELECT ROW_NUMBER() OVER(PARTITION BY cm.[Crew ID], COALESCE(cm.[Rank], c.[Crew Rank]) ORDER BY cm.[Start Date] ASC ) AS RowId
					         ,cm.[Crew ID]
					        ,COALESCE(cm.[Rank], c.[Crew Rank]) AS [Rank]
							,cm.[Start Date]
					 FROM [ShipMgmt_Crewing].[Crew Movement] cm					  
                      INNER JOIN [ShipMgmt_Crewing].[tCrew] c ON c.[Crew ID] = cm.[Crew ID]					  
                      WHERE cm.[Activity Date] <= @DateInt
					  AND [Action] = 'SignOn' 

					  ) rnk ON rnk.[Crew ID] = cm.[Crew ID] AND rnk.[Rank] = COALESCE(cm.[Rank], c.[Crew Rank]) AND rnk.RowId = 1
					  WHERE cm.[Activity Date] <= @DateInt
					  AND [Action] = 'SignOn' */
					  
					SELECT DISTINCT cm.[Crew ID]
						  ,[Vessel ID]
						  ,COALESCE(cm.[Crew Contract Type], c.[Crew Contract Type]) AS [Contract Type]
						  ,[Action]
						  ,[Activity Date]
						  ,ROW_NUMBER() OVER (PARTITION BY cm.[Vessel ID], cm.[Crew ID] ORDER BY cm.[Activity Date] DESC) AS [Order] 
					  INTO #signonorder
					  FROM [ShipMgmt_Crewing].[Crew Movement] cm					  
                      INNER JOIN [ShipMgmt_Crewing].[tCrew] c ON c.[Crew ID] = cm.[Crew ID]
                      WHERE cm.[Activity Date] <= @DateInt
					  AND [Action] = 'SignOn'


					
					SELECT DISTINCT cm.[Crew ID]
						  ,[Vessel ID]
						  ,COALESCE(cm.[Crew Contract Type], c.[Crew Contract Type]) AS [Contract Type]
						  ,[Action]
						  ,[Activity Date]
						  ,ROW_NUMBER() OVER (PARTITION BY cm.[Vessel ID], cm.[Crew ID] ORDER BY cm.[Activity Date] DESC) AS [Order] 
					  INTO #signofforder
					  FROM [ShipMgmt_Crewing].[Crew Movement] cm						  
                      INNER JOIN [ShipMgmt_Crewing].[tCrew] c ON c.[Crew ID] = cm.[Crew ID]
                      WHERE cm.[Activity Date] <= @DateInt
					  AND [Action] = 'SignOff'


	SELECT DISTINCT 
		   @DateInt AS [Date]
	      ,smrc.[Vessel ID] AS [Vessel ID]
		  ,IMO
		  ,smrc.[Vessel Mgmt ID]
		  ,CASE WHEN smrc.[Technical Office ID] IS NULL THEN 'Unmapped'
		        ELSE smrc.[Technical Office ID]
				END AS [Tech Mgmt Office ID]
		  --,CASE WHEN smrc.[Reporting Office ID] IS NULL THEN 'Unmapped'
		  --      ELSE smrc.[Reporting Office ID]
		  --		END AS [Reporting Office ID]
		  --,COALESCE(smrc.[Technical Office ID], smrc.[Reporting Office ID], 'Unmapped') AS [ShipSure Mapping Office ID]
		  ,CASE WHEN smrc.[Client ID] IS NULL THEN 'Unmapped'
		        ELSE smrc.[Client ID]
				END AS [Client ID]
		  ,[Finance Vessel Grouping]
		  ,cm.[Crew ID] 
		  --,COALESCE(cm.[Crew Rank], c.[Crew Rank]) AS [Rank]
		  --,r.[Rank Start Date]
		  --,DATEDIFF(Day,r.[Rank Start Date], @DateInt) AS [Time In Rank (Days)]
		  --,CONVERT(decimal(18,2),DATEDIFF(Day,r.[Rank Start Date], @DateInt))/365 AS [Time In Rank (Years)]
		  ,soo.[Contract Type] AS [Crew Supply Type]
		  --,[Crew Count]
		  ,CASE WHEN sof.[Activity Date] > soo.[Activity Date] AND sof.[Activity Date] <= @DateInt THEN 0
	        WHEN soo.[Activity Date] <= @DateInt THEN 1
			ELSE 0
			END AS [On Board]
		  ,CASE WHEN smrc.[Vessel ID] IS NOT NULL THEN 1
		        ELSE 0
				END AS [InMgmt]
		  ,c.[Crew Surname]
		  ,c.[Crew PID]
		  ,smrc.[Vessel]

	--INTO #kpis
	FROM [ShipMgmt_Crewing].[Crew Movement] cm							  
    INNER JOIN [ShipMgmt_Crewing].[tCrew] c ON c.[Crew ID] = cm.[Crew ID]
	LEFT JOIN #signonorder soo ON soo.[Crew ID] = cm.[Crew ID] AND soo.[Vessel ID] = cm.[Vessel ID] AND soo.[Order] = 1
    LEFT JOIN #signofforder sof ON sof.[Crew ID] = cm.[Crew ID] AND sof.[Vessel ID] = cm.[Vessel ID] AND sof.[Order] = 1
	
		      /*OUTER APPLY (
			  
			     SELECT TOP (1) *
				 FROM #rank r 
				 WHERE r.[Crew ID] = cm.[Crew ID]
				 ORDER BY r.[Rank Start Date] DESC
				 ) r*/

	INNER JOIN ( SELECT DISTINCT smrc1.[Vessel ID]
		  ,smrc1.[Vessel Mgmt ID]
		  ,smrc1.[IMO]
		  --,vc.[Current Mgmt Type]
		  --,smrc1.[Reporting Office ID]
		  --,COALESCE(bgo.[Business Office], bgo2.[Business Office]) AS [Business Office]
		  ,smrc1.[Technical Office ID]
		  --,smrc1.[Fleet ID]
		  ,smrc1.[Client ID]
		  --,vc.[Vessel Business]
		  --,vc.[Type Group] 
		  --,vfg.[Finance Vessel Grouping]
		  ,smrc1.[Vessel type] as [Finance Vessel Grouping]
		  ,smrc1.Vessel
	      FROM [ShipMgmt_VesselMgmt].tVesselMetricsPerDayNew smrc1
		  --LEFT JOIN [Reference_BusinessStructure].[tOfficeCommon] oc ON oc.[Office ID] = smrc1.[Technical Office ID] AND oc.[Office Type ID] = 'GLAS00000005' 
          INNER JOIN [ShipMgmt_VesselMgmt].tShipMgmtRecords smrc On smrc.[Vessel Mgmt ID] = smrc1.[Vessel Mgmt ID]
          --INNER JOIN [Reference_Vessel].tVessel vc ON vc.[Vessel ID] = smrc1.[Vessel ID]
		  --LEFT JOIN [Reference_Vessel].[tVesselFinanceGrouping] vfg ON vfg.[Type Group] = vc.[Type Group]

		 /* LEFT OUTER JOIN (
								SELECT DISTINCT o.[Office ID]
									  ,bgo.[Business Office]
									  ,o.Office
								FROM [Reference_BusinessStructure].tOfficeCommon o
								LEFT OUTER JOIN [Reference_BusinessStructure].[tBusinessOfficeMapping] bgo ON bgo.[Responsible Office] = o.Office
								WHERE o.[Office Type ID] = 'GLAS00000010'

		  ) bgo ON bgo.[Office ID] = smrc1.[Reporting Office ID]*/
		  /*LEFT OUTER JOIN (
								SELECT DISTINCT o.[Office ID]
									  ,bgo.[Business Office]
									  ,o.Office
								FROM [Reference_BusinessStructure].tOfficeCommon o
								LEFT OUTER JOIN [Reference_BusinessStructure].[tBusinessOfficeMapping] bgo ON bgo.[Responsible Office] = o.Office
								WHERE o.[Office Type ID] = 'GLAS00000005'
								AND bgo.[Business Office] IS NOT NULL

		  ) bgo2 ON bgo2.[Office ID] = smrc1.[Technical Office ID]*/

		 WHERE smrc1.[Mgmt Status] NOT IN ('Fairplay', 'MOTO & MOCO offices', 'Deleted')
		  AND smrc1.[Mgmt Type] IN ('Full Management', 'Tech Mgmt')
		   --AND CASE WHEN smrc1.[Mgmt Type] IN ('Full Management', 'Tech Mgmt') AND smrc1.[Technical Office ID] IS NOT NULL THEN 1
           --WHEN smrc1.[Mgmt Type] IN ('Crew Mgmt','TP Crew Supply', 'TP Crew Mgmt') THEN 1
		   --ELSE 0
		   --END = 1
		  and Smrc1.[Date] = @DateInt
		  ) smrc ON smrc.[Vessel ID] = cm.[Vessel ID]
	WHERE cm.[Activity Date] <= @DateInt
	AND cm.[Activity Date] >= DATEADD(year, -1, @DateInt)
	and smrc.[Vessel ID] = @VesselIDInt
	and CASE WHEN sof.[Activity Date] > soo.[Activity Date] AND sof.[Activity Date] <= @DateInt THEN 0
	        WHEN soo.[Activity Date] <= @DateInt THEN 1
			ELSE 0
			END = 1

DROP TABLE #signofforder
DROP TABLE #signonorder
--DROP TABLE #kpis