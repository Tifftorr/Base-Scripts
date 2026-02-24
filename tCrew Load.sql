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
    gsmob.SIT_Name AS [Mobilisation Office],
    gspl.SIT_Name AS [Planning Office],
    mob.CPL_Description as [Mobilisation Cell],
    rec.CPL_Description AS [Recruitment Cell],
    pl.CPL_Description AS [Planning Cell],
    CAN.CAN_FromDate AS [Available From Date],
    pd.rnk_id [Rank ID],
    pd.nat_id AS [Nationality ID],
    pd.crw_employmenttype AS [Crew Contract Type ID],
    mob.sit_id AS [Mobilising Office ID],
    pl.sit_id as [Planning Office ID],
    pd.CPL_ID [Mobilisation Cell ID],
    pd.CPL_ID_Recruiter AS [Recruitment Cell ID],
    pd.CPL_ID_PLAN AS [Planning Cell ID],
    pd.CPL_ID_CMP AS [CMP Cell ID],
    cmp.CPL_Description AS [CMP Cell],
    CASE WHEN pd.CRW_EmploymentType = 'VSHP00000003' then pd.CRW_EmploymentEntity END AS [Third Party Agent ID],
    CASE WHEN (pd.CRW_EmploymentType = 'VSHP00000003' AND pd.CRW_EmploymentEntity is NULL) THEN NULL 
         WHEN (pd.CRW_EmploymentType = 'VSHP00000003' AND pd.CRW_EmploymentEntity is NOT NULL) THEN CMP20.cmp_name END AS [Third Party Agent],
    pd.CRW_readyforpromotion AS [Is Ready For Promotion],
    pd.CRW_ShipManagementOff AS [Crew Ship Mgmt Office ID],
    coalesce(c.CMP_SHORTNAME, c.cmp_name) AS [Crew Ship Mgmt Office],
    pd.FLT_ID [Crew Fleet ID],
    flt.FLT_Desc [Crew Fleet],
    pd.CRW_OwnerPool  [Seafarer Client ID],
    CMP14.CMP_NAME AS [Seafarer Client],
    pd.CPD_PlanRestrictType AS [Pool Status ID],
    att.AttributeDesc [Pool Status],
	Recruiter_ID AS [Recruiter ID],
	UU.USR_DisplayName AS [Recruiter Name],
	CC.CMP_Name as [Recruiter Office],
	PD.CRW_EmployeeNo AS [Employee ID] ,
    PD.CRW_NID AS [Global ID],
	PD.crw_telephone4 as [Is Loyalty Eligible],
    Getdate() As ODPDate
FROM shipsure.dbo.CRWPersonalDetails pd (nolock)
              LEFT JOIN     shipsure.dbo.CRWPool mob (nolock)  on mob.cpl_id=pd.CPL_ID and mob.CPL_Cancelled = 0
              LEFT JOIN     shipsure.dbo.GLOBALSITE gsmob (nolock) on gsmob.sit_id = mob.sit_id
              LEFT JOIN     shipsure.dbo.CRWPool pl (nolock)  on pl.cpl_id=pd.CPL_ID_plan and pl.CPL_Cancelled = 0
              LEFT JOIN     shipsure.dbo.GLOBALSITE gspl (nolock) on gspl.sit_id = pl.sit_id
              LEFT JOIN     shipsure.dbo.CRWPool rec (nolock)  on rec.cpl_id=pd.CPL_ID_Recruiter and rec.CPL_Cancelled = 0
              LEFT JOIN shipsure.dbo.nationality n (nolock)  on n.nat_id=pd.NAT_ID        
              LEFT JOIN shipsure.dbo.country c2 (nolock)  on c2.CNT_ISOA2 = n.NAT_ISOA2 AND ISNULL(c2.[CNT_ACTIVE], 1) = 1  AND CNT_Desc <> 'SLOVAKIA2'
              LEFT JOIN shipsure.dbo.crwranks  rank (nolock)  on rank.rnk_id=pd.rnk_id
              LEFT JOIN shipsure..CRWSrvContractType sct ON sct.CCN_ID = pd.crw_employmenttype
              LEFT JOIN shipsure.dbo.CRWPool (nolock) cmp on cmp.CPL_ID = pd.CPL_ID_CMP
              LEFT JOIN COMPANY CMP20 (NOLOCK) ON CMP20.CMP_ID = PD.CRW_EmploymentEntity and cmp20.CMP_DELETED = 0 and cmp20.CMP_ID <> ' '
              OUTER APPLY (SELECT TOP 1 * 
                            FROM [Shipsure].[dbo].[CRWAvailabilityNotification] can_inner 
                            WHERE can_inner.CRW_ID = PD.CRW_ID
                            ORDER BY CAN_UpdatedOn DESC) CAN
              LEFT JOIN shipsure.dbo.COMPANY c on c.CMP_ID = pd.CRW_ShipManagementOff
              LEFT JOIN shipsure.dbo.FLEET flt (NOLOCK) ON flt.FLT_ID = pd.FLT_ID
              LEFT JOIN shipsure.dbo.COMPANY CMP14 (NOLOCK) ON CMP14.CMP_ID = PD.CRW_OwnerPool and CMP14.CMP_DELETED = 0
              LEFT JOIN shipsure.dbo.AttributeDef att (NOLOCK) ON att.BitValue = pd.CPD_PlanRestrictType AND att.tablename = 'PLAN_RESTRICT_TYPE'
			  LEFT JOIN Shipsure.dbo.USERID UU ON  UU.USR_ID=pd.Recruiter_ID
			  LEFT JOIN Shipsure.dbo.COMPANY CC ON CC.CMP_ID=UU.sit_id
WHERE pd.CRW_Cancelled = 0
