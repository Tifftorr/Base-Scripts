--tCrew

       	declare @sDateTime as date
       select @sDateTime = '01-Jan-2017'	
	   
SELECT DISTINCT 
	pd.CRW_ID as [Crew ID],
	pd.crw_pid AS [Crew PID],
	pd.rnk_id [Rank ID],
	rank.rnk_description AS [Crew Rank],
	pd.crw_forename AS [Crew Name],
	pd.crw_surname AS [Crew Surname],
	pd.crw_dob AS [DOB],
	pd.crw_Gender AS [Gender],
	pd.nat_id as [Nationality ID],
	n.NAT_Description AS [Nationality],
	c2.[CNT_Desc] AS [Country Of Nationality],
	pd.crw_employmenttype [Crew Contract Type ID],
	sct.CCN_Description AS [Crew Contract Type],
	pd.CRW_CrewManagementOff [Mobilising Office ID],
    cp.CMP_Name as [Mobilisation Office],
	pd.CRW_SecondedOffice as [Planning Office ID],
	cp1.CMP_Name as [Planning Office],
	pd.CPL_ID [Mobilisation Cell ID],
	mob.CPL_Description as [Mobilisation Cell],
	pd.CPL_ID_Recruiter as [Recruitment Cell ID],
	rec.CPL_Description AS [Recruitment Cell],
	pd.CPL_ID_PLAN as [Planning Cell ID],
	pl.CPL_Description as [Planning Cell],
	pd.CPL_ID_CMP [CMP Cell ID],
	cmp.CPL_Description as [CMP Cell],
	pd.CRW_3rdPartyAgent as [TPA Agent ID],

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
              LEFT join     shipsure.dbo.company cp (nolock)  on cp.cmp_id=pd.CRW_CrewManagementOff and cp.CMP_DELETED = 0
			  LEFT join     shipsure.dbo.company cp1 (nolock)  on cp1.cmp_id=pd.CRW_SecondedOffice and cp.CMP_DELETED = 0
			  LEFT join     shipsure.dbo.CRWPool mob (nolock)  on mob.cpl_id=pd.CPL_ID and mob.CPL_Cancelled = 0
			  LEFT join     shipsure.dbo.CRWPool pl (nolock)  on pl.cpl_id=pd.CPL_ID_plan and pl.CPL_Cancelled = 0
			  LEFT join     shipsure.dbo.CRWPool rec (nolock)  on rec.cpl_id=pd.CPL_ID_Recruiter and rec.CPL_Cancelled = 0
			  LEFT join shipsure.dbo.nationality n (nolock)  on n.nat_id=pd.NAT_ID		  
			  LEFT JOIN shipsure.dbo.country c2 (nolock)  on c2.CNT_ISOA2 = n.NAT_ISOA2 AND ISNULL(c2.[CNT_ACTIVE], 1) = 1  AND CNT_Desc <> 'SLOVAKIA2'
			  LEFT join shipsure.dbo.crwranks  rank (nolock)  on rank.rnk_id=pd.rnk_id
			  LEFT JOIN shipsure..CRWSrvContractType sct ON sct.CCN_ID = pd.crw_employmenttype
			  LEFT JOIN shipsure.dbo.CRWPool (nolock) cmp on cmp.CPL_ID = pd.CPL_ID_CMP
              WHERE pd.CRW_Cancelled = 0