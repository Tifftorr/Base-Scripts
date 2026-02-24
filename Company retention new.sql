--getting crew OB last 12 months

DECLARE @Date DATE = CAST('2024-10-05' AS DATE); --12 mos ago from the date example as for July 2024 (July 31 2024 - 360 days)


create table #tmpVessels(      
      VES_ID varchar(12),      
      VES_Name varchar(128),      
      ves_ownergrp varchar(12),      
      ves_onboard2 int default 0,      
      Client varchar(128),    
      VTY_ID varchar(12) NULL,    
      VMO_ID varchar(12) NULL,    
      SMO_ID varchar(12) NULL,    
      CMO_ID varchar(12) NULL,    
      VSS_ID int null,    
      FLAG varchar(128) NULL,    
      imo varchar (15)     
   )      
    
  INSERT INTO #tmpVessels     
  SELECT VES_ID, ves_name,  null as ves_ownergrp, ves_onboard2, null as  Client,     
    VTY_ID, CAST(NULL  AS VARCHAR(12)) AS VMO_ID, NULL AS SMO , VES_OffCrew  as MoblisedBy, VSS_ID, CNT.CNT_Desc , VES_IMOnumber    
  FROM shipsure.dbo.vessel v      
  LEFT JOIN shipsure.dbo.COUNTRY CNT ON CNT.CNT_ID = V.VES_Flag     
   /* where ves_id not in ('GLAX00012386', 'GLAT00000027')    
  and  vss_id not in ('09', '07', '08')    
  */    
    
  -- IF VMO_ID OR CLIENT IS MISSING THEN UPDATE THE RECORDS.    
  UPDATE #tmpVessels    
  SET  VMO_ID = COALESCE(LHS.VMO_ID, RHS.VMO_ID),    
    ves_ownergrp =  COALESCE(LHS.ves_ownergrp, RHS.VMD_Owner),    
    Client = rhs.CMP_Name    
  FROM #tmpVessels LHS    
  JOIN (SELECT DISTINCT VES_ID, VMO_ID, XX.VMD_Owner, cmp.CMP_Name    
    FROM shipsure.dbo.VESMANAGEMENTDETAILS  XX    
    left join shipsure.dbo.company cmp on cmp.cmp_id = XX.VMD_Owner    
    WHERE VMD_ManageEnd IS NULL) RHS ON RHS.VES_ID = LHS.VES_ID     
  WHERE LHS.VMO_ID IS NULL OR LHS.ves_ownergrp IS NULL    
    
  -- SET TECHNICAL OFFICE , USED IN CASE NOT SET AGAINST THE VESSEL.    
  UPDATE #tmpVessels    
  SET  SMO_ID = RHS.SMO_ID    
  FROM #tmpVessels LHS    
  JOIN (SELECT DISTINCT XX.VES_ID, MAX(YY.CMP_ID) AS SMO_ID     
    FROM shipsure.dbo.VESMANAGEMENTDETAILS  XX    
    INNER JOIN shipsure.dbo.VESOFFICESERVICE YY ON YY.VMD_ID = XX.VMD_ID AND YY.VOS_Deleted = 0 AND YY.VOT_ID IN ('GLAS00000005') --, 'GLAS00000003')    
    WHERE VMD_ManageEnd IS NULL    
    GROUP BY  XX.VES_ID) RHS ON RHS.VES_ID = LHS.VES_ID     
  WHERE LHS.SMO_ID IS NULL      
    
    
  --set responsible office as technical office in case still null 26.05    
    
  UPDATE #tmpVessels    
  SET  SMO_ID = RHS.SMO_ID    
  FROM #tmpVessels LHS    
  JOIN (SELECT DISTINCT XX.VES_ID, MAX(YY.CMP_ID) AS SMO_ID     
    FROM shipsure.dbo.VESMANAGEMENTDETAILS  XX    
    INNER JOIN shipsure.dbo.VESOFFICESERVICE YY ON YY.VMD_ID = XX.VMD_ID AND YY.VOS_Deleted = 0 AND YY.VOT_ID IN ('GLAS00000003') --, 'GLAS00000003')    
    WHERE VMD_ManageEnd IS NULL    
    GROUP BY  XX.VES_ID) RHS ON RHS.VES_ID = LHS.VES_ID     
  WHERE LHS.SMO_ID IS NULL     
    
  --select * from VESOFFICETYPE     
    
  UPDATE #tmpVessels    
  SET  CMO_ID = RHS.CMO_ID    
  FROM #tmpVessels LHS    
  JOIN (SELECT DISTINCT XX.VES_ID, MAX(YY.CMP_ID) AS CMO_ID     
    FROM shipsure.dbo.VESMANAGEMENTDETAILS  XX    
    INNER JOIN shipsure.dbo.VESOFFICESERVICE YY ON YY.VMD_ID = XX.VMD_ID AND YY.VOS_Deleted = 0 AND YY.VOT_ID IN ('GLAS00000006') --, 'GLAS00000003')    
    WHERE VMD_ManageEnd IS NULL    
    GROUP BY  XX.VES_ID) RHS ON RHS.VES_ID = LHS.VES_ID     
    
    
  select aa.*,     
    vty_desc as VesType,    
    vty.vty_id as vessel_desc,    
    CASE WHEN VTY.VTY_ID = 'OTH' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'OV' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'SLG' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'UN' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'LIV' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'WF' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'TH' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'TG' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'TGE' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'RF' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'WA' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'WB' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'WD' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'NHTANK' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'O/O' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'PTANK' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'TANKER' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'TD' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'TNB' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'TNS' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'TNV' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'TO' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'TR' THEN 'CARGO'    
    WHEN VTY.VTY_ID = 'CASINO' THEN 'LEISURE'    
    WHEN VTY.VTY_ID = 'HOVER' THEN 'LEISURE'    
    WHEN VTY.VTY_ID = 'HSC' THEN 'LEISURE'    
    WHEN VTY.VTY_ID = 'HYDRO' THEN 'LEISURE'    
    WHEN VTY.VTY_ID = 'LAUNCH' THEN 'LEISURE'    
    WHEN VTY.VTY_ID = 'PFERRY' THEN 'LEISURE'    
    WHEN VTY.VTY_ID = 'PN' THEN 'LEISURE'    
    WHEN VTY.VTY_ID = 'PNSMD' THEN 'LEISURE'    
    WHEN VTY.VTY_ID = 'PSC' THEN 'LEISURE'    
    WHEN VTY.VTY_ID = 'VFERRY' THEN 'LEISURE'    
    WHEN VTY.VTY_ID = 'VHOVER' THEN 'LEISURE'    
    WHEN VTY.VTY_ID = 'YAT' THEN 'LEISURE'    
    WHEN VTY.VTY_ID = 'HVL' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'LN' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'TUG' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'ACO' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'ACSS' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'CGRV' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'CON' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'DRILL' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'DSV' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'DSVS' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'FPSO' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'FSO' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'FSV' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'HVLO' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'IMRV' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'JUU' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'MODU' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'MOU' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'OA' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'OSB' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'OSHORE' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'OSR' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'OTUG' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'PATB' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'PIP' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'PPU' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'PSV' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'RIG' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'SB' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'SBY' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'SEI' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'SPJU' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'SRV' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'SVG' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'TU' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'UTV' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'WIU' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'AcOfSh' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'ICEB' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID = 'TDP' THEN 'OFFSHORE'    
    WHEN VTY.VTY_ID IS NULL THEN NULL    
    ELSE 'CARGO'    
  END AS Sector,     
     
     bb.VGT_Desc as VESSEL_GENERAL_SUB_TYPE,-- added 20.05    
    SIT_Name as Technicaloff , -- tech+resp addded 26.05    
    --dd.VMO_Desc  as ManagementType,     
    case when aa.SMO_ID='GLAS00059036' then 'TP Crew Supply' Else ISNULL(dd.VMO_Desc,'UNKNOWN') end AS ManagementType,    
    vest.VSS_Name     
    into #tmpvesselsfinal    
  from #tmpVessels aa    
  left join shipsure.dbo.VESCharacteristics v1 on aa.VES_ID = v1.VES_ID    
  left join shipsure.dbo.company cc on cc.cmp_id = aa.ves_ownergrp    
  left join shipsure.dbo.vesmanofftype dd on dd.vmo_id = aa.vmo_id    
  left join shipsure.dbo.GLOBALSITE ee on ee.SIT_ID = aa.SMO_ID     
  left join shipsure.dbo.vestype VTY on VTY.VTY_ID = aa.VTY_ID     
  inner join shipsure.dbo.VESGENTYPE bb  on vty.VTY_GenType = bb.VGT_ID-- added 20.05    
  left join shipsure.dbo.VESSTATUS vest on vest.vss_id=aa.vss_id    
  order by 2


Select 
DENSE_RANK() OVER ( PARTITION BY d.[crw_id] ORDER BY d.SET_EndDate desc) RN,
d.[CRW_ID],
pd.CRW_PID as pcn,
d.set_startdate,
d.set_enddate,
coalesce(d.RNK_ID_Budgeted,d.RNK_ID,pd.RNK_ID) as rnk_id,
r.[RNK_Description] as rank,
cat.CCA_Description as RankCategory, 
dep.dep_name as Department,
nt.NAT_Description as Nationality,
pd.CRW_CrewManagementOff as MobilisationOffice_ID,
c.CMP_Name as MobilisationOffice,    
pd.CRW_ShipManagementOff as  SMO_ID ,     
c1.cmp_name as SMO,    
pd.CRW_OwnerPool as Client_ID,    
c2.CMP_Name as Client,    
pd.CPL_ID as PlanningCell_ID,    
p.CPL_Description as PlanningCell,    
pd.CPL_ID_PLAN as MobilisationCell_ID,    
p1.CPL_Description as MobilisationCell,
NULL as CurrentStatus,
NULL as PlanningStatus,
d.VES_ID,
v.VES_Name,  
v.vestype,
v.sector,    
v.ManagementType , 
sct.CCN_Description AS [Crew Contract Type]

into #onboardltm

from shipsure.dbo.CRWSrvDetail d
left join shipsure.dbo.CRWPersonalDetails pd on pd.crw_id = d.crw_id
left join shipsure.dbo.CRWRanks r on r.rnk_id=coalesce(d.RNK_ID_Budgeted,d.RNK_ID,pd.RNK_ID)  
left join shipsure.dbo.CRWRankCategory cat on cat.CCA_ID=r.CCA_ID
left join shipsure.dbo.department dep on dep.dep_id=r.DEP_ID    
left join shipsure.dbo.NATIONALITY nt on nt.nat_id=pd.nat_id 
left join shipsure.dbo.company c on c.cmp_id=pd.CRW_CrewManagementOff    
left join shipsure.dbo.company c1 on c1.cmp_id=pd.CRW_ShipManagementOff    
left join shipsure.dbo.company c2 on c2.cmp_id=pd.CRW_OwnerPool 
left join shipsure.dbo.crwpool p on p.CPL_ID=pd.CPL_ID_plan    
left join shipsure.dbo.crwpool p1 on p1.CPL_ID=pd.CPL_ID    
left join #tmpvesselsfinal v on v.ves_id=d.ves_id 
LEFT JOIN shipsure..CRWSrvContractType sct ON sct.CCN_ID = pd.crw_employmenttype
WHERE
pd.CRW_Cancelled=0 
AND  cast(d.SET_EndDate as date) > @Date and cast(d.SET_EndDate as date) < '2025-09-30'  --only onboard past 360 days / 1 year, last day of the month reporting
AND CAST( d.SET_StartDate as date) <= cast( d.SET_EndDate    as date) --end date must be greater than start date
and (d.sas_id not in (0,3) or d.sas_id is null)
and d.STS_ID = 'OB' --onboard services
and  d.SET_PreviousExp = 0    
and d.SET_Cancelled=0
and (d.VES_ID is null or d.VES_ID not IN ('GLAX00012386', 'GLAT00000027'))
and cat.CCA_Description in ('Officers', 'Senior Officers')
and v.sector = 'CARGO'
and (sct.CCN_Description is null or sct.CCN_Description <> 'Third Party Crew')

select * from #onboardltm
where rn = 1

drop table #tmpvessels
drop table #tmpvesselsfinal
drop table #onboardltm


--select * from shipsure..CRWSrvContractType