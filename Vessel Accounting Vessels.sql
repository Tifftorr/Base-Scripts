use shipsure
go


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
	 COY_ID VARCHAR (12) NULL,
	 VESSEL_STATUS VARCHAR(200),
	 [Primary Accounting Contact] VARCHAR(200),
	 --[Vessel Effort Matrix] INT,
	 [Mgmt Type] VARCHAR (200)
	-- VESSEL_GENERAL_SUB_TYPE VARCHAR(256) NULL

		 ) 

INSERT INTO #tmpVessels
select
v.VES_ID, 
ves_name, 
null as ves_ownergrp, 
ves_onboard2, 
null as  Client, 
V.VTY_ID, 
vd.VMO_ID AS VMO_ID, 
VES_OFFTECH  AS SMO, 
VES_ImoNumber as VESSEL_IMO, 
GS.SIT_NAME AS SMO_OFFICE,
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
vd.COY_ID,
VS.VSS_Name AS VESSEL_STATUS,
usr.USR_DisplayName as [Primary Accounting Contact],
CASE WHEN CMP7.sit_name ='Silverseas Cruises Ltd.' THEN 'TP Crew Supply' when VMO.VMO_ID='GLAS00000003' then 'Full Management' Else ISNULL(VMO.VMO_Desc,'UNKNOWN') end AS [Mgmt Type]

FROM	vessel v  
		LEFT JOIN company c (NOLOCK) on c.cmp_id = v.ves_ownergrp  
		LEFT JOIN GLOBALSITE GS (NOLOCK) on GS.SIT_ID  = v.VES_OffTech 
		LEFT JOIN VESTYPE VTY (NOLOCK) ON VTY.VTY_ID = V.VTY_ID
		inner join VESGENTYPE bb  on vty.VTY_GenType = bb.VGT_ID-- added 20.05
		INNER join vesmanagementdetails vd   on v.ves_id=vd.ves_id and (cast(vmd_manageend as date) >= '2024-08-31' or vmd_manageend is null) and (VMD_Deleted is null or VMD_Deleted=0)
		LEFT JOIN VESSTATUS VS (NOLOCK) ON V.VSS_ID = VS.VSS_ID
		left join [dbo].[VESRESPSERVICE] resp on resp.vmd_id = vd.vmd_id and (cast(vrs_validTo as date) >= '2024-08-31' or vrs_validTo is null) and (VRS_Deleted = 0 or VRS_Deleted is null) and vrt_id = 'GLAS00000002'
		left join USERID usr on usr.USR_ID = resp.USR_ID
		LEFT JOIN VesManOffType VMO (NOLOCK) ON vmo.VMO_ID =  VD.VMO_ID
		LEFT JOIN globalsite CMP7 (NOLOCK) ON CMP7.sit_id = V.VES_OffTech

		-- IF VMO_ID OR CLIENT IS MISSING THEN UPDATE THE RECORDS.
		-- SELECT * FROM [dbo].[VESOFFICETYPE]
		UPDATE #tmpVessels
		SET		VMO_ID = COALESCE(LHS.VMO_ID, RHS.VMO_ID),
				ves_ownergrp =  COALESCE(LHS.ves_ownergrp, RHS.VMD_Owner),
				Client = rhs.CMP_Name
		FROM	#tmpVessels LHS
		JOIN	(SELECT DISTINCT VES_ID, VMO_ID, XX.VMD_Owner, cmp.CMP_Name
				FROM VESMANAGEMENTDETAILS  XX
				left join company cmp on cmp.cmp_id = XX.VMD_Owner
				WHERE VMD_ManageEnd IS NULL) RHS ON RHS.VES_ID = LHS.VES_ID 
		WHERE	LHS.VMO_ID IS NULL OR LHS.ves_ownergrp IS NULL

		-- SET TECHNICAL OFFICE , USED IN CASE NOT SET AGAINST THE VESSEL.
		UPDATE  #tmpVessels
		SET		SMO_ID = RHS.SMO_ID,
				SMO_OFFICE = RHS.SMO_OFFICE
		FROM	#tmpVessels LHS
		JOIN	(SELECT DISTINCT XX.VES_ID, MAX(YY.CMP_ID) AS SMO_ID , MAX(CC.SIT_NAME) AS SMO_OFFICE
				FROM VESMANAGEMENTDETAILS  XX
				INNER JOIN VESOFFICESERVICE YY ON YY.VMD_ID = XX.VMD_ID AND YY.VOS_Deleted = 0 AND YY.VOT_ID IN ('GLAS00000005', 'GLAS00000003')
				INNER JOIN GLOBALSITE CC ON CC.SIT_ID = YY.CMP_ID 
				WHERE VMD_ManageEnd IS NULL
				GROUP BY  XX.VES_ID) RHS ON RHS.VES_ID = LHS.VES_ID 
		WHERE	LHS.SMO_ID IS NULL 

select vv.*,
-- cargo
case when [Mgmt Type] = 'Full Management' and VESSEL_GENERAL_TYPE = 'CARGO' then 1
when [Mgmt Type] <> 'Full Management' and VESSEL_GENERAL_TYPE = 'CARGO' then 0.33
-- offshore
when [Mgmt Type] = 'Full Management' and VESSEL_GENERAL_TYPE = 'OFFSHORE' then 1
when [Mgmt Type] <> 'Full Management' and VESSEL_GENERAL_TYPE = 'OFFSHORE' then 0.68
--leisure
when Client = 'SP Cruises Holdings Limited' then 4 -- azamara
when ves_id in ('VGRP00018650', 'GLAS00013014') then 2 -- tech + crw
when ves_id in ('VGRP00019965', 'GLAS00007529', 'GLAS00011718', 'GKGK00000128', 'GLAS00015004', 'VGRP00019562', 'GLAS00020407', 'VGRP00018576', 'VGRP00019549', 'VGR400021392', 'VGRP00018661') then 0.2 --Allotments only
when [Mgmt Type] = 'Full Management' and VES_ID not in ('VGRP00018650', 'GLAS00013014') and VESSEL_GENERAL_TYPE = 'LEISURE' then 2.5 --normal leisure SM vessel

else 0.8 end as [Vessel Effort Matrix]

from #tmpvessels vv
where (ves_id in ('VGRP00019965', 'GLAS00007529', 'GLAS00011718', 'GKGK00000128', 'GLAS00015004', 'VGRP00019562', 'GLAS00020407', 'VGRP00018576', 'VGRP00019549', 
	'VGR400021392', 'VGRP00018661', 'GLAS00018964', 'FAIR00056756', 'VGRP00019798') or COY_ID is not null)
and vessel_status not in ('Fairplay', 'Deleted', 'Prospect')

drop table #tmpvessels

--select top 10 * from [dbo].[VESRESPSERVICE]
--select top 10 * from [dbo].[VESRESPTYPE]