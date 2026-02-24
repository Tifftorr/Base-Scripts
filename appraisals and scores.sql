
---APPRAISALS
	

select		aa.CAH_ID, pd.CRW_ID, aa.ves_id, aa.SET_ID_Appraisee, CRW_Surname AS SEAFARER, rnk_description as Rank,  cca_description as RankCategory, dep_name as Department, crw_pid as PCN,
			nat_description as Nationality,
			cpl.cpl_Description as PlanPool, gs.sit_name as PlanningOffice,  
			cpl1.CPL_Description as CMP_CELL,
			gs1.SIT_Name as CMP_OFFICE,
			CAST(AA.CAH_ReportDate AS DATE) AS REPORT_dATE,
			aal.AAL_Name as Status , aa.CAH_IsAgreedBySeaferer,
			rv.CMR_ReviewDate as MidTermReview, [CMR_CreatedOn] as MidTermCreated
			,CJB_BreifingDate , CJB_CreatedOn, aa.CAH_ReviewedOn, uu.USR_DisplayName as ReviewedBy,
			case 
			when CAH_ReviewedOn is not null and datediff(day, AA.CAH_ReportDate, CAH_ReviewedOn) > 0 then datediff(day, AA.CAH_ReportDate, CAH_ReviewedOn) 
			when CAH_ReviewedOn is not null then 0 -- for some reason data is negative - very small number, set to 0
			else 0 end as DaysToReview,
			case when CAH_ApparisalSource = 1 then 'Superintendent' else 'Vessel' end as AppraisalType
			, CASE WHEN SR.SET_ActiveStatus=0 THEN 'Signed Off' ELSE 'Onboard' end as SeafarerStatus
			,SET_StartDate as SignOnDate
			, SET_EndDate as SignOffDate
			, CASE WHEN  CAH_IsConsiderForPromotion =1 then 'Yes' else 'No' end as RecomendedforPromotion,
			ISNULL(CL.SVL_JOBCODE,'UNKNOWN') as JobCode,
			ISNULL(CL.CEN_ID,'UNKNOWN') as CostCentre,
			ISNULL( CRW_OldID ,'UNKNOWN') as EmployeeID
			, aa.CAH_ReviewerComment
into		#appraisal
from		CRWOBAppraisal aa (NOLOCK)
--inner join	#TMPVES vv (NOLOCK) on vv.VES_ID = aa.VES_ID 
INNER JOIN	CRWPersonalDetails PD (NOLOCK) ON PD.CRW_ID = AA.CRW_ID_Appraisee 
INNER JOIN Shipsure.dbo.CRWSrvDetail SR ON SR.SET_ID=aa.SET_ID_Appraisee
LEFT JOIN CRWCLVesCrewList CL ON CL.SVL_ID=SR.SVL_ID
inner join  NATIONALITY nat (NOLOCK) on nat.NAT_ID = pd.NAT_ID 
inner join	crwranks rnk (NOLOCK) on rnk.RNK_ID = aa.RNK_ID_Appraisee 
inner join  CRWRankCategory cca (NOLOCK) on cca.CCA_ID = rnk.CCA_ID
inner join shipsure..DEPARTMENT dep on dep.dep_id=rnk.DEP_ID
inner join	CRWAppraisalAttributeLookup  aal (NOLOCK) on aal.AAL_ID = aa.AAL_ID_Status 
left join	crwpool cpl (NOLOCK) on cpl.cpl_id = pd.CPL_ID_PLAN
left join	globalsite gs on gs.SIT_ID = cpl.SIT_ID 
left join	crwpool cpl1 (NOLOCK) on cpl1.cpl_id = pd.CPL_ID_CMP
left join	globalsite gs1 on gs1.SIT_ID = cpl1.SIT_ID 
left join	[dbo].[CRWOBCrewMidTermReview] rv (NOLOCK) on rv.SET_ID_Reviewee = aa.SET_ID_Appraisee and [CMR_IsDeleted] = 0
left join	[dbo].[CRWOBJoiningBrief] br (NOLOCK) on br.SET_ID  = aa.SET_ID_Appraisee and [CJB_IsDeleted] = 0 and (CJB_IsAddedInOffice is null or CJB_IsAddedInOffice = 0)
left join   userid uu (NOLOCK) on uu.usr_id = aa.CAH_ReviewedBy
WHERE		AA.CAH_IsDeleted = 0

	
--AVERAGE SCORE

		/****** Script for SelectTopNRows command from SSMS  ******/
			SELECT distinct 'New'as 'Source', REPORT_DATE,
					ap.crw_id, aa.CAH_ID,
					CAST(ROUND(AVG(cast(cc.ASL_Value as decimal(5,2))), 0, 0) as int) as AverageScore
				into #AverageResults
			  FROM #appraisal ap 
			  INNER JOIN [Shipsure].[dbo].[CRWOBAppraisalItem] aa (NOLOCK) on aa.CAH_ID=ap.CAH_ID
			  inner join dbo.CRWAppraisalItemDetail  bb (NOLOCK) on bb.AID_ID = aa.AID_ID 
			  inner join CRWAppraisalScale cc (NOLOCK) on cc.asl_id = bb.ASL_ID
			  
			  where aa.CAI_IsDeleted = 0 and bb.AID_IsDeleted = 0 --and ap.CRW_ID='VGR400054499'
			  group by ap.crw_id, aa.[CAH_ID],REPORT_DATE
			  order by crw_id

---ALL SCORES
/****** Script for SelectTopNRows command from SSMS  ******/
			SELECT distinct 'New'as 'Source', REPORT_DATE,
					ap.crw_id, aa.CAH_ID, bb.aid_id,
					ASL_Value
			into #ALL_SCORES
			  FROM #appraisal ap 
			  INNER JOIN [Shipsure].[dbo].[CRWOBAppraisalItem] aa (NOLOCK) on aa.CAH_ID=ap.CAH_ID
			  inner join dbo.CRWAppraisalItemDetail  bb (NOLOCK) on bb.AID_ID = aa.AID_ID 
			  inner join CRWAppraisalScale cc (NOLOCK) on cc.asl_id = bb.ASL_ID
			  where aa.CAI_IsDeleted = 0 and bb.AID_IsDeleted = 0 
			  order by crw_id


			  SELECT CAH_ID,
			   COUNT(cah_id)  AS 'OU'
			   INTO #OUTSTANDING
			  FROM #ALL_SCORES WHERE ASL_Value=6
			  GROUP BY 
			  CAH_ID

			  
			  SELECT CAH_ID,
			   COUNT(cah_id)  AS 'EX'
			   INTO #EXCELLENT
			  FROM #ALL_SCORES WHERE ASL_Value=5
			  GROUP BY 
			  CAH_ID

			  SELECT CAH_ID,
			   COUNT(cah_id)  AS 'PR'
			   INTO #PROFICIENT
			  FROM #ALL_SCORES WHERE ASL_Value=4
			  GROUP BY 
			  CAH_ID

			  SELECT CAH_ID,
			   COUNT(cah_id)  AS 'CP'
			   INTO #CAPABLE
			  FROM #ALL_SCORES WHERE ASL_Value=3
			  GROUP BY 
			  CAH_ID

			  SELECT CAH_ID,
			   COUNT(cah_id)  AS 'US'
			 INTO  #UNSATISFACIONARY
			  FROM #ALL_SCORES WHERE ASL_Value=2
			  GROUP BY 
			  CAH_ID

			  SELECT CAH_ID,
			   COUNT(cah_id)  AS 'UA'
			   INTO #UNACCEPTABLE
			  FROM #ALL_SCORES WHERE ASL_Value=1
			  GROUP BY 
			  CAH_ID

--CONTRACTS WITH VSHIPS
	SELECT	TC.CRW_ID , COUNT(SET_ID) AS VSHIPS_CONTRACTS
			INTO	#tmpServiceCount
			FROM	#appraisal tc
			INNER JOIN shipsure.dbo.CRWSRVDETAIL SD (NOLOCK) ON SD.CRW_ID = TC.CRW_ID
			--INNER JOIN 	#TMPVES v (nolock) on SD.VES_ID = v.VES_ID
			WHERE	
			CAST( SD.SET_StartDate as date)<=CAST(tc.SignOnDate as date)
			-- and sd.crw_id='PFMX00023709'
			AND		SET_CANCELLED = 0
			AND		STS_ID IN ('OB', 'OV')
			AND		SD.VES_ID IS NOT NULL
			AND SET_PREVIOUSEXP=0
			GROUP BY TC.CRW_ID


SELECT AP.*,
ISNULL(OU,0) AS OU, ISNULL(EX,0) as EX, ISNULL(PR,0) as PR,ISNULL(CP,0) as CP,ISNULL(US,0) as US,ISNULL(UA,0) as UA,
R.AverageScore,
	case when AverageScore=1 and Source='NEW' then 'Unacceptable'
		when AverageScore=2 and Source='NEW'then 'Unsatisfactory'
		when AverageScore=3 and Source='NEW'then 'Capable'
		when AverageScore=4 and Source='NEW'then 'Proficient'
		when AverageScore=5 and Source='NEW'then 'Excellent'
		when AverageScore=6 and Source='NEW'then 'Outstanding' end as AverageAppraisalScore,
TV.VSHIPS_CONTRACTS, CASE WHEN TV.VSHIPS_CONTRACTS=1 THEN 'YES' ELSE 'NO' END AS NEW_HIRE_YN

FROM 
#APPRAISAL AP
INNER JOIN #AverageResults R  ON R.cah_ID=AP.CAH_ID
LEFT JOIN #tmpServiceCount TV ON TV.CRW_ID=AP.CRW_ID
LEFT JOIN #OUTSTANDING OU ON OU.CAH_ID=ap.CAH_ID
LEFT JOIN #PROFICIENT PR ON PR.CAH_ID=ap.CAH_ID
LEFT JOIN #CAPABLE CP ON CP.CAH_ID=ap.CAH_ID
LEFT JOIN #EXCELLENT EX ON EX.CAH_ID=ap.CAH_ID
LEFT JOIN #UNSATISFACIONARY US ON US.CAH_ID=ap.CAH_ID
LEFT JOIN #UNACCEPTABLE UA ON UA.CAH_ID=ap.CAH_ID


			  DROP TABLE #appraisal
			  DROP TABLE #AverageResults
			  DROP TABLE #tmpServiceCount
			  DROP TABLE #ALL_SCORES
			  DROP TABLE #CAPABLE
			  DROP TABLE #EXCELLENT
			  DROP TABLE #OUTSTANDING
			  DROP TABLE #PROFICIENT
			  DROP TABLE #UNACCEPTABLE
			  DROP TABLE #UNSATISFACIONARY