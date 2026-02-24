use shipsure
go

/*SELECT * 
INTO #Vaccinated
FROM (
SELECT
COVVAC.CCV_ID,
COVVAC.CRD_ID,
DOC_ID,
DOCS.CRW_ID ,
CCV_VaccineCompletedOn,
CCV_Vaccinedate,
row_number() over(partition by crw_id order by CCV_VaccineCompletedOn asc) rn
FROM [Shipsure].dbo.CRWCovidVaccine COVVAC
LEFT JOIN [Shipsure].dbo.CRWDOCS DOCS ON DOCS.CRD_ID=COVVAC.CRD_ID
LEFT JOIN [Shipsure].dbo.ATTRIBUTEDEF DD ON DD.BITVALUE=COVVAC.CCV_VaccineType AND DD.TABLENAME='CovidVaccineType'
WHERE CCV_CANCELLED=0 and CRD_Cancelled=0
AND(((cast(CCV_VaccineCompletedOn as date)>='01-dec-2020'and CCV_VaccineCompletedOn<=GETDATE()) ) )
and (CCV_VACCINETYPE IS NULL OR CCV_VACCINETYPE!=6 )
--and CRW_ID='GLAS00044540'
and DOCS.DOC_ID='VGR400000590'
) LH where rn=1


SELECT * 
INTO #VaccinatedBoosters
FROM (
SELECT
COVVAC.CCV_ID,
COVVAC.CRD_ID,
DOCS.CRW_ID ,
COALESCE(CCV_VaccineCompletedOn,CCV_Vaccinedate) as CCV_VaccineCompletedOn,
CCV_Vaccinedate,
row_number() over(partition by crw_id order by CCV_VaccineCompletedOn desc,CCV_Vaccinedate asc) rn
FROM [Shipsure].dbo.CRWCovidVaccine COVVAC
LEFT JOIN [Shipsure].dbo.CRWDOCS DOCS ON DOCS.CRD_ID=COVVAC.CRD_ID
LEFT JOIN [Shipsure].dbo.ATTRIBUTEDEF DD ON DD.BITVALUE=COVVAC.CCV_VaccineType AND DD.TABLENAME='CovidVaccineType'
WHERE CCV_CANCELLED=0 and CRD_Cancelled=0
AND(((cast(CCV_VaccineCompletedOn as date)>='01-dec-2020'and CCV_VaccineCompletedOn<=GETDATE()) ) or CCV_VaccineCompletedOn is null)
and (CCV_VACCINETYPE=6 )
--and CRW_ID='ODES00006510'
) LH where rn=1

--select * from  [Shipsure].dbo.CRWCovidVaccine COVVAC where ccv_cancelled=0 

Select CRW_ID, CRD_ID,cd.DOC_ID, CRD_ISSUED,CRD_CREATEDON , DM.DOC_Desc as ExemptionName
INTO #COVIDEXEMP
from crwdocs cd
LEFT JOIN CRWDocMaster DM ON DM.DOC_ID=cd.DOC_ID
WHERE
CRD_CANCELLED=0 
AND
CD.DOC_ID IN ('VGR400000759','VGR400000760','VGR400000761','VGR400000762')
AND DST_ID='GLAS00000004'
AND (CRD_Expiry>=GETDATE() OR CRD_Expiry IS NULL)*/


CREATE TABLE #ExternalManagers(
CMT_ID VARCHAR(6),
CompanyType VARCHAR(30),
CMP_ID VARCHAR(12),
CompanyName  VARCHAR(255),
CMS_ID VARCHAR(12)
)
INSERT INTO #ExternalManagers
			select distinct
			CT.CMT_ID,
			CT.CMT_Desc AS CompanyType,
			CC.CMP_ID,
			CC.CMP_Name AS CompanyName,
			CMS_ID
			
			from 
			Shipsure.dbo.COMPANY CC 
			INNER JOIN SHIPSURE.DBO.COMPSERV SR ON SR.CMP_ID=CC.CMP_ID
			INNER JOIN Shipsure.dbo.CompType CT ON CT.CMT_ID=SR.CMT_ID
			where  SR.CMT_ID in ('EXTMGR')
			and(CMS_Deleted=0  or CMS_Deleted is null) --Service not DELETED
			AND CMP_DELETED=0 -- Company not DELETED
			and CMP_Name not like '%TEST%'


	
	  declare @sDateTime as datetime
       select @sDateTime = '01-SEP-2022'


	   SELECT * into #tmpVes FROM (
select
vd.vmd_id,
vd.vmo_id,
v.ves_id
, v.VES_Name
, v.VES_IMOnumber as IMONo
, ct.CNT_Desc as VesFlag
, ves_flag
,vtg.VGT_Desc as VESSEL_GENERAL_SUB_TYPE
, vty_desc as 'VesType'
, 'VesGenType' = case when vt.VTY_ID IN ('BH','BN','BNL','CEM','LOG','MBC','SU','CH1','CH2','CH3','CH4','TC','MA','MB','BC','CN','CNL','CNS','RGC','BAR','DA','DC','DN','DRG','FSH','GCR','LT','NVY','OTH','OV','SLG','UN','LIV','WF','TH','TG','TGE','RF','WA','WB','WD','NHTANK','O/O','PTANK','TANKER','TD','TNB','TNS','TNV','TO','TR') then 'CARGO'
                        when vt.VTY_ID IN ('HVL','LN','TUG','ACO','ACSS','CGRV','CON','DRILL','DSV','DSVS','FPSO','FSO','FSV','HVLO','IMRV','JUU','MODU','MOU','OA','OSB','OSHORE','OSR','OTUG','PATB','PIP','PPU','PSV','RIG','SB','SBY','SEI','SPJU','SRV','SVG','TU','UTV','WIU','AcOfSh','ICEB','TDP') then 'OFFSHORE'
                        when vt.VTY_ID IN ('CASINO','HOVER','HSC','HYDRO','LAUNCH','PFERRY','PN','PNSMD','PSC','VFERRY','VHOVER','YAT') then 'LEISURE'
                        else 'N/A' end,
						cpt.sit_name as TechnicalOfficeID
, cpt.sit_name as TechOffice
, cpr.sit_name as RespOffice
, cpc.sit_name as CrewOffice
, cmp.CMP_Name as Client,
FLEET,
cmp.CMP_id as ClientID,
vgg.VGG_Description as VesselGenericGroupType,
 ManagementType = case when COALESCE(ot.CMP_ID,ro.CMP_ID,v.VES_OffTech,v.VES_RespOff)='GLAS00059036' then 'TP Crew Supply' Else ISNULL(vm.VMO_Desc,'UNKNOWN') end
 , ROW_NUMBER() OVER(partition by v.VES_ID ORDER BY vd.VMD_MANAGEStart DESC) AS Row

from shipsure..vessel v
left join shipsure..VESMANAGEMENTDETAILS vd (NOLOCK) on vd.VES_ID=v.VES_ID  
inner join shipsure..vestype vt (NOLOCK) ON vt.vty_id = v.vty_id 
left join shipsure.dbo.VesTypeGenGroup vgg on vgg.vgg_id=vt.vgg_id
inner join shipsure..VesTypeGroup vg (NOLOCK) ON vg.VTG_ID = vt.VTG_ID 
LEFT JOIN shipsure.dbo.VESGENTYPE vtg  on vt.VTY_GenType = vtg.VGT_ID
LEFT JOIN shipsure..VESOFFICESERVICE ot (NOLOCK) ON ot.VMD_ID = VD.VMD_ID AND ot.VOS_Deleted = 0 AND ot.VOT_ID IN ('GLAS00000005') -- technical office
LEFT JOIN shipsure..VESOFFICESERVICE ro (NOLOCK) ON ro.VMD_ID = VD.VMD_ID AND ro.VOS_Deleted = 0 AND ro.VOT_ID IN ('GLAS00000003') -- responsible office
LEFT JOIN shipsure..VESOFFICESERVICE co (NOLOCK) ON co.VMD_ID = VD.VMD_ID AND co.VOS_Deleted = 0 AND co.VOT_ID IN ('GLAS00000006') -- crew office
left join shipsure..globalsite cpt (NOLOCK) on cpt.sit_id=ot.CMP_ID
left join shipsure..globalsite cpr (NOLOCK) on cpr.sit_id=ro.CMP_ID
left join shipsure..globalsite cpc (NOLOCK) on cpc.sit_id=co.CMP_ID
left join shipsure..company cmp (NOLOCK) on cmp.cmp_id = VD.VMD_Owner
left join shipsure..COUNTRY ct (NOLOCK) on ct.CNT_ID=v.VES_Flag
LEFT JOIN shipsure.dbo.vesmanofftype (nolock)  vm on vm.vmo_id = vd.vmo_id
left join (select * from (SELECT	DISTINCT VES_ID, FLT_Desc AS FLEET, aa.FLT_ID, DENSE_RANK() OVER (PARTITION BY BB.VES_ID ORDER BY  BB.FLV_UPDATEDON ) LV
								FROM	shipsure.dbo.FLEET AA
								INNER JOIN shipsure.dbo.FLTVESS BB ON BB.FLT_ID = AA.FLT_ID 
								WHERE	FLT_Type = 'F' and dep_id = 'TECH'
								AND		FLT_ACTIVE = 1)ID where lv=1) fl on fl.VES_ID=v.ves_id
where 
(vd.VMD_ManageEnd is null or vd.VMD_ManageEnd>getdate()) ) LH where Row=1

 select distinct sd.CRW_ID as crw_id,
										pd.crw_pid,
											pd.crw_surname,
										pd.crw_forename,
										n.NAT_Description ,
                                          case when cast(sd.SET_StartDate as date)='01-JAN-2022' then '31-DEC-2021' else cast(sd.SET_StartDate as date) end as SET_StartDate,
                                         cast(sd.SET_EndDate as date) as SET_EndDate,
                                         p.PRT_Name as LoadPort,
                                         c.CNT_Desc,
                                         sd.ves_id, 
										 coalesce(vms.VMD_VesselName,VES_Name) as  ves_name,
                                         cp.CMP_Name as MobilisationOffice,
										 cp1.CMP_Name as PlanningOffice,
										 mob.CPL_Description as MobilisationCell,
										 pl.CPL_Description as PlanningCell,
										 pl1.CPL_Description as CMPCell,
                                         SGT_Desc  as SignOffReason,
                                         'SignOn' as Action,
										 -- cast(sd.SET_StartDate as date) as ActivityDate,
                                         case  --when sd.crw_id='VGRP00046359' and cast(sd.SET_StartDate as date)='26-DEC-2021' then cast(sd.SET_StartDate as date)
										 when  cast(sd.SET_StartDate as date)>='26-DEC-2021' AND cast(sd.SET_StartDate as date)<='31-DEC-2021' then '01-JAN-2022' else cast(sd.SET_StartDate as date) end as ActivityDate,
										 cast(sd.SET_StartDate as date)  as ActivityDateForMonth,
                                        cast(   ( datediff(day, sd.SET_StartDate, getdate())) as int)  as DaysPastMovement,
										rank.rnk_description,
										--case when vacc.crw_id is not null and vacc.CCV_Vaccinedate<=sd.SET_StartDate then vacc.crw_id end as '1stVaccinatedatSignOn',
										--case when vacc.crw_id is not null and vacc.CCV_VaccineCompletedOn<=sd.SET_StartDate then vacc.crw_id when vaccbb.crw_id is not null and vaccbb.CCV_VaccineCompletedOn<=sd.SET_StartDate then vaccbb.crw_id   end as FullVaccinatedatSignOn,
										--case when exep.crw_id is not null and exep.CRD_ISSUED<=sd.SET_StartDate and ( vacc.crw_id is null OR (vacc.crw_id is not null and vacc.CCV_VaccineCompletedOn>sd.SET_StartDate)) AND (vaccbb.crw_id is  null or (vaccbb.crw_id is not null and vaccbb.CCV_VaccineCompletedOn>sd.SET_StartDate))  then exep.crw_id end as ExemptionAtSignON,
										1 as ChangeCount,
										coalesce(sd.vmd_id,v.vmd_id) as VMD_ID,
										coalesce(sd.vmo_id,v.vmo_id) as VMO_ID,
										--vm.VMO_Desc as ManagementType,
										case  when srv.cmp_id not in  ('GLAS00059036','GLAS00063848') then 'TP Crew Supply' when Vm.VMO_ID='GLAS00000003' then 'Full Management' else Vm.VMO_Desc  end as ManagementType,
										coalesce(sd.set_SMO,ot.CMP_ID) as SMO_ID,
										sit.sit_name as TechnicalOffice,
										VesGenType as Sector,
										case when set_vesclient='' then ClientID else coalesce(set_vesclient,ClientID) end as ClientID,
										--coalesce(set_vesclient,ClientID) as ClientID,
										cmp.cmp_name as Client,
										VesselGenericGroupType,
										case when sit.sit_name is not null and srv.cmp_id is not null and Vm.VMO_ID in ('GLAS00000003','GLAS00000007') and srv.cmp_id not in  ('GLAS00059036','GLAS00063848') then 'External' 
										 when sit.sit_name is not null and srv.cmp_id is not null and Vm.VMO_ID in ('GLAS00000003','GLAS00000007') and srv.cmp_id  in  ('GLAS00059036','GLAS00063848')  and coalesce(sd.SET_ContractType,pd.crw_employmenttype) ='VSHP00000002' then 'External' 
										else 'Internal'  end as ShipManagerType,
										cat.CCA_Description as RankCategory,
										dep.DEP_Name as Department,
										ISNULL(tpa.CCN_Description,'Internal Supply') as EmploymentType
										,MCH_ID as CheckListID
										, case when MCH_ID IS not null and MCH_Status='GLAS00000002' then MCH_ID end as CheckListSignedOff 
										,case	WHEN MCH_ID IS not null and MCH_Status='GLAS00000001' then MCH_ID end as CheckListActive
										,FLEET
										,VESSEL_GENERAL_SUB_TYPE
										,CMM.TRI_ArrivalDate as TravelArrivalDate
										,CMM.TRI_DepartureDate as TravelDepartureDate
										,CMM.TRI_From as TravelFrom
										,CMM.TRI_To as TravelTo
										,CMM.TRI_BookingRef as BookingPNR
										,ATT.AttributeDesc as TravelProvider
										,ATT1.AttributeDesc as TravelStatus
										,lnp.lnp_id
										,LNP_Desc as LineUp
										,lnp.lnp_completedon
										,lnp.lnp_notes
										,lnp.lnp_createdby as lnp_createdby_id
										,USR.usr_displayname as [Createdby]
										,TSE_DETAILS AS FlightDetails
              into #Onsigners
              from          shipsure.dbo.CRWSrvDetail sd (nolock) 
              INNER join    shipsure.dbo.CRWPersonalDetails pd  (nolock)  on pd.CRW_ID=sd.CRW_ID and pd.CRW_Cancelled=0
              LEFT join     shipsure.dbo.CRWSignOffType cc (nolock)  on cc.SGT_ID = sd.SGT_ID 
              LEFT join     shipsure.dbo.company cp (nolock)  on cp.cmp_id=pd.CRW_CrewManagementOff
			   LEFT join     shipsure.dbo.company cp1 (nolock) on cp1.cmp_id=pd.CRW_SecondedOffice 
			  LEFT join     shipsure.dbo.CRWPool mob (nolock) on mob.cpl_id=pd.CPL_ID
			  LEFT join     shipsure.dbo.CRWPool pl (nolock) on pl.cpl_id=pd.CPL_ID_plan
			  lEFT join     shipsure.dbo.CRWPool pl1 (nolock) on pl1.cpl_id=pd.CPL_ID_cmp
              LEFT join     shipsure.dbo.PORT p (nolock) on p.PRT_ID=sd.SET_LoadPortID
              LEFT join     shipsure.dbo.country c (nolock) on c.CNT_ID=p.CNT_ID
			  INNER join shipsure.dbo.NATIONALITY n (nolock) on n.nat_id=pd.nat_id
			  left join shipsure.dbo.crwranks rank (nolock) on rank.rnk_id=sd.rnk_id
			  LEFT join #tmpVes v (nolock) on v.ves_id=sd.ves_id
			  LEFT join shipsure.dbo.VESMANAGEMENTDETAILS vms (nolock) on vms.vmd_id=coalesce(sd.vmd_id,v.vmd_id)
			  LEFT JOIN shipsure.dbo.vesmanofftype vm (nolock) on vm.vmo_id = coalesce(sd.vmo_id,v.vmo_id)
			  LEFT JOIN shipsure..VESOFFICESERVICE ot  (NOLOCK) ON ot.VMD_ID = VMS.VMD_ID AND ot.VOS_Deleted = 0 AND ot.VOT_ID IN ('GLAS00000005') -- technical office
			  LEFT JOIN Shipsure.dbo.globalsite sit (nolock) on sit.sit_id=coalesce(sd.set_SMO,ot.CMP_ID)
			 	  LEft Join Shipsure.dbo.company Cmp (nolock)  on cmp.cmp_id= (case when set_vesclient='' then ClientID else coalesce(set_vesclient,ClientID) end)
			  --Left Join #Vaccinated vacc on vacc.crw_id=sd.crw_id
			  -- Left Join #VaccinatedBoosters vaccbb on vaccbb.crw_id=sd.crw_id
			   --Left Join #COVIDEXEMP exep on exep.crw_id=sd.crw_id
			  Left Join Shipsure.dbo.CRWSrvContractType TPA ON TPA.CCN_ID =  pd.crw_employmenttype
			  Left Join CRWRankCategory cat on cat.CCA_ID=rank.CCA_ID
			  Left join department dep on dep.DEP_ID=rank.DEP_ID
			  Left Join Shipsure.dbo.compserv srv on srv.cmp_id=sit.sit_id and cmt_id='EXTMGR'and (EndDate is null or EndDate>=GETDATE()) and (srv.CMS_Deleted=0 or srv.CMS_Deleted  is null )
			  LEFT JOIN CRWMobilisationCheckListHeader MH ON MH.SET_ID=SD.SET_ID AND MH.MCH_Cancelled=0
			  LEFT JOIN CRWTravelMain CMM ON CMM.SET_ID=sd.SET_ID AND CMM.TRI_Cancelled=0 AND CMM.TRI_TravelType=10
			  LEFT JOIN CRWTravelSegments CMS ON CMS.TRI_ID=CMM.TRI_ID AND CMS.TSE_CANCELLEd=0 AND CMS.TSE_TYPE=10
			  LEFT JOIN AttributeDef ATT ON ATT.AttributeName=CMM.TRI_TravelProvider AND ATT.TableName='TravelProvider'
			  LEFT JOIN AttributeDef ATT1 ON ATT1.AttributeName=CMM.TRI_Status AND ATT1.TableName='TravelBookingStatus'
			  LEFT JOIN CRWLineups LNP ON LNP.LNP_ID=sd.LNP_ID_JOINER
			  left join shipsure.[dbo].[USERID] USR on USR.USR_ID = LNP.lnp_createdby
              where           sd.SET_Cancelled=0
              and           sd.SET_PreviousExp = 0
              and                        CRW_Cancelled = 0
              and           (sas_id is null or sas_id <> (3) )
              and           sd.STS_ID in ('OB','OV')
              and           cast(sd.SET_StartDate as DATE) >@sDateTime
              and           cast(sd.SET_StartDate as DATE) < GETDATE()
			 -- and (pd.crw_employmenttype is null or pd.crw_employmenttype <> 'VSHP00000002' or pd.CRW_EmploymentType <> 'VSHP00000003')
			--  and n.nat_description = 'Filipino'
			

              Select distinct sd.CRW_ID as crw_id,
										pd.crw_pid,
										pd.crw_surname,
										pd.crw_forename,
										n.NAT_Description ,
                                         case when cast(sd.SET_StartDate as date)='01-JAN-2022' then '31-DEC-2021' else cast(sd.SET_StartDate as date) end as SET_StartDate,
                                         cast(sd.SET_EndDate as date) as SET_EndDate,
                                         p.PRT_Name as LoadPort,
                                         c.CNT_Desc,
                                         sd.ves_id, 
										 coalesce(vms.VMD_VesselName,VES_Name) as  ves_name,
                                         cp.CMP_Name as MobilisationOffice,
										 cp1.CMP_Name as PlanningOffice,
										 mob.CPL_Description as MobilisationCell,
										 pl.CPL_Description as PlanningCell,
										 pl1.CPL_Description as CMPCell,
                                         cc.SGT_Desc  as SignOffReason,
                                         'SignOff' as Action,
										 --cast(sd.SET_EndDate as date) as ActivityDate,
										 case --when sd.crw_id='VGRP00046359' and cast(sd.SET_EndDate as date)='26-DEC-2021' then cast(sd.SET_EndDate as date)
										 when cast(sd.SET_EndDate as date)>='26-DEC-2021' AND cast(sd.SET_EndDate as date)<='31-DEC-2021' then '01-JAN-2022' else cast(sd.SET_EndDate as date) end as ActivityDate,
										 cast(sd.SET_EndDate as date)  as ActivityDateForMonth,
                                     cast(   ( datediff(day, sd.SET_EndDate, getdate())) as int)  as DaysPastMovement,
									 rank.rnk_description,
									-- case when vacc.crw_id is not null and vacc.CCV_Vaccinedate<=sd.SET_StartDate then vacc.crw_id end as '1stVaccinatedatSignOn',
									 --	case when vacc.crw_id is not null and vacc.CCV_VaccineCompletedOn<=sd.SET_StartDate then vacc.crw_id when vaccbb.crw_id is not null and vaccbb.CCV_VaccineCompletedOn<=sd.SET_StartDate then vaccbb.crw_id   end as FullVaccinatedatSignOn,
									--	case when exep.crw_id is not null and exep.CRD_ISSUED<=sd.SET_StartDate and ( vacc.crw_id is null OR (vacc.crw_id is not null and vacc.CCV_VaccineCompletedOn>sd.SET_StartDate)) AND (vaccbb.crw_id is  null or (vaccbb.crw_id is not null and vaccbb.CCV_VaccineCompletedOn>sd.SET_StartDate))  then exep.crw_id end as ExemptionAtSignON,
									 1 as ChangeCount,
										coalesce(sd.vmd_id,v.vmd_id) as VMD_ID,
										coalesce(sd.vmo_id,v.vmo_id) as VMO_ID,
										--vm.VMO_Desc as ManagementType,
										case  when srv.cmp_id not in  ('GLAS00059036','GLAS00063848') then 'TP Crew Supply' when Vm.VMO_ID='GLAS00000003' then 'Full Management' else Vm.VMO_Desc  end as ManagementType,
										coalesce(sd.set_SMO,ot.CMP_ID) as SMO_ID,
										sit.sit_name as TechnicalOffice,
										VesGenType as Sector,
										case when set_vesclient='' then ClientID else coalesce(set_vesclient,ClientID) end as ClientID,
										--coalesce(set_vesclient,ClientID) as ClientID,
										cmp.cmp_name as Client,
										VesselGenericGroupType,
										case when sit.sit_name is not null and srv.cmp_id is not null and Vm.VMO_ID in ('GLAS00000003','GLAS00000007') and srv.cmp_id not in  ('GLAS00059036','GLAS00063848') then 'External' 
										when sit.sit_name is not null and srv.cmp_id is not null and Vm.VMO_ID in ('GLAS00000003','GLAS00000007') and srv.cmp_id  in  ('GLAS00059036','GLAS00063848')  and coalesce(sd.SET_ContractType,pd.crw_employmenttype)='VSHP00000002' then 'External' 
										else 'Internal'  end as ShipManagerType,
										cat.CCA_Description as RankCategory,
										dep.DEP_Name as Department,
										ISNULL(tpa.CCN_Description,'Internal Supply') as EmploymentType
										,MCH_ID as CheckListID
										, case when MCH_ID IS not null and MCH_Status='GLAS00000002' then MCH_ID end as CheckListSignedOff 
										,case	WHEN MCH_ID IS not null and MCH_Status='GLAS00000001' then MCH_ID end as CheckListActive
										,FLEET
										,VESSEL_GENERAL_SUB_TYPE
										,CMM.TRI_ArrivalDate as TravelArrivalDate
										,CMM.TRI_DepartureDate as TravelDepartureDate
										,CMM.TRI_From as TravelFrom
										,CMM.TRI_To as TravelTo
										,CMM.TRI_BookingRef as BookingPNR
										,ATT.AttributeDesc as TravelProvider
										,ATT1.AttributeDesc as TravelStatus
										,lnp.lnp_id
										,LNP_Desc as LineUp
										,lnp.lnp_completedon
										,lnp.lnp_notes
										,lnp.lnp_createdby as lnp_createdby_id
										,USR.usr_displayname as [Createdby]
										,TSE_DETAILS AS FlightDetails
              into #OffSigners
              from shipsure.dbo.CRWSrvDetail sd
              INNER join    shipsure.dbo.CRWPersonalDetails pd (nolock) on pd.CRW_ID=sd.CRW_ID and pd.CRW_Cancelled=0
              LEFT join     shipsure.dbo.CRWSignOffType cc (nolock)  on cc.SGT_ID = sd.SGT_ID 
              LEFT join     shipsure.dbo.company cp (nolock)  on cp.cmp_id=pd.CRW_CrewManagementOff
			  LEFT join     shipsure.dbo.company cp1 (nolock)  on cp1.cmp_id=pd.CRW_SecondedOffice 
			  LEFT join     shipsure.dbo.CRWPool mob (nolock)  on mob.cpl_id=pd.CPL_ID
			  LEFT join     shipsure.dbo.CRWPool pl (nolock)  on pl.cpl_id=pd.CPL_ID_plan
			   lEFT join     shipsure.dbo.CRWPool pl1 (nolock) on pl1.cpl_id=pd.CPL_ID_cmp
              LEFT join     shipsure.dbo.PORT p (nolock)  on p.PRT_ID=sd.set_disportID
              LEFT join     shipsure.dbo.country c (nolock)  on c.CNT_ID=p.CNT_ID
			  INNER join shipsure.dbo.nationality n (nolock)  on n.nat_id=pd.NAT_ID
			  LEFT join shipsure.dbo.crwranks  rank (nolock)  on rank.rnk_id=sd.rnk_id
			  LEFT join #tmpVes v (nolock)  on v.ves_id=sd.ves_id
			  LEFT join shipsure.dbo.VESMANAGEMENTDETAILS vms (nolock)  on vms.vmd_id=coalesce(sd.vmd_id,v.vmd_id)
			  LEFT JOIN shipsure.dbo.vesmanofftype vm  (nolock)  on vm.vmo_id = coalesce(sd.vmo_id,v.vmo_id)
			  LEFT JOIN shipsure..VESOFFICESERVICE ot (NOLOCK) ON ot.VMD_ID = VMS.VMD_ID AND ot.VOS_Deleted = 0 AND ot.VOT_ID IN ('GLAS00000005') -- technical office
			  LEFT JOIN Shipsure.dbo.globalsite sit (nolock)  on sit.sit_id=coalesce(sd.set_SMO,ot.CMP_ID) 
			  LEft Join Shipsure.dbo.company Cmp (nolock)  on cmp.cmp_id= (case when set_vesclient='' then ClientID else coalesce(set_vesclient,ClientID) end)
			 -- Left Join #Vaccinated vacc on vacc.crw_id=sd.crw_id
			 -- Left Join #VaccinatedBoosters vaccbb on vaccbb.crw_id=sd.crw_id
			 --  Left Join #COVIDEXEMP exep on exep.crw_id=sd.crw_id
			  Left Join Shipsure.dbo.CRWSrvContractType TPA ON TPA.CCN_ID =  pd.crw_employmenttype
			  Left Join CRWRankCategory cat on cat.CCA_ID=rank.CCA_ID
			  Left join department dep on dep.DEP_ID=rank.DEP_ID
			  Left Join Shipsure.dbo.compserv srv on srv.cmp_id=sit.sit_id and cmt_id='EXTMGR' and (EndDate is null or EndDate>=GETDATE()) and (srv.CMS_Deleted=0 or srv.CMS_Deleted  is null )
			  LEFT JOIN CRWMobilisationCheckListHeader MH ON MH.SET_ID=SD.SET_ID AND MH.MCH_Cancelled=0
			  LEFT JOIN CRWTravelMain CMM ON CMM.SET_ID=sd.SET_ID AND CMM.TRI_Cancelled=0 AND CMM.TRI_TravelType=20
			   LEFT JOIN CRWTravelSegments CMS ON CMS.TRI_ID=CMM.TRI_ID AND CMS.TSE_CANCELLEd=0 AND CMS.TSE_TYPE=10
			  LEFT JOIN AttributeDef ATT ON ATT.AttributeName=CMM.TRI_TravelProvider AND ATT.TableName='TravelProvider'
			  LEFT JOIN AttributeDef ATT1 ON ATT1.AttributeName=CMM.TRI_Status AND ATT1.TableName='TravelBookingStatus'
			  LEFT JOIN CRWLineups LNP ON LNP.LNP_ID=sd.LNP_ID_LEAVER
			  left join shipsure.[dbo].[USERID] USR on USR.USR_ID = LNP.lnp_createdby
              where           sd.SET_Cancelled=0
              and           sd.SET_PreviousExp = 0
              and                        CRW_Cancelled = 0
              and           (sas_id is null or sas_id <> (3) )
              and           sd.STS_ID in ('OB','OV')
              and           cast(sd.SET_enddate as DATE) >=@sDateTime
              and           cast(sd.SET_enddate as DATE) <= GETDATE()
              and                  SET_ActiveStatus = 0
			 --and (pd.crw_employmenttype is null or pd.crw_employmenttype <> 'VSHP00000002' or pd.CRW_EmploymentType <> 'VSHP00000003')
			 --and tpa.CCN_Description = 'Internal Supply'
			--and n.nat_description = 'Filipino'




			  select  ROW_NUMBER() OVER(ORDER BY crw_id ASC) AS Row, 
			  CASE WHEN   VES_ID IN ('GLAS00002185',
'GLAS00004700',
'GLAS00011591',
'GLAS00012147',
'GLAS00012531',
'GLAS00017582',
'GLAS00019054',
'GLAS00019055',
'GLAS00019247',
'GLAS00019269',
'GLAS00019275',
'GLAS00019276',
'GLAS00019277',
'GLAS00019278',
'GLAS00020091',
'GLAS00020094',
'GLAS00020445',
'GLAS00021286',
'MANI00003285',
'MANI00012757',
'MANI00022368',
'MUMB00007083',
'MUMB00009949',
'VGR400021132',
'VGR400021133',
'VGR400021134',
'VGR400021135',
'VGRP00018499',
'VGRP00019546') THEN 'EAGLE' ELSE 'OTHER' END AS CLIENT_CATEGORY,
			  LHS.* from
    (   select  * 
       from #Onsigners
       union 
       select * 
       from #OffSigners 
	   
      ) LHS LEFT JOIN #ExternalManagers EXM ON EXM.CMP_ID=LHS.SMO_ID
		where  ( ves_id not in ('GLAX00012386','GLAT00000027') or ves_id is null)
       and           (SignOffReason is null or SignOffReason not in ('Promotion', 'Transfer'))
	   and ShipManagerType='Internal' --and Action='signon' and ActivityDate>='26-DEC-2021' and ActivityDate<='01-JAN-2022'
	   and (PlanningCell is null or PlanningCell not like '%test%')
	--  and crw_id='GLAS00044540'
	  -- and EXM.cmp_id is null
	   and ActivityDate >= '2025-01-01'
       order by dayspastmovement, action, SET_StartDate


	   drop table #Onsigners
	   drop table #OffSigners
	   drop table #ExternalManagers
	   --drop table #Vaccinated
	   drop table #tmpVes
	   --drop table #COVIDEXEMP
	   --drop table #VaccinatedBoosters