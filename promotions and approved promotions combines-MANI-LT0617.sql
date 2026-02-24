
select * from (


select x.*, row_number() over(partition by x.crw_id order by x.[Source] desc) as rn
from (


select 
	'Promotion Module - Approved have notsailed' as [Source],
	p.crw_id,
	p.pcn,
	p.surname,
	nat.NAT_Description as nationality,
	p.ApprovalDate as eventdate,
	p.crewrank as rank_bfp_crewrank,
	p.PromotionRank as rank_ap_promotionrank,
	p.PromotionRankCategory as rankcategory_ap,
	p.PromotionDepartment,
	p.VES_ID_FINAL as ves_id,
	vv.ves_name,
	p.VESSEL_GENERAL_TYPE as sector,
	vv.ManagementType,
	p.planningcell,
	p.assessmentdate,
	p.interviewoutcome,
	p.interviewdate,
	p.CurrentCrewStatus,
	p.Seafarer_status


	from aggregates.[dbo].[CREW_PromotionModule] P
	left join shipsure..nationality nat on nat.NAT_ID = p.Nationality
	left join Aggregates..vAllVessels vv on vv.VES_ID = p.VES_ID_FINAL
	inner join shipsure..CRWPersonalDetails pd on pd.crw_id = p.crw_id
	where cast(p.RecInsertedOn as date) = '2024-08-25' --(select max(RecInsertedOn) from aggregates.[dbo].[CREW_PromotionModule])
	and p.PromotionStatus in ('Approved')
	and p.crewrank in ('Cadet-Deck', 'Cadet-Electrical','Cadet-Engine', 'Trainee Navigating Officer', 'Trainee Marine Engineer', 'Trainee Electrician', 'Cadet Electro-Technical Officer')
	and p.PromotionRank in ('3rd Officer','Junior 3rd Officer', '4th Engineer','Jr. 4th Engineer', 'Electro-Technical Officer', 'Junior Engineer', 'Junior Officer', '3rd Asst. Engineer', 
				'2nd Electrical Engineer','Junior Electro-Technical Officer', 'Junior Electrician', 'Junior 3rd Officer', 'Junior 4th Engineer', 'Electronic Engineer')
	and p.seafarer_status <> 'Onboard'
	and p.currentcrewstatus not like '%LC%'
	and p.crw_id <> 'VGR400047859'

union

Select 
	'Service Records - promoted have sailed' as [Source],
	aa.crw_id,
	aa.pcn,
	aa.seafarer_surname as surname,
	aa.nationality,
	aa.eventDate,
	aa.rank_bfp as rank_bfp_crewrank,
	aa.CurrentSFRank as rank_ap_promotionrank,
	aa.Sailing_RANK_CATEGORY as rankcategory_ap,
	aa.DepartmentName as PromotionDepartment,
	aa.ves_id,
	aa.vessel_name as ves_name,
	aa.sector,
	aa.managementtype,
	aa.planningcell,
	id.cri_interviewdate as assessmentdate,
	case when id.CRI_InterviewOutcome = 1 then 'Successful' when id.CRI_InterviewOutcome = 0 then 'Failed' else null end as InterviewOutcome,
	id.cri_interviewdate as interviewdate,
	aa.CurrentStatus as CurrentCrewStatus,
	NULL as Seafarer_status


			from aggregates..[CREW_NewHiresAndPromotions] AA
			left join shipsure..CRWRanks rnk on rnk.rnk_id = AA.currentrankID
			left join shipsure..CRW_InterviewDetails (nolock) ID on id.crw_id = aa.crw_id and (id.RNK_ID = AA.CurrentRankId or id.rnk_id = rnk.RNK_EquivalentRank) and id.CRI_CandidateType = 1 and id.CRI_Cancelled = 0
			WHERE AA.EventDate >= '2023-01-01'
			AND AA.[Event] = 'Promotion'
			AND AA.Rank_BFP in ('Cadet-Deck', 'Cadet-Electrical','Cadet-Engine', 'Trainee Navigating Officer', 'Trainee Marine Engineer',  'Trainee Electrician', 'Cadet Electro-Technical Officer')
			AND AA.CurrentSFRank in ('3rd Officer','Junior 3rd Officer', '4th Engineer','Jr. 4th Engineer', 'Electro-Technical Officer', 'Junior Engineer', 'Junior Officer', '3rd Asst. Engineer', 
				'2nd Electrical Engineer','Junior Electro-Technical Officer', 'Junior Electrician', 'Junior 3rd Officer', 'Junior 4th Engineer', 'Electronic Engineer')
			--AND AA.ManagementType IN ('Tech Mgmt', 'Full Management') -- sm only
			--AND AA.Sector = 'CARGO'

) x ) y
where y.rn = 1


/*select top 10 * from shipsure.[dbo].[CRWPromotionHeader];
select top 10 * from aggregates.[dbo].[CREW_PromotionModule];
select top 10 * from aggregates..[CREW_NewHiresAndPromotions] where event = 'Promotion';
select top 10 * from shipsure..CRW_InterviewDetails where cri_candidatetype = 1;*/
