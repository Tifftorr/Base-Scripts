USE [Aggregates]
GO

/****** Object:  StoredProcedure [dbo].[procCRW_MOB_APP_Doc]    Script Date: 20/08/2024 14:35:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[procCRW_MOB_APP_Doc]    
 --exec  dbo.procCRW_MOB_APP_Doc    
    
     
AS    
begin tran    
    
     
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
    
 --Active Seafarers    
select     
pd.crw_id,    
pd.crw_pid as PCN,    
coalesce(d.RNK_ID_Budgeted,d.RNK_ID,pd.RNK_ID) as Rnk_id,    
r.RNK_Description as Rank,    
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
mt.STS_Desc CurrentStatus,    
d.ves_id,    
v.VES_Name,    
v.sector,    
v.vestype,    
v.VESSEL_GENERAL_SUB_TYPE,    
v.ManagementType  ,  
PD.CRW_EmploymentType 
/*  
CASE WHEN TPA.CCN_DESCRIPTION IS NULL AND   CRW_3rdPartyAgent is not null THEN 'Third Party Crew'  
   WHEN TPA.CCN_DESCRIPTION IS NULL AND PD.crw_OwnerSeafarer  = 1 THEN 'Owner Supplied'  
    WHEN TPA.CCN_DESCRIPTION IS NULL THEN 'Internal Supply'  
  ELSE TPA.CCN_DESCRIPTION END AS SupplyType*/  
into #ActiveSeafarers    
from shipsure.dbo.CRWPersonalDetails pd    
left join shipsure.dbo.CRWSrvDetail d on d.CRW_ID=pd.CRW_ID    
left join shipsure.dbo.CRWRanks r on r.rnk_id=coalesce(d.RNK_ID_Budgeted,d.RNK_ID,pd.RNK_ID)    
left join shipsure.dbo.CRWRankCategory cat on cat.CCA_ID=r.CCA_ID    
left join shipsure.dbo.department dep on dep.dep_id=r.DEP_ID    
left join shipsure.dbo.CRWMovementTypes mt on mt.sts_id=d.STS_ID    
left join shipsure.dbo.company c on c.cmp_id=pd.CRW_CrewManagementOff    
left join shipsure.dbo.company c1 on c1.cmp_id=pd.CRW_ShipManagementOff    
left join shipsure.dbo.company c2 on c2.cmp_id=pd.CRW_OwnerPool    
left join shipsure.dbo.crwpool p on p.CPL_ID=pd.CPL_ID_plan    
left join shipsure.dbo.crwpool p1 on p1.CPL_ID=pd.CPL_ID    
left join shipsure.dbo.NATIONALITY nt on nt.nat_id=pd.nat_id    
left join #tmpvesselsfinal v on v.ves_id=d.ves_id   
--Left Join Shipsure.dbo.CRWSrvContractType TPA ON TPA.CCN_ID =  PD.CCN_ID  
where     
pd.CRW_Cancelled=0     
and r.RNK_ValidSupn=0    
AND  d.SET_EndDate > GETDATE()-360    
AND  CAST(d.SET_StartDate as date) <= cast(d.SET_EndDate   as date)  
and (d.sas_id not in (0,3) or d.sas_id is null)    
 and ((  mt.STS_ValidSearch=1 and mt.STS_Active=1) or mt.sts_id = 'IT') AND mt.STS_ID <> 'PM'    
 and  d.SET_PreviousExp = 0    
  and d.SET_Cancelled=0    
 and d.SET_ActiveStatus=1    
 and (d.VES_ID is null or d.VES_ID not IN ('GLAX00012386', 'GLAT00000027'))    
 and (p.CPL_Description not like '%test%' or p.CPL_Description is null)    
    
 --Next Assignment    
     
  --GET NEXT PLANNED VESSEL       
  SELECT *    
  INTO #NEXT_VESSEL    
  FROM (    
    SELECT DISTINCT TC.CRW_ID, CSA.CSA_Description AS PlanningStatus, tv.ves_id as Next_Vessel_ID,TV.VES_NAME AS NEXT_VESSEL,     
        TV.CLIENT AS NEXT_VESSEL_CLIENT, VV.VMO_Desc, TV.VesType,     
        TV.sector, TV.VESSEL_GENERAL_SUB_TYPE, tv.ManagementType,    
        cast(SD.SET_STARTDATE as date) AS PLAN_TO_JOIN,    
            
        DENSE_RANK() OVER (    
             PARTITION BY TC.CRW_ID    
             ORDER BY SET_STARTDATE, SET_UpdatedOn ASC) LV    
  FROM #ActiveSeafarers TC       
  INNER JOIN shipsure.dbo.CRWSRVDETAIL SD (NOLOCK) ON SD.CRW_ID = TC.CRW_ID     
  INNER JOIN shipsure.dbo.CRWAssignedStatus  CSA ON CSA.CSA_ID = SD.CSA_ID    
  LEFT JOIN #tmpvesselsfinal TV ON TV.VES_ID = SD.VES_ID    
  LEFT JOIN shipsure.dbo.VesManOffType VV ON VV.VMO_ID = TV.VMO_ID     
  WHERE SET_ACTIVESTATUS = 0    
  AND  SAS_ID = 3     
  AND  SET_CANCELLED = 0    
  AND  STS_ID = 'OB'    
  AND  SGT_ID IS NULL    
  AND  SD.VES_ID IS NOT NULL    
  AND  SD.CRW_ID IS NOT NULL    
  AND  SD.CSA_ID IN ('VSHP00000001', 'VSHP00000002','VSHP00000004','VSHP00000011')    
  ) AA    
  WHERE LV = 1     
  order by 1    
  -----------LAST VESSEL-----------    
        
  SELECT  *    
  INTO #LAST_VESSEL    
  FROM (    
    SELECT DISTINCT TC.CRW_ID, TV.ves_id as LAST_VESSEL_ID,TV.VES_NAME AS LAST_VESSEL, TV.CLIENT AS LAST_VESSEL_CLIENT, set_startdate, set_enddate as LastSignOff,    
        tv.ManagementType,  VV.VMO_Desc  ,  TV.vestype, TV.sector, TV.VESSEL_GENERAL_SUB_TYPE,    
    DENSE_RANK() OVER (    
         PARTITION BY TC.CRW_ID    
         ORDER BY SET_STARTDATE desc, sd.set_updatedon desc, sd.set_id asc) LV    
  FROM #ActiveSeafarers TC       
  INNER JOIN shipsure.dbo.CRWSRVDETAIL SD ON SD.CRW_ID = TC.CRW_ID    
  LEFT JOIN #tmpvesselsfinal TV ON TV.VES_ID = SD.VES_ID    
  LEFT JOIN shipsure.dbo.VesManOffType VV ON VV.VMO_ID = TV.VMO_ID     
  WHERE SAS_ID = 2     
  AND SET_ACTIVESTATUS = 0    
  AND SET_CANCELLED = 0    
  AND STS_ID = 'OB'    
  AND SET_PreviousExp = 0    
  AND SD.VES_ID IS NOT NULL    
  AND SGT_ID IS NOT NULL    
  ) AA    
  WHERE LV = 1     
    
  --LAST VESSEL PREVIOUS EXPERIENCE--------    
        
  SELECT  *    
  INTO #LAST_VESSEL_PREV_EXP    
  FROM (    
    SELECT DISTINCT TC.CRW_ID, TV.ves_id as LAST_VESSEL_PREV_ID,TV.VES_NAME AS LAST_VESSEL_PREV, TV.CLIENT AS LAST_VESSEL_CLIENT, set_startdate, set_enddate as LastSignOff,    
       tv.ManagementType,   VV.VMO_Desc  ,  TV.vestype, TV.sector, TV.VESSEL_GENERAL_SUB_TYPE,    
    DENSE_RANK() OVER (    
         PARTITION BY TC.CRW_ID    
         ORDER BY SET_STARTDATE desc, sd.set_updatedon desc, sd.set_id asc) LV    
  FROM #ActiveSeafarers TC       
  INNER JOIN shipsure.dbo.CRWSRVDETAIL SD ON SD.CRW_ID = TC.CRW_ID    
  LEFT JOIN #tmpvesselsfinal TV ON TV.VES_ID = SD.VES_ID    
  LEFT JOIN shipsure.dbo.VesManOffType VV ON VV.VMO_ID = TV.VMO_ID     
  WHERE SAS_ID = 2     
  AND SET_ACTIVESTATUS = 0    
  AND SET_CANCELLED = 0    
  AND STS_ID = 'OB'    
  AND SET_PreviousExp = 0    
  AND SD.VES_ID IS NOT NULL    
  AND SGT_ID IS NOT NULL    
  ) AA    
  WHERE LV = 1     
    
   -- v.ships services    
   SELECT TC.CRW_ID  as Crw_id, COUNT(SET_ID) AS VSHIPS_SERVICE_COUNT    
   INTO #tmpServiceCount    
   FROM #ActiveSeafarers tc    
   INNER JOIN shipsure.dbo.CRWSRVDETAIL SD (NOLOCK) ON SD.CRW_ID = TC.CRW_ID    
   WHERE (SAS_ID IS NULL OR SAS_ID <> 3)     
   AND  SET_ACTIVESTATUS = 0    
   AND  SET_CANCELLED = 0    
   AND  SET_PreviousExp = 0    
   AND  STS_ID IN ('OB', 'OV')    
   AND  SD.VES_ID IS NOT NULL    
   GROUP BY TC.CRW_ID    
    
 Insert into CREW_AppDocuments    
     
 select     
dd.datekey,    
cast(getdate() as date) as InsertedON,    
 ACS.CRW_ID,    
  acs.PCN,    
  acs.Rnk_id,    
  acs.Rank,    
  acs.RankCategory,    
  acs.Department,    
  acs.Nationality,    
  acs.MobilisationOffice_ID,    
  acs.MobilisationOffice,    
  acs.SMO_ID,    
  acs.SMO,    
  acs.Client_ID,    
  acs.Client,    
  acs.PlanningCell_ID,    
  acs.PlanningCell,    
  acs.MobilisationCell_ID,    
  acs.MobilisationCell,    
  acs.CurrentStatus,     
  coalesce(acs.ves_id, na.Next_Vessel_ID, lv.last_Vessel_ID, lvp.LAST_VESSEL_PREV_ID, 'NO VESSEL') as VESSEL_ID_FINAL,    
  case when coalesce(acs.ves_id, na.Next_Vessel_ID, lv.last_Vessel_ID, lvp.LAST_VESSEL_PREV_ID) is null  then 'NO VESSEL'    
   else coalesce(acs.ves_name, na.NEXT_VESSEL, lv.LAST_VESSEL, lvp.LAST_VESSEL_PREV) end as VESSEL_NAME_FINAL,    
  case when coalesce(acs.ves_id, na.Next_Vessel_ID, lv.last_Vessel_ID, lvp.LAST_VESSEL_PREV_ID) is null  then 'NO VESSEL TYPE'    
   else coalesce(acs.vestype, na.vestype, lv.vestype, lvp.vestype) end as VESSEL_TYPE_FINAL,    
  case when coalesce(acs.ves_id, na.Next_Vessel_ID, lv.last_Vessel_ID, lvp.LAST_VESSEL_PREV_ID) is null  then 'CARGO'    
   else coalesce(acs.sector, na.sector, lv.sector, lvp.sector) end as SECTOR_FINAL,    
  case when coalesce(acs.ves_id, na.Next_Vessel_ID, lv.last_Vessel_ID, lvp.LAST_VESSEL_PREV_ID) is null  then 'NOT IN MANAGEMENT'    
   else coalesce(acs.ManagementType, na.ManagementType, lv.ManagementType, lvp.ManagementType) end as Management_type_FINAL,    
      
 cl.ETT_ID as AttachementID,    
 cl.ETT_CreatedBy as UploadedBy,     
 cl.ETT_CreatedOn as UploadedOn,    
 cl.ETT_UpdateBy as UpdatedBy,    
 cl.ETT_UpdateOn as UpdatedOn,    
 case when cl.ETT_CreatedBy in ('VGRP00003738') or cl.ETT_CreatedBy='SYSTEM' then 'Seafarer' else 'Office' end as UploadedByUnit,    
 cl.ETT_Desc as 'Description',    
 cl.ETT_FileName as FileName,      
 cl.FK_MATCHED_ID as DocumentID,    
 doc.CRD_Comments Comments,     
 mast.DOC_Desc as Name ,    
 st.DST_Description as Status  ,  
 acs.CRW_EmploymentType ,
doc.CRD_Country
 from #ActiveSeafarers acs    
 join shipsure.dbo.CLOUD_ENTITY_SCANNED cl on cl.CRW_ID=acs.CRW_ID    
 join shipsure.dbo.CRWDocs doc on doc.CRD_ID=cl.FK_MATCHED_ID and doc.crw_id=acs.CRW_ID and doc.CRW_ID=cl.CRW_ID    
 join shipsure.dbo.CRWDocMaster mast on mast.DOC_ID=doc.DOC_ID    
 join shipsure.dbo.CRWDocStatus st on st.dst_id=doc.DST_ID    
left Join datedimension dd  on cast(dd.actualdate as date)=cast(getdate() as date)    
Left join #NEXT_VESSEL NA on NA.CRW_ID=ACS.CRW_ID    
Left Join #LAST_VESSEL lv on lv.crw_id=acs.crw_id    
Left Join #LAST_VESSEL_PREV_EXP lvp on lvp.crw_id=acs.crw_id    
left join #tmpServiceCount vsc on vsc.crw_id=acs.CRW_ID    
where  CAST(cl.ETT_CreatedOn as date) =cast(getdate()-1  as date)  
 and  cl.ETT_Cancelled=0    
 and doc.dst_id in ('GLAS00000004','GLAS00000015','GLAS00000016','GLAS00000017')    
 and (na.PlanningStatus is not null  or VSHIPS_SERVICE_COUNT > 0 or acs.CurrentStatus = 'onboard')    
 and pcn is not null    
   and ETT_Reference_2 not in ('GLAS00000024','GLAS00000025','GLAS00000014','GLAS00000001','GLAS00000004','GLAS00000005','GLAS00000006','GLAS00000008','GLAS00000009','GLAS00000031','GLAS00000032')  
  
 drop table #ActiveSeafarers    
    
     
  if @@ERROR <> 0       
  rollback tran      
     
     
  commit tran    
  go;    
GO


