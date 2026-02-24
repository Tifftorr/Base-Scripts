select distinct AA.datekey,
AA.set_id,
cast(AA.RecInsertedOn as date) as recinsertedon,
AA.CRW_ID,
AA.pcn,
AA.SeafarerSurname,
AA.rank,
AA.RankCategory,
AA.Department,
AA.NATIONALITY,
AA.MobilisationCell,
AA.PlanningCell,
AA.StartDate,
AA.EndDate,
--sd.SET_StartDate,
--SD.SET_EndDate,
AA.OVERDUE_TODAY30D,
AA.OverdueNoExtToday,
AA.VESSEL_FINAL,
AA.CLIENT_FINAL,
AA.MANAGEMENT_TYPE_FINAL,
AA.SECTOR_FINAL,
AA.VESSEL_TECH_MGT_OFFICE,
case when SET_ContractLengthUnit = 'M' then set_contdays * 30 
	 when SET_ContractLengthUnit = 'W' then set_contdays * 7
			else set_contdays end as ContractDays
, 'D' as ContractUnit
, case when set_extensionunit = 'M' then set_extension * 30 
	   when set_extensionunit = 'W' then set_extension * 7
			else set_extension end as Extension
, 'D' as ExtensionUnit
,cast(	dateadd(day, ( case when SET_ContractLengthUnit = 'M' then set_contdays * 30 
							when SET_ContractLengthUnit = 'W' then set_contdays * 7
								else set_contdays end), set_startdate ) +1   as date) as CONTRACT_END_DATE,
--count(AA.EndDate) over (partition by AA.set_id) as No_SignOffs_per_service,

dense_rank() over (partition by AA.set_id order by AA.EndDate) 
+ dense_rank() over (partition by AA.set_id order by AA.EndDate desc) 
- 1 as No_SignOffs_per_service,
CPL_ID_CMP,
Cpl.cpl_description as CMP_Cell,
aa.fleet,
ROW_NUMBER() OVER (PARTITION BY AA.Set_id ORDER BY AA.datekey ASC) AS rn

into #tmpcrw
from Aggregates..crew_activecrew AA
left join shipsure..CRWSRVDETAIL SD (NOLOCK) on sd.set_id = aa.set_id and set_cancelled = 0
LEFT JOIN shipsure..CRWSrvDetailExtension SD2 ON SD2.SET_ID = AA.SET_ID and sd2.ext_cancelled=0 and sd2.EXT_extendedon is not null
left join shipsure..CRWPOOL CPL on CPL.cpl_id = AA.CPL_ID_CMP

where cast(AA.recinsertedon as date) in (

'2024-07-21',
'2024-07-28',
'2024-08-04') --- change manually depends on the scope!!
and AA.current_status = 'ONBOARD'
and AA.MANAGEMENT_TYPE_FINAL in  ('Full Manag  ement', 'Full Management', 'Tech Mgmt')
--and AA.sector_final = 'CARGO'
order by AA.CRW_ID asc, AA.SET_ID, AA.datekey asc


--- min end_date

Select crw_id, set_id, EndDate as min_contract_end_date
into #tmpminenddate
	from #tmpcrw XX
	--left join (select crw_id, set_id, min(rn) as minrn from #tmpcrw group by crw_id,set_id) MM on mm.crw_id = xx.crw_id and mm.set_id = xx.set_id and mm.minrn = xx.rn
	where xx.rn = 1



--select * from #tmpcrw
	

--group by crw_id, set_id

-- max_enddate
Select xx.crw_id, xx.set_id, xx.EndDate as max_contract_end_date
into #tmpmaxenddate
	from #tmpcrw XX
	inner join (select crw_id, set_id, max(rn) as minrn from #tmpcrw group by crw_id,set_id) MM on mm.crw_id = xx.crw_id and mm.set_id = xx.set_id and mm.minrn = xx.rn
--group by crw_id, set_id

--final select
Select ZZ.*,
AA.min_contract_end_date, bb.max_contract_end_date
	from #tmpcrw ZZ
	left join #tmpminenddate aa on aa.crw_id = zz.crw_id and aa.set_id = zz.set_id
	left join #tmpmaxenddate bb on bb.CRW_ID = zz.CRW_ID and bb.SET_ID = zz.SET_ID
	order by ZZ.CRW_ID asc, ZZ.SET_ID, ZZ.datekey asc

drop table #tmpcrw
drop table #tmpminenddate
drop table #tmpmaxenddate