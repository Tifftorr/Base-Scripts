select 
vv.[Vessel],
vv.[IMO],
vv.[Mgmt Start],
vv.[Mgmt End],
vv.[Group Effective Client],
vv.[Client],
ves.[Flag State],
vv.[Mgmt Type],
vv.[Vessel Type],
vv.[Responsible Office],
vv.[Crew Management Partner Cell],
vv.[Vessel Business],
ves.[Built],
ves.[Built Date],
ves.[Gross Tonnage (GT)],
ves.[DWT (Summer)],
vv.[Technical Office],
vv.[Reporting Office]

from [ShipMgmt_VesselMgmt].[tVesselMetricsPerDayNew] vv
left join [Reference_Vessel].[tVessel] ves on ves.[Vessel ID] = vv.[Vessel ID]
where vv.[IMO] = '9519482'



--vv.[date] = '2025-03-31'