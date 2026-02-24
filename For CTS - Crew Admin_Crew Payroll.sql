select resp.[Responsibility], resp.[Responsibility Type ID], resp.[Responsible Person], resp.[Responsible Person ID], vv.* 
from [ShipMgmt_VesselMgmt].[tVesselMetricsPerDayNew] vv
inner join [ShipMgmt_VesselMgmt].[tShipMgmtRecordsResponsibilities] resp on resp.[Vessel Mgmt ID] = vv.[Vessel Mgmt ID] 
	and cast(resp.[Valid From] as date) <= '2024-07-31' and (resp.[Valid To] is null or cast(resp.[Valid To] as date) >= '2024-07-31') and 
	resp.[Responsibility Type ID] in ('GLAS00000014', 'GLAS00000019', 'GLAS00000015') -- crew accounts admin primary / crew accounts admin / cree payroll
where vv.date = '2024-07-31'
order by [Vessel ID] asc
