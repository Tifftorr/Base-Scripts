--tCrew

       DECLARE @sDateTime AS DATE
       SELECT @sDateTime = '01-Jan-2017'	
	   
SELECT DISTINCT
	pd.CRW_ID AS [Crew ID],
	pd.crw_pid AS [Crew PID],
	rank.rnk_description AS [Crew Rank],
	pd.crw_forename AS [Crew Name],
	pd.crw_surname AS [Crew Surname],
	cast(pd.crw_dob as date) AS [DOB],
	pd.crw_Gender AS [Gender],
	n.NAT_Description AS [Nationality],
	c2.[CNT_Desc] AS [Country Of Nationality],
	sct.CCN_Description AS [Crew Contract Type],
    cp.CMP_Name AS [Mobilisation Office],
	cp1.CMP_Name AS [Planning Office],
	mob.CPL_Description as [Mobilisation Cell],
	rec.CPL_Description AS [Recruitment Cell],
	pl.CPL_Description AS [Planning Cell],
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
					rec.CPL_Description,
					pl.CPL_Description,
					pd.rnk_id,
					pd.nat_id,
					pd.crw_employmenttype,
					pd.CRW_CrewManagementOff,
					pd.CRW_SecondedOffice,
					pd.CPL_ID,
					pd.CPL_ID_Recruiter,
					pd.CPL_ID_PLAN,
					pd.CPL_ID_CMP,
					cmp.CPL_Description,
					pd.CRW_3rdPartyAgent
					) AS [ChangeIdentifier],
	pd.rnk_id [Rank ID],
	pd.nat_id AS [Nationality ID],
	pd.crw_employmenttype AS [Crew Contract Type ID],
	pd.CRW_CrewManagementOff AS [Mobilising Office ID],
	pd.CRW_SecondedOffice AS [Planning Office ID],
	pd.CPL_ID [Mobilisation Cell ID],
	pd.CPL_ID_Recruiter AS [Recruitment Cell ID],
    pd.CPL_ID_PLAN AS [Planning Cell ID],
	pd.CPL_ID_CMP AS [CMP Cell ID],
	cmp.CPL_Description AS [CMP Cell],
	CASE WHEN pd.CRW_EmploymentType = 'VSHP00000003' THEN pd.CRW_EmploymentEntity END AS [Third Party Agent ID],
	CASE WHEN (pd.CRW_EmploymentType = 'VSHP00000003' AND pd.CRW_EmploymentEntity is NULL) THEN NULL 
		 WHEN (pd.CRW_EmploymentType = 'VSHP00000003' AND pd.CRW_EmploymentEntity is NOT NULL) THEN CMP20.cmp_name END AS [Third Party Agent]
	
FROM shipsure.dbo.CRWPersonalDetails pd (NOLOCK)
              LEFT join     shipsure.dbo.company cp (NOLOCK)  ON cp.cmp_id=pd.CRW_CrewManagementOff and cp.CMP_DELETED = 0
			  LEFT join     shipsure.dbo.company cp1 (NOLOCK)  ON cp1.cmp_id=pd.CRW_SecondedOffice and cp.CMP_DELETED = 0
			  LEFT join     shipsure.dbo.CRWPool mob (NOLOCK)  ON mob.cpl_id=pd.CPL_ID and mob.CPL_Cancelled = 0
			  LEFT join     shipsure.dbo.CRWPool pl (NOLOCK)  ON pl.cpl_id=pd.CPL_ID_plan and pl.CPL_Cancelled = 0
			  LEFT join     shipsure.dbo.CRWPool rec (NOLOCK)  ON rec.cpl_id=pd.CPL_ID_Recruiter and rec.CPL_Cancelled = 0
			  LEFT join shipsure.dbo.nationality n (NOLOCK)  ON n.nat_id=pd.NAT_ID		  
			  LEFT JOIN shipsure.dbo.country c2 (NOLOCK)  ON c2.CNT_ISOA2 = n.NAT_ISOA2 AND ISNULL(c2.[CNT_ACTIVE], 1) = 1  AND CNT_Desc <> 'SLOVAKIA2'
			  LEFT join shipsure.dbo.crwranks  rank (NOLOCK)  ON rank.rnk_id=pd.rnk_id
			  LEFT JOIN shipsure..CRWSrvContractType (NOLOCK) sct ON sct.CCN_ID = pd.crw_employmenttype
			  LEFT JOIN shipsure.dbo.CRWPool (NOLOCK) cmp on cmp.CPL_ID = pd.CPL_ID_CMP
			  LEFT JOIN COMPANY CMP20 (NOLOCK) ON CMP20.CMP_ID = PD.CRW_EmploymentEntity and cmp20.CMP_DELETED = 0 and cmp20.CMP_ID <> ' '
WHERE pd.CRW_Cancelled = 0