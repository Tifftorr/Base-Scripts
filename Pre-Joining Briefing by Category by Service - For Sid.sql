--F2F briefing
use shipsure
go


--Top 2 joiners
Select SD.CRW_ID, sd.set_startdate, sd.set_enddate, sd.VES_ID, pd.crw_pid as PCN, pd.crw_surname, sd.set_id,
	   cpln.CPL_Description as PlanningCell,
	   cmp.CPL_Description as CMPCell,
	   mob.CPL_Description as MobilisationCell,
	   RR.RNK_SHORTCODE,
	   vv.smo,
	   cast(db.CJB_BreifingDate as date)   AS BriefingDate, case 
				when db.CJB_AttendanceType = 3 then 'Video'
				when db.CJB_AttendanceType = 2 then 'Phone'
				when db.CJB_AttendanceType = 1 then 'Office'
				else 'Missing' end as Attendance_Type, 
			db.CJB_BreifingByName , 
			db.AAL_ID_ReviewedBy
			--case when db.AAL_ID_ReviewedBy = 'GLAS00000024'  then 'SuperIntendent'
			--when db.AAL_ID_ReviewedBy = 'GLAS00000046'  then 'Crew Manager'
			--end as ReviewedbyRole
	into #joiners
	from shipsure.dbo.CRWSrvDetail sd
	INNER join    shipsure.dbo.CRWPersonalDetails pd  (nolock)  on pd.CRW_ID=sd.CRW_ID and pd.CRW_Cancelled=0
	left join shipsure.dbo.crwranks rank (nolock) on rank.rnk_id=sd.rnk_id
	left join  shipsure..CRWRankCategory cca (NOLOCK) on cca.CCA_ID = rank.CCA_ID 
	left join aggregates.[dbo].[vAllVessels] VV on VV.VES_ID = SD.VES_ID
	INNER JOIN	shipsure..CRWRanks RR ON RR.RNK_ID = SD.RNK_ID_Budgeted
	left join shipsure..crwpool mob on mob.CPL_ID=pd.CPL_ID
	left join shipsure..crwpool cpln on cpln.cpl_id=pd.CPL_ID_PLAN
	left join shipsure..crwpool cmp on cmp.cpl_id=pd.CPL_ID_CMP
	left join shipsure..CRWOBJoiningBrief (nolock) db on db.SET_ID = sd.SET_ID and db.CJB_IsDeleted = 0 and db.AAL_ID_ReviewedBy = 'GLAS00000024'
	where sd.SET_Cancelled=0
	and	sd.SET_PreviousExp = 0
	and           CRW_Cancelled = 0
	and           (sas_id is null or sas_id <> (3) )
	and           sd.STS_ID in ('OB','OV')
	--and cast(SD.set_startdate as date) BETWEEN DATEADD(day,-30,getdate()) AND GETDATE()-1
	--AND	SET_startdate>= '2023-01-01' and SET_startdate <= getdate()
	--DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0) -- First Day of year
	AND vv.VMO_ID in ('GLAS00000003', 'GLAS00000007') --sm only
	and vv.vessel_general_type = 'CARGO'
	AND		RR.RNK_SHORTCODE IN ('ChEng', 'Master')
	and		VES_Name not in ('DEMO SHIP 1')
	and SHIPMANAGERTYPE='internal ship manager'
	AND    (  
		(cast(sd.set_startdate as date) >= '2023-08-01' AND cast(sd.set_startdate as date) <= '2023-08-01')  
		or  
		(cast(sd.set_enddate as date) >= '2023-08-01' AND cast(sd.set_enddate as date)  <= '2023-08-01')  
		or  
		(cast(sd.set_startdate as date) <= '2023-08-01' AND cast(sd.set_enddate as date)  >= '2023-08-01')  
		or  
		(cast(sd.set_startdate as date) >= '2023-08-01' AND cast(sd.set_enddate as date) <= '2023-08-01')  
		)  
		--AND datediff(d, set_startdate, set_enddate) > 7
	--and db.AAL_ID_ReviewedBy = 'GLAS00000024'

--servicecount
		SELECT	TC.CRW_ID , COUNT(tc.SET_ID) AS VSHIPS_SERVICE_COUNT
		INTO	#tmpServiceCount
		FROM	#joiners tc
		INNER JOIN CRWSRVDETAIL SD (NOLOCK) ON SD.CRW_ID = TC.CRW_ID
		WHERE	(SAS_ID IS NULL OR SAS_ID <> 3) 
		AND		SET_ACTIVESTATUS = 0
		AND		SET_CANCELLED = 0
		AND		SET_PreviousExp = 0
		AND		STS_ID IN ('OB', 'OV')
		AND		SD.VES_ID IS NOT NULL
		
		GROUP BY TC.CRW_ID

--data for bebriefing
Select SD.CRW_ID, BF.*
	into #prejoiningbriefing
	from shipsure.dbo.CRWSrvDetail sd
	INNER join    shipsure.dbo.CRWPersonalDetails pd  (nolock)  on pd.CRW_ID=sd.CRW_ID and pd.CRW_Cancelled=0
	left join shipsure.dbo.crwranks rank (nolock) on rank.rnk_id=sd.rnk_id
	left join  shipsure..CRWRankCategory cca (NOLOCK) on cca.CCA_ID = rank.CCA_ID 
	left join aggregates.[dbo].[vAllVessels] VV on VV.VES_ID = SD.VES_ID
	inner join shipsure..CRWOBJoiningBrief (nolock) bf on bf.SET_ID = sd.SET_ID and bf.CJB_IsDeleted = 0 --and CJB_IsAddedInOffice = 1 and AAL_ID_ReviewedBy = 'GLAS00000024'
		where sd.SET_Cancelled=0
		and	sd.SET_PreviousExp = 0
		and CRW_Cancelled = 0
		--and BF.CJB_AttendanceType = 1
		--and bf.CJB_BreifingDate >= dateadd(month,datediff(month,0,cast(sd.set_startdate as date))-24,0) --get past 12 months data from signondate 2023-09-28

	
	--final combine both
Select j.*
-- count(db.CJB_ID) as supt_briefingcount_LTM, case when count(db.CJB_ID) >= 1 THEN 'Compliant' else 'Non-Compliant' end as supt_pre_joining_compliant,
--case when tmp.VSHIPS_SERVICE_COUNT > 0 then 'Ex-Vships' else 'New Hire' end as ExperienceType
	--into #f2fbriefing
	from #joiners j
	--left join #prejoiningbriefing db on db.CRW_ID = j.CRW_ID
	left join #tmpServiceCount tmp on tmp.crw_id = j.crw_id
	--group by j.CRW_ID, j.SET_EndDate, j.SET_StartDate, j.VES_ID, j.pcn, j.crw_surname, j.CMPCell, j.MobilisationCell, j.PlanningCell, j.RNK_SHORTCODE, j.smo, tmp.VSHIPS_SERVICE_COUNT


	drop table #prejoiningbriefing
	drop table #joiners
	drop table #tmpServiceCount