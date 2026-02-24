
 declare @sDateTime as datetime
 select @sDateTime = '01-JUN-2024'

select sd.CRW_ID as crw_id,
pd.crw_pid,
pd.crw_surname,
pd.crw_forename,
n.NAT_Description,
rnk.rnk_description as [Rank],
cat.CCA_Description as RankCategory,
ISNULL(tpa.CCN_Description,'Internal Supply') as EmploymentType,
sd.SET_StartDate,
sd.set_enddate,
cp.CMP_Name as MobilisationOffice,
mob.CPL_Description as MobilisationCell,
pl.CPL_Description as PlanningCell,
pl1.CPL_Description as CMPCell,
mov.STS_Desc as [Leave Reason]
,case when cpa.att_desc IS NULL then 'Missing' else cpa.att_desc end as [ShipMoney Attribute]
,case when conta.crc_date is NULL then 'No' else 'Yes' end as [Wage Payment Contact Made]
,conta.crc_date [Contact Date]
,cont2.CRC_Remarks
,usr.usr_displayname as [Contacted By]

into #LeftCompany
from shipsure.dbo.CRWSrvDetail sd (nolock)
INNER join    shipsure.dbo.CRWPersonalDetails pd  (nolock)  on pd.CRW_ID=sd.CRW_ID and pd.CRW_Cancelled=0
INNER join shipsure.dbo.NATIONALITY n (nolock) on n.nat_id=pd.nat_id
LEFT join     shipsure.dbo.company cp (nolock)  on cp.cmp_id=pd.CRW_CrewManagementOff
LEFT join     shipsure.dbo.CRWPool mob (nolock) on mob.cpl_id=pd.CPL_ID
left join shipsure..crwmovementtypes mov on mov.sts_id = sd.sts_id
LEFT join     shipsure.dbo.CRWPool pl (nolock) on pl.cpl_id=pd.CPL_ID_plan
lEFT join     shipsure.dbo.CRWPool pl1 (nolock) on pl1.cpl_id=pd.CPL_ID_cmp
left join CRWAttributes ctt on ctt.crw_id = sd.crw_id and ctt.att_id in ('STAT00000045', 'STAT00000046') and ctt.atb_cancelled = 0 --shipmoney attributes agreed and declined
left join CRWAttributetypes cpa on cpa.att_id=ctt.att_id
outer apply (select top (1) cont.crc_id, cont.USR_ID, cont.crc_date
			from [dbo].[CRWContacts2] cont 
			where cont.crw_id = sd.crw_id
			and cont.ccr_id = 'VSHP00000009' and crc_cancelled = 0
			order by cont.crc_date desc) conta
left join [dbo].[CRWContacts2] cont2 on cont2.crc_id = conta.CRC_ID and cont2.crw_id = sd.CRW_ID
left join shipsure.[dbo].[USERID] USR on USR.USR_ID = conta.usr_id
left join shipsure.dbo.crwranks rnk (nolock) on rnk.rnk_id=sd.rnk_id
Left Join CRWRankCategory cat on cat.CCA_ID=rnk.CCA_ID
Left Join Shipsure.dbo.CRWSrvContractType TPA ON TPA.CCN_ID =  pd.crw_employmenttype

where sd.sts_id in ('BW',
'DA',
'DD',
'FR',
'IX',
'LA',
'LB',
'LC',
'LD',
'LM',
'LN',
'LO',
'LP',
'LR',
'LT',
'LU',
'LW',
'LX',
'LZ',
'NJ',
'RE',
'SA',
'SI',
'TM',
'UN')
and cast(sd.SET_StartDate as DATE) >= @sDateTime
and cast(sd.SET_StartDate as DATE) < GETDATE()
and sd.SET_Cancelled=0
and sd.SET_PreviousExp = 0
and (sas_id is null or sas_id <> (3) )
--and (pd.crw_employmenttype is null or pd.crw_employmenttype <> 'VSHP00000002' or pd.CRW_EmploymentType <> 'VSHP00000003')

create table #tmpVessels(  
					 VES_ID varchar(12),  
					 VES_Name varchar(128),  
					 ves_ownergrp varchar(12),  
					 ves_onboard2 int default 0,  
					 Client varchar(128),
					 VTY_ID varchar(12) NULL,
					 VMO_ID varchar(12) NULL,
					 SMO_ID varchar(12) NULL,
					 VESSEL_IMO VARCHAR(8) NULL,
					 SMO_OFFICE VARCHAR(256) NULL,
					 VESSEL_TYPE VARCHAR(256) NULL,
					 VESSEL_GENERAL_TYPE VARCHAR(256) NULL,
					 VESSEL_GENERAL_SUB_TYPE VARCHAR(256) NULL
		 ) 
		

		INSERT INTO #tmpVessels
		SELECT	v.VES_ID, ves_name, null as ves_ownergrp, ves_onboard2, null as  Client, 
				V.VTY_ID, vd.VMO_ID AS VMO_ID, 
				COALESCE(VES_OFFTECH,VES_RespOff)  AS SMO, 
				VES_ImoNumber as VESSEL_IMO, GS.SIT_NAME AS SMO_OFFICE,
				VTY.VTY_Desc AS VESSEL_TYPE,
		CASE	WHEN VTY.VTY_ID = 'OTH' THEN 'CARGO'
				WHEN VTY.VTY_ID = 'OV' THEN 'OFFSHORE'
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
		END AS VESSEL_GENERAL_TYPE,
				bb.VGT_Desc as VESSEL_GENERAL_SUB_TYPE-- added 20.05
		FROM	vessel v  
		LEFT JOIN company c (NOLOCK) on c.cmp_id = v.ves_ownergrp  
		LEFT JOIN GLOBALSITE GS (NOLOCK) on GS.SIT_ID  = v.VES_OffTech 
		LEFT JOIN VESTYPE VTY (NOLOCK) ON VTY.VTY_ID = V.VTY_ID
		inner join VESGENTYPE bb  on vty.VTY_GenType = bb.VGT_ID-- added 20.05
		INNER join vesmanagementdetails vd   on v.ves_id=vd.ves_id and (vmd_manageend>=getdate() or vmd_manageend is null) and (VMD_Deleted is null or VMD_Deleted=0) 

		CREATE NONCLUSTERED INDEX ix_tempNCIndexAft ON #tmpVessels (ves_id); 


--GET LAST VESSEL			
		SELECT  *
		INTO #LAST_VESSEL
		FROM (
				SELECT DISTINCT TC.CRW_ID, sd.ves_id as LAST_VESSEL_ID,TV.VES_NAME AS LAST_VESSEL, TV.CLIENT AS LAST_VESSEL_CLIENT, sd.set_startdate, sd.set_enddate as LastSignOff,
								TV.VESSEL_IMO AS LAST_VESSEL_IMO,   case when VV.VMO_ID='GLAS00000003' then 'Full Management' else VV.VMO_Desc  end as VMO_DESC , TV.SMO_OFFICE, TV.VESSEL_TYPE, TV.VESSEL_GENERAL_TYPE, TV.VESSEL_GENERAL_SUB_TYPE,
				DENSE_RANK() OVER (
									PARTITION BY TC.CRW_ID
									ORDER BY sd.SET_STARTDATE desc, sd.set_updatedon desc, sd.set_id asc) LV
		FROM #LeftCompany TC   
		INNER JOIN CRWSRVDETAIL SD ON SD.CRW_ID = TC.CRW_ID
		LEFT JOIN #tmpVessels TV ON TV.VES_ID = SD.VES_ID
		LEFT JOIN DBO.VesManOffType VV ON VV.VMO_ID = TV.VMO_ID 
		WHERE SAS_ID = 2 
		AND SET_ACTIVESTATUS = 0
		AND SET_CANCELLED = 0
		AND STS_ID = 'OB'
		AND	SET_PreviousExp = 0
		AND SD.VES_ID IS NOT NULL
		AND SGT_ID IS NOT NULL
		) AA
		WHERE LV = 1
		

-- Final Select

Select * 
from #LeftCompany LC
Left Join #LAST_VESSEL LV on LV.crw_id = LC.crw_id


drop table #LeftCompany
drop table #last_vessel
drop table #tmpvessels