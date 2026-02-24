select 
[Date],
[Vessel Id], [IMO], 
[Vessel], 
[Mgmt Type], 
[Vessel type], 
[Vessel Business],
[Technical Office], 
[Fleet Name], 
[Fleet Manager],
[Fleet Supt], -- tech supt
[Marine Supt], -- MS&Q Supt
[Asst Supt], -- assist tech supt
[Primary Purchasing Contact], -- purchasing
[Primary Accounting Contact], -- VFC
[Type Group],
[General Type Group]

from [ShipMgmt_VesselMgmt].[tVesselMetricsPerDayNew]
where date = '2025-11-30'
and [Mgmt Type] in ('Full Management', 'Tech Mgmt')