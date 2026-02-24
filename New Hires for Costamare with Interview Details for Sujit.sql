SELECT NH.crw_id,
	nh.pcn,
	nh.seafarer_surname,
	nh.set_id,
	NH.CurrentRankId,
	NH.CurrentSFRank,
	Rank_SN1_NH = CASE  
	  WHEN cca.CCA_IsOfficer = 1 THEN '0' + cast(rnk.RNK_SequenceNumber as varchar(20))
	  WHEN cca.CCA_IsOfficer = 0 THEN '1' + cast(rnk.RNK_SequenceNumber as varchar(20)) end ,
	NH.eventdate,
	CPD.CPL_ID_Recruiter,
	cpl.cpl_description as recruitment_cell,
	vv.ves_name,
	id.rnk_id as InterviewRank_ID,
	rnk2.rnk_description as InterviewRank,
	Rank_SN1_Interview = case  
	  when cca2.CCA_IsOfficer = 1 then '0' + cast(rnk2.RNK_SequenceNumber as varchar(20))
	  when cca2.CCA_IsOfficer = 0 then '1' + cast(rnk2.RNK_SequenceNumber as varchar(20)) end ,
	count(distinct id.cri_id) as count_of_newhire_interviews,
	CASE WHEN TPA.CCN_DESCRIPTION IS NULL AND ([SET_3rdPartyAgent] IS NOT NULL or CRW_3rdPartyAgent is not null )or crw_employmenttype='VSHP00000003' THEN 'Third Party Crew'
		 WHEN (TPA.CCN_DESCRIPTION IS NULL AND CPD.crw_OwnerSeafarer  = 1) OR  crw_employmenttype='VSHP00000002' THEN 'Owner Supplied'
		 WHEN TPA.CCN_DESCRIPTION IS NULL THEN 'Internal Supply'
		 ELSE TPA.CCN_DESCRIPTION END		AS CONTRACT_TYPE,
		 case when id.CRI_InterviewOutcome = 0 then 'Unsuccessful'
			  when id.CRI_InterviewOutcome = 1 then 'Successful'
			  else 'No Interview' end as [interview outcome],
		 case when id.cri_candidatetype = 0 then 'New Hire'
			  when id.cri_candidatetype = 1 then 'Promotion' 
			  else 'No Interview' end as [interview type]


into #CRW16fin
from Aggregates..CREW_NewHiresAndPromotions (nolock) NH
left join ShipSure..CRWSRVDETAIL SD (NOLOCK) on sd.crw_id = nh.crw_id AND SD.SET_ID = NH.SET_ID
INNER JOIN shipsure..CRWPersonalDetails (nolock) CPD on CPD.CRW_ID=NH.CRW_ID
left join SHIPSURE..CRWPOOL (nolock) cpl on cpl.cpl_id = cpd.CPL_ID_Recruiter
LEFT JOIN shipsure..COMPANY CMP4 (NOLOCK) ON CMP4.CMP_ID = CPD.CRW_EmploymentEntity -- TPA
LEFT JOIN shipsure..COMPANY CMP12 (NOLOCK) ON CMP12.CMP_ID = sd.[SET_ContractCompany]
LEFT JOIN shipsure..CRWSrvContractType TPA ON TPA.CCN_ID = cpd.CRW_EmploymentType 
left join shipsure..CRWRanks rnk on rnk.rnk_id = nh.currentrankID
left JOIN shipsure..CRWRankCategory CCA ON CCA.CCA_ID=rnk.CCA_ID
left join shipsure..CRW_InterviewDetails (nolock) ID on id.crw_id = nh.crw_id and id.CRI_Cancelled = 0 --and (id.RNK_ID = NH.CurrentRankId or id.rnk_id = rnk.RNK_EquivalentRank) and id.CRI_InterviewOutcome = 1 and id.CRI_Cancelled = 0
left join aggregates..vAllVessels vv on vv.VES_ID = nh.ves_id
left join shipsure..CRWRanks rnk2 on rnk2.rnk_id = id.rnk_id
left JOIN shipsure..CRWRankCategory CCA2 ON CCA2.CCA_ID=rnk2.CCA_ID
where nh.event = 'New Hire'
and nh.eventdate >= '2024-01-01'
--and cast(nh.eventdate as date) BETWEEN DATEADD(day,-30,getdate()) AND GETDATE()-1 -- new hires in the last 30 days
and nh.Sailing_RANK_CATEGORY in ('Junior Officers','Senior Officers') --officers only!!
and vv.ManagementType in ('Full Management', 'Tech Mgmt') -- sm only
and vv.VESSEL_GENERAL_TYPE = ('CARGO')
and nh.rejoined = 0
and nh.ves_id <> 'VGRP00019595' --it integrity
AND SD.SET_CANCELLED  = 0
and nh.ves_id in ('FAIR00036497',
'GLAS00015394',
'GLAS00020428',
'GLAS00020747',
'GLAT00001509',
'MANI00015717',
'MANI00016716',
'MANI00020433',
'ODES00011987',
'VGR400021448',
'VGR400021540',
'VGR400021925',
'VGR400022321',
'VGR400023729',
'VGR500007067')
group by 
		NH.crw_id,
		nh.pcn,
		nh.seafarer_surname,
		NH.CurrentRankId,
		NH.CurrentSFRank,
		NH.eventdate,
		CPD.CPL_ID_Recruiter,
		cpl.cpl_description,
		vv.ves_name,
		TPA.CCN_DESCRIPTION,
		[SET_3rdPartyAgent],
		CRW_3rdPartyAgent,
		crw_employmenttype,
		CPD.crw_OwnerSeafarer,
		cca.CCA_IsOfficer,
		rnk.RNK_SequenceNumber,
		id.rnk_id,
		rnk2.rnk_description,
		cca2.CCA_IsOfficer,
		rnk2.RNK_SequenceNumber,
		nh.set_id,
		id.CRI_InterviewOutcome,
		id.cri_candidatetype

SELECT DISTINCT crw.*, CASE WHEN crw.Rank_SN1_Interview < Rank_SN1_NH THEN 1 ELSE 0 END AS InterviewRankisHigher
--into #CRW16
FROM #CRW16fin crw


drop table #CRW16fin


/*select * from Aggregates..CREW_NewHiresAndPromotions
where vessel_name in ('ACUITY ', 'EQUITY', 'PARITY', 'DISCOVERY','VERITY', 'CLARA', 'BERNIS', 'ORACLE', 'SAUVAN', 'BERMONDI', 'TITAN I', 'VISBY', 'SERENA', 'ROSE', 'GRENETA' )*/



select distinct cri_candidatetype from shipsure..CRW_InterviewDetails