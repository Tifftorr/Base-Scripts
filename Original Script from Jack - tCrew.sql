       	declare @sDateTime as date
       select @sDateTime = '01-Jan-2017'	
	   
	   
	   select distinct pd.CRW_ID as [Crew ID],
										pd.crw_pid AS [Crew PID],
										rank.rnk_description AS [Crew Rank],
										pd.crw_forename AS [Crew Name],
											pd.crw_surname AS [Crew Surname],
											crw_dob AS [DOB],
											crw_Gender AS [Gender],
										n.NAT_Description AS [Nationality],
										c2.[CNT_Desc] AS [Country Of Nationality],
										sct.CCN_Description AS [Crew Contract Type],
                                         cp.CMP_Name as [Mobilisation Office],
										 cp1.CMP_Name as [Planning Office],
										  mob.CPL_Description as [Mobilisation Cell],
										  rec.CPL_Description AS [Recruitment Cell],
										 pl.CPL_Description as [Planning Cell],
										 BINARY_CHECKSUM(pd.CRW_ID,
										pd.crw_pid,
										rank.rnk_description,
										pd.crw_forename,
											pd.crw_surname,
											crw_dob,
											crw_Gender,
										n.NAT_Description,
										c2.[CNT_Desc],
										sct.CCN_Description,
                                         cp.CMP_Name,
										 cp1.CMP_Name,
										  mob.CPL_Description,
										 pl.CPL_Description) AS [ChnageIdentifier]
                 from shipsure.dbo.CRWPersonalDetails pd (nolock)
              --INNER join   shipsure.dbo.CRWSrvDetail sd (nolock) on pd.CRW_ID=sd.CRW_ID and pd.CRW_Cancelled=0
              LEFT join     shipsure.dbo.company cp (nolock)  on cp.cmp_id=pd.CRW_CrewManagementOff
			  LEFT join     shipsure.dbo.company cp1 (nolock)  on cp1.cmp_id=pd.CRW_SecondedOffice 
			  LEFT join     shipsure.dbo.CRWPool mob (nolock)  on mob.cpl_id=pd.CPL_ID
			  LEFT join     shipsure.dbo.CRWPool pl (nolock)  on pl.cpl_id=pd.CPL_ID_plan
			  LEFT join     shipsure.dbo.CRWPool rec (nolock)  on rec.cpl_id=pd.CPL_ID_Recruiter
			  LEFT join shipsure.dbo.nationality n (nolock)  on n.nat_id=pd.NAT_ID		  
			  LEFT JOIN shipsure.dbo.country c2 (nolock)  on c2.CNT_ISOA2 = n.NAT_ISOA2 AND ISNULL(c2.[CNT_ACTIVE], 1) = 1  AND CNT_Desc <> 'SLOVAKIA2'
			  LEFT join shipsure.dbo.crwranks  rank (nolock)  on rank.rnk_id=pd.rnk_id	
			  LEFT JOIN CRWSrvContractType sct ON sct.CCN_ID = pd.crw_employmenttype
              WHERE pd.CRW_Cancelled = 0
            --AND pd.CRW_ID = 'VGR300044068'