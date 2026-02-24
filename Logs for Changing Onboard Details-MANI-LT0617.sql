select attributedesc,cst_id, aa.set_id, aa.crw_id, concat(aa.SET_ID,aa.CRW_ID) as UID,
CST_SetStart, CST_SetEnd,  dateadd(day, CST_DeltaStart, cst_setstart) as cst_setstart_new, dateadd(day, CST_DeltaEnd, cst_setEnd) as cst_setend_new, 
CST_UpdatedOn, CST_UpdatedBy, ud.USR_DisplayName, --aa.*,
ROW_NUMBER() OVER (PARTITION BY AA.Set_id, aa.crw_id ORDER BY cst_updatedon ASC) as RN

into #tmpchangelogs
from shipsure..[CRWServiceTracking] aa
inner join shipsure..attributedef bb on bb.bitvalue = aa.cst_source and  tablename = 'CrewServiceTrackingSource'
inner join shipsure..USERID UD on ud.USR_ID = aa.CST_UpdatedBy
where concat(aa.set_id,aa.crw_id) in ('VGR700764702GLAS00043897',
'VGR700827645GLAS00051622',
'VGR400540954VGR400049656')

and bb.AttributeDesc = 'Update Onboard Details'
order by concat(aa.SET_ID,aa.CRW_ID) ASC


Select set_id, CRW_ID, max(RN) as maxRN
into #maxRN
	from #tmpchangelogs
	group by set_id, CRW_ID

Select ch.*
	from #tmpchangelogs CH
	inner join #maxRN RN on rn.SET_ID = ch.SET_ID and rn.crw_id = ch.crw_id and rn.maxRN = ch.rn

drop table #tmpchangelogs
drop table #maxRN