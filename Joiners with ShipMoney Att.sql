Use shipsure
go

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

	   SELECT * into #tmpVes FROM (
select
vd.vmd_id,
vd.vmo_id,
v.ves_id
, v.VES_IMOnumber
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


 declare @sDateTime as datetime
       select @sDateTime = '01-JUN-2024'

select * from ( 
	select a.*, b.sgt_id from ( 
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
										 v.VES_IMOnumber,
										 coalesce(vms.VMD_VesselName,VES_Name) as  ves_name,
                                         cp.CMP_Name as MobilisationOffice,
										 cp1.CMP_Name as PlanningOffice,
										 mob.CPL_Description as MobilisationCell,
										 pl.CPL_Description as PlanningCell,
										 pl1.CPL_Description as CMPCell,
                                         cc.SGT_Desc  as SignOffReason,
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
										--,MCH_ID as CheckListID
										--, case when MCH_ID IS not null and MCH_Status='GLAS00000002' then MCH_ID end as CheckListSignedOff 
										--,case	WHEN MCH_ID IS not null and MCH_Status='GLAS00000001' then MCH_ID end as CheckListActive
										,FLEET
										,VESSEL_GENERAL_SUB_TYPE
										,case when cpa.att_desc IS NULL then 'Missing' else cpa.att_desc end as [ShipMoney Attribute]
										,case when conta.crc_date is NULL then 'No' else 'Yes' end as [Wage Payment Contact Made]
										,conta.crc_date [Contact Date]
										,cont2.CRC_Remarks
										,usr.usr_displayname as [Contacted By]
										,d.sgt_desc as signon_reason
										, case when bc.CPC_RegistrationStatus=1 then 'Requested'
											when bc.CPC_RegistrationStatus=2 then 'Sent'
											when bc.CPC_RegistrationStatus=3 then 'Confirmed'
											when bc.CPC_RegistrationStatus=4 then 'Failed' else 'No Registration' end as ShipMoneyRegistrationStatus,
										case when bc.CRW_ID is not null then 'Yes' else 'No' end as ShipMoneyCurrentRegistered
										,bc.CPC_RegistrationOn as ShipMoneyRegistrationDate
										--,case when bc.cpc_active = 1 then 'Activated' else 'Not Activated' end as ShipMoneyCardActivated
										
              --into #Onsigners
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
			  left join CRWAttributes ctt on ctt.crw_id = sd.crw_id and ctt.att_id in ('STAT00000045', 'STAT00000046') and ctt.atb_cancelled = 0 --shipmoney attributes agreed and declined
			  left join CRWAttributetypes cpa on cpa.att_id=ctt.att_id
			  left join (select sdex.set_id, sdex.sgt_id_signon, sot.sgt_desc
						from shipsure.[dbo].[CRWSrvDetailExtension] sdex
						left join shipsure.[dbo].[CRWSignOffType] sot on sot.sgt_id = sdex.sgt_id_signon
						where sdex.ext_cancelled = 0
						and sot.sgt_isforsignon = 1) d on d.set_id = sd.set_id
			  outer apply (select top (1) cont.crc_id, cont.USR_ID, cont.crc_date
							from [dbo].[CRWContacts2] cont 
							where cont.crw_id = sd.crw_id
							and cont.ccr_id = 'VSHP00000009' and crc_cancelled = 0
							order by cont.crc_date desc) conta
			  left join [dbo].[CRWContacts2] cont2 on cont2.crc_id = conta.CRC_ID and cont2.crw_id = sd.CRW_ID
			  -- wage payment only
			 -- LEFT JOIN AttributeDef ATT ON ATT.AttributeName=CMM.TRI_TravelProvider AND ATT.TableName='TravelProvider'
			 -- LEFT JOIN AttributeDef ATT1 ON ATT1.AttributeName=CMM.TRI_Status AND ATT1.TableName='TravelBookingStatus'
			 -- LEFT JOIN CRWLineups LNP ON LNP.LNP_ID=sd.LNP_ID_JOINER
			 left join shipsure.[dbo].[USERID] USR on USR.USR_ID = conta.usr_id
			 Left Join shipsure..CRWPayrollCard bc on bc.CRW_ID=sd.CRW_ID and BNK_ID='BNK00000152' and bc.CPC_Cancelled=0
              where           sd.SET_Cancelled=0
              and           sd.SET_PreviousExp = 0
              and                        CRW_Cancelled = 0
              and           (sas_id is null or sas_id <> (3) )
              and           sd.STS_ID in ('OB','OV')
              and           cast(sd.SET_StartDate as DATE) >= @sDateTime
              and           cast(sd.SET_StartDate as DATE) < GETDATE() 
			  and (d.sgt_id_signon = '000030' or d.sgt_id_signon is NULL)
			  ) a -- only standard sign on

	left join (select crw_id, sgt_id from Shipsure..CRWSrvDetail sd
				where sd.SET_LASTVESSEL = 1
				and sd.sts_id in ('OB','OV')
				and (sd.sas_id is null or sd.sas_id <> (3) )
				and sd.SET_PreviousExp = 0
				AND sd.SET_CANCELLED = 0) b on a.crw_id = b.crw_id
				) c
where (c.SGT_ID is null or c.SGT_ID not in ('000015', '000016', '000014')) -- removing promotions and vessel transfers, vessel name change for old records where signon reason hasn't been implemented


			  --and (pd.crw_employmenttype is null or pd.crw_employmenttype <> 'VSHP00000002' or pd.CRW_EmploymentType <> 'VSHP00000003') --excluded TPAs and Ownersupplied


			  drop table #externalmanagers
			  drop table #tmpVes