
--compliance to checks crw16 drill down

Select 
NH.crw_id,
nh.pcn,
nh.seafarer_surname,
NH.CurrentRankId,
NH.CurrentSFRank,
Rank_SN1_NH = CASE  
	  WHEN cca.CCA_IsOfficer = 1 THEN '0' + cast(rnk.RNK_SequenceNumber as varchar(20))
	  WHEN cca.CCA_IsOfficer = 0 THEN '1' + cast(rnk.RNK_SequenceNumber as varchar(20)) end ,
NH.eventdate,
vv.ManagementType,
vv.VESSEL_GENERAL_TYPE,
nh.ves_id,
vv.ves_name,
vv.VesType,
nh.nationality,
nh.MobilisationCell,
nh.MobilisationOffice,
nh.SET_Startdate,
nh.Set_endDate,
CPD.CPL_ID_Recruiter,
cpl.cpl_description as recruitment_cell,
cast(id.cri_id as varchar) as cri_id,
cast(id.cri_interviewer as varchar) as cri_interviewer,
id.cri_interviewdate,
--id.cri_reasonsfordecision,
cast(id.cri_remarks as varchar) as cri_remarks,
cast(id.rnk_id as varchar) as rnk_id,
cast(rnk.rnk_description as varchar) as intervieweerank,
Rank_SN1_Interview = case  
	  when cca2.CCA_IsOfficer = 1 then '0' + cast(rnk2.RNK_SequenceNumber as varchar(20))
	  when cca2.CCA_IsOfficer = 0 then '1' + cast(rnk2.RNK_SequenceNumber as varchar(20)) end ,
count(distinct id.cri_id) as count_of_newhire_interviews,
CASE WHEN TPA.CCN_DESCRIPTION IS NULL AND ([SET_3rdPartyAgent] IS NOT NULL or CRW_3rdPartyAgent is not null )or crw_employmenttype='VSHP00000003' THEN 'Third Party Crew'
	 WHEN (TPA.CCN_DESCRIPTION IS NULL AND CPD.crw_OwnerSeafarer  = 1) OR  crw_employmenttype='VSHP00000002' THEN 'Owner Supplied'
	 WHEN TPA.CCN_DESCRIPTION IS NULL THEN 'Internal Supply'
		ELSE TPA.CCN_DESCRIPTION END		AS CONTRACT_TYPE,
nh.VesselClient,
nh.TechnicalOffice,
cca2.CCA_Description as rankcategory

into #tmpnewhirewcrw16
from Aggregates..CREW_NewHiresAndPromotions (nolock) NH
left join ShipSure..CRWSRVDETAIL SD (NOLOCK) on sd.crw_id = nh.crw_id
INNER JOIN shipsure..CRWPersonalDetails (nolock) CPD on CPD.CRW_ID=NH.CRW_ID
left join SHIPSURE..CRWPOOL (nolock) cpl on cpl.cpl_id = cpd.CPL_ID_Recruiter
LEFT JOIN shipsure..COMPANY CMP4 (NOLOCK) ON CMP4.CMP_ID = CPD.CRW_EmploymentEntity -- TPA
LEFT JOIN shipsure..COMPANY CMP12 (NOLOCK) ON CMP12.CMP_ID = sd.[SET_ContractCompany]
LEFT JOIN shipsure..CRWSrvContractType TPA ON TPA.CCN_ID = cpd.CRW_EmploymentType
left join shipsure..crwranks rnk2 (nolock) on rnk2.rnk_id = nh.CurrentRankId
inner join ShipSure..CRWRankCategory cca2 (NOLOCK) on cca2.CCA_ID = rnk2.CCA_ID
left join shipsure..CRW_InterviewDetails (nolock) ID on id.crw_id = nh.crw_id and (id.RNK_ID = NH.CurrentRankId or id.rnk_id = rnk2.RNK_EquivalentRank) and id.CRI_InterviewOutcome = 1 and id.CRI_Cancelled = 0
left join shipsure..CRWRanks rnk (nolock) on rnk.RNK_ID = id.RNK_ID
inner join  ShipSure..CRWRankCategory cca (NOLOCK) on cca.CCA_ID = rnk.CCA_ID
left join aggregates..vAllVessels vv on vv.VES_ID = nh.ves_id

where nh.event = 'New Hire'
--and nh.eventdate >= '2023-01-01'
and cast(nh.eventdate as date) BETWEEN DATEADD(day,-365,getdate()) AND GETDATE()-1 -- new hires in the last 365 days
--and nh.Sailing_RANK_CATEGORY in ('Junior Officers','Senior Officers') --officers only!!
--and nh.ManagementType in ('Full Management', 'Tech Mgmt') -- sm only
--and nh.sector = 'CARGO'
and nh.rejoined = 0
group by
NH.crw_id,
		nh.pcn,
		nh.seafarer_surname,
		NH.CurrentRankId,
		NH.CurrentSFRank,
		NH.eventdate,
		vv.ManagementType,
		vv.VESSEL_GENERAL_TYPE,
		nh.ves_id,
		vv.ves_name,
		vv.VesType,
		nh.nationality,
		nh.MobilisationCell,
		nh.MobilisationOffice,
		nh.SET_Startdate,
		nh.Set_endDate,
		CPD.CPL_ID_Recruiter,
		cpl.cpl_description,
		cast(id.cri_id as varchar),
		cast(id.cri_interviewer as varchar),
		id.cri_interviewdate,
		--id.cri_reasonsfordecision,
		cast(id.cri_remarks as varchar),
		cast(id.rnk_id as varchar),
		cast(rnk.rnk_description as varchar),
		TPA.CCN_DESCRIPTION,
		[SET_3rdPartyAgent],
		CRW_3rdPartyAgent,
		crw_employmenttype,
		CPD.crw_OwnerSeafarer,
		nh.VesselClient,
		nh.TechnicalOffice,
		cca2.CCA_Description,
		cca.CCA_IsOfficer,
		rnk.RNK_SequenceNumber,
		cca2.CCA_IsOfficer,
		rnk2.RNK_SequenceNumber


--into w/o crw16
Select 
NH.crw_id,
nh.pcn,
nh.seafarer_surname,
NH.CurrentRankId,
NH.CurrentSFRank,
cast(null as varchar) AS Rank_SN1_NH,
NH.eventdate,
vv.ManagementType,
vv.VESSEL_GENERAL_TYPE,
nh.ves_id,
vv.ves_name,
vv.VesType,
nh.nationality,
nh.MobilisationCell,
nh.MobilisationOffice,
nh.SET_Startdate,
nh.Set_endDate,
CPD.CPL_ID_Recruiter,
cpl.cpl_description as recruitment_cell,
cast(null as varchar) as cri_id,
cast(null as varchar) as cri_interviewer,
cast(null as varchar) as cri_interviewdate,
--null as cri_reasonsfordecision,
cast(null as varchar) as cri_remarks,
cast(null as varchar) as rnk_id,
cast(null as varchar) as intervieweerank,
cast(null as varchar) AS Rank_SN1_Interview,
count(distinct id.cri_id) as count_of_newhire_interviews,
CASE WHEN TPA.CCN_DESCRIPTION IS NULL AND ([SET_3rdPartyAgent] IS NOT NULL or CRW_3rdPartyAgent is not null )or crw_employmenttype='VSHP00000003' THEN 'Third Party Crew'
	 WHEN (TPA.CCN_DESCRIPTION IS NULL AND CPD.crw_OwnerSeafarer  = 1) OR  crw_employmenttype='VSHP00000002' THEN 'Owner Supplied'
	 WHEN TPA.CCN_DESCRIPTION IS NULL THEN 'Internal Supply'
		ELSE TPA.CCN_DESCRIPTION END		AS CONTRACT_TYPE,
nh.VesselClient,
nh.TechnicalOffice,
cca2.CCA_Description as rankcategory

into #tmpnewhirewocrw16
from Aggregates..CREW_NewHiresAndPromotions (nolock) NH
left join ShipSure..CRWSRVDETAIL SD (NOLOCK) on sd.crw_id = nh.crw_id
INNER JOIN shipsure..CRWPersonalDetails (nolock) CPD on CPD.CRW_ID=NH.CRW_ID
left join SHIPSURE..CRWPOOL (nolock) cpl on cpl.cpl_id = cpd.CPL_ID_Recruiter
LEFT JOIN shipsure..COMPANY CMP4 (NOLOCK) ON CMP4.CMP_ID = CPD.CRW_EmploymentEntity -- TPA
LEFT JOIN shipsure..COMPANY CMP12 (NOLOCK) ON CMP12.CMP_ID = sd.[SET_ContractCompany]
LEFT JOIN shipsure..CRWSrvContractType TPA ON TPA.CCN_ID = cpd.CRW_EmploymentType 
left join shipsure..crwranks rnk2 (nolock) on rnk2.rnk_id = nh.CurrentRankId
left join ShipSure..CRWRankCategory cca2 (NOLOCK) on cca2.CCA_ID = rnk2.CCA_ID
left join shipsure..CRW_InterviewDetails (nolock) ID on id.crw_id = nh.crw_id and (id.RNK_ID = NH.CurrentRankId or id.rnk_id = rnk2.RNK_EquivalentRank) and id.CRI_InterviewOutcome = 1 and id.CRI_Cancelled = 0
left join shipsure..CRWRanks rnk (nolock) on rnk.RNK_ID = id.RNK_ID
left join  ShipSure..CRWRankCategory cca (NOLOCK) on cca.CCA_ID = rnk.CCA_ID
left join aggregates..vAllVessels vv on vv.VES_ID = nh.ves_id

where nh.event = 'New Hire'
--and nh.eventdate >= '2023-01-01'
and cast(nh.eventdate as date) BETWEEN DATEADD(day,-365,getdate()) AND GETDATE()-1 -- new hires in the last 365 days
--and nh.Sailing_RANK_CATEGORY in ('Junior Officers','Senior Officers') --officers only!!
--and nh.ManagementType in ('Full Management', 'Tech Mgmt') -- sm only
--and nh.sector = 'CARGO'
and nh.rejoined = 0
group by 
		NH.crw_id,
		nh.pcn,
		nh.seafarer_surname,
		NH.CurrentRankId,
		NH.CurrentSFRank,
		NH.eventdate,
		vv.ManagementType,
		vv.VESSEL_GENERAL_TYPE,
		nh.ves_id,
		vv.ves_name,
		vv.VesType,
		nh.nationality,
		nh.MobilisationCell,
		nh.MobilisationOffice,
		nh.SET_Startdate,
		nh.Set_endDate,
		CPD.CPL_ID_Recruiter,
		cpl.cpl_description,
		TPA.CCN_DESCRIPTION,
		[SET_3rdPartyAgent],
		CRW_3rdPartyAgent,
		crw_employmenttype,
		CPD.crw_OwnerSeafarer,
		nh.VesselClient,
		nh.TechnicalOffice,
		--cca2.CCA_Description,
		cca2.CCA_Description
		--rnk.RNK_SequenceNumber,
		--cca2.CCA_IsOfficer,
		--rnk2.RNK_SequenceNumber


Select xx.*, 
	case when cast(xx.eventdate as date) BETWEEN DATEADD(day,-30,getdate()) AND GETDATE() then 'Joiner in the last 30 Days' else 'Other' end as Joined_On ,
	case when count_of_newhire_interviews = 0 then 'MISSING' ELSE 'COMPLIANT TO CRW-16' END AS Compliance, getdate() as refreshdate,
	case when xx.Rank_SN1_Interview < xx.Rank_SN1_NH THEN 1 ELSE 0 END AS InterviewRankisHigher


	from (

Select *
	from #tmpnewhirewocrw16 --w/o crw-16
	where count_of_newhire_interviews = 0

union all

Select *
	from #tmpnewhirewcrw16 ) xx --with crw-16

drop table #tmpnewhirewocrw16
drop table #tmpnewhirewcrw16