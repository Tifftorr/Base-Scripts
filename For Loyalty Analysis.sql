use shipsure
go

DECLARE @dEOM AS DATETIME
DECLARE @dEONM AS DATETIME

SELECT @dEOM =  DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,getdate())+1,0))

SELECT @dEONM =  DATEADD(month, 1, @dEOM)

print @dEOM
print @dEONM

		-- DROP TABLE #tmpVessels	
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

--into tmpcrw

SELECT pd.crw_id,
		pd.crw_pid AS PCN,
		sd.SET_ID,
		sd.ves_id,
		COALESCE(SD.RNK_ID_BUDGETED,SD.RNK_ID,PD.RNK_ID) AS RNK_ID ,
		V.VES_NAME AS CURRENT_VESSEL,
		VESSEL_TYPE AS CURRENT_VESSEL_TYPE,
	    VESSEL_GENERAL_TYPE AS CURRENT_VESSEL_GENERAL_TYPE,
		VESSEL_GENERAL_SUB_TYPE AS CURRENT_VESSEL_GENERAL_SUB_TYPE,
		VESSEL_IMO as CURENT_VESSEL_IMO, 
		RNK.RNK_Description AS RANK,
		CASE WHEN CCA.CCA_DESCRIPTION  = 'Petty Officers' THEN 'Non-Marine Ranks'
			WHEN CCA.CCA_DESCRIPTION = 'OFFICERS' THEN 'Junior Officers'
			WHEN CCA.CCA_DESCRIPTION = 'OTHER' THEN 'Non-Marine Ranks'
		ELSE CCA.CCA_DESCRIPTION END AS RANK_CATEGORY,
		NAT.NAT_Description AS NATIONALITY,
		PD.CRW_SURNAME AS SEAFARER_SURNAME,
		PD.CRW_FORENAME AS SEAFARER_FORENAME,
		-- contract type
		CASE WHEN TPA.CCN_DESCRIPTION IS NULL AND ([SET_3rdPartyAgent] IS NOT NULL or CRW_3rdPartyAgent is not null )or crw_employmenttype='VSHP00000003' THEN 'Third Party Crew'
		 WHEN (TPA.CCN_DESCRIPTION IS NULL AND PD.crw_OwnerSeafarer  = 1) OR  crw_employmenttype='VSHP00000002' THEN 'Owner Supplied'
		  WHEN TPA.CCN_DESCRIPTION IS NULL THEN 'Internal Supply'
		ELSE TPA.CCN_DESCRIPTION END		AS CONTRACT_TYPE,
		CPL.CPL_DESCRIPTION AS Seafarer_MOB_CELL,
		CPL1.CPL_Description AS seafarer_PLANNING_CELL,
		CPL2.CPL_Description AS seafarer_CMP_CELL,
		STS.STS_DESC AS CURRENT_STATUS, 
		cast(sd.SET_StartDate as date) as START_DATE,
		cast(sd.SET_EndDate as date) as END_DATE,
		VS.VSS_Name AS VESSEL_STATUS,
		ISNULL(CNT1.CNT_Desc,'UNKNOWN') AS VESSEL_FLAG,
		CASE WHEN CMP7.sit_name ='Silverseas Cruises Ltd.' THEN 'TP Crew Supply' when VMO.VMO_ID='GLAS00000003' then 'Full Management' Else ISNULL(VMO.VMO_Desc,'UNKNOWN') end AS VESSEL_MANAGEMENT_TYPE,
		ISNULL(CMP6.CMP_NAME,'UNKNOWN') AS VESSEL_DOC_HOLDING_OFFICE,
		(CMP7.sit_name) AS VESSEL_TECH_MGT_OFFICE,
		ISNULL(CMP8.CMP_Name,'UNKNOWN') AS VESSEL_CREWING_OFFICE,
		ISNULL(CMP9.CMP_NAME,'UNKNOWN') AS VESSEL_RESPONSIBLE_OFFICE,
		ISNULL(CMP11.CMP_NAME,'UNKNOWN') AS VESSEL_COORDINATING_OFFICE,
		ISNULL(CMP10.CMP_NAME,'UNKNOWN') AS VESSEL_CLIENT,
		cmp13.sit_name as SF_TECH_OFFICE,
		FLT.FLT_Desc as Seafarer_Fleet,
		CMP14.CMP_NAME AS SEAFARER_Client,
		pd.crw_employmenttype,
		tpa.ccn_description as [Supply Type],
		sd.svl_id [current_svl_id],
		bgl.svl_leaveduration [Current Leave Duration],
		bgl.svl_leavedurationunit [Current Leave Duration Unit],
		sd.set_id as [set_id_onboard]

	into #tmpcrw
	FROM CRWSRVDETAIL SD (NOLOCK)
		LEFT JOIN   CRWSrvDetailExtension SD2 ON SD2.SET_ID = SD.SET_ID and sd2.ext_cancelled=0 and sd2.EXT_extendedon is not null
		LEFT JOIN CLOUD_ENTITY_SCANNED SC ON SC.FK_MATCHED_ID=SD2.SET_ID and sc.CRW_ID=sd.CRW_ID and (SC.ETT_Reference_2='GLAS00000024' OR SC.ETT_Desc like '%Extension%'  OR SC.ETT_Desc like '%ADM36%'  or sc.ETT_FileName like '%Extension%'  OR SC.ETT_FileName like '%ADM36%'  )
		LEFT JOIN USERID U ON U.USR_ID=SC.ETT_CreatedBy
		LEFT JOIN   AttributeDef EXT ON EXT.BITVALUE = SD2.EXT_ExtensionReason  AND TABLENAME = 'CrewServiceExtensionReason'
		INNER JOIN  CRWPERSONALDETAILS PD  (NOLOCK) ON PD.CRW_ID = SD.CRW_ID
		INNER JOIN  DBO.CRWMovementTypes STS ON STS.STS_ID = SD.STS_ID 
		LEFT JOIN  VESSEL V (NOLOCK) ON SD.VES_ID = V.VES_ID 
		LEFT JOIN  #tmpVessels V2 (NOLOCK) ON SD.VES_ID = V2.VES_ID
		LEFT JOIN   CRWCLVESCREWLIST BGL (NOLOCK) ON SD.SVL_ID = BGL.SVL_ID
		LEFT JOIN   CRWServiceStatus CSS (NOLOCK) ON BGL.CSS_ID = CSS.CSS_ID
		LEFT JOIN  CRWRANKS RNK (NOLOCK) ON RNK.RNK_ID = COALESCE(SD.RNK_ID_BUDGETED,SD.RNK_ID,PD.RNK_ID)
		LEFT JOIN  CRWRANKCATEGORY CCA (NOLOCK) ON RNK.CCA_ID = CCA.CCA_ID
		LEFT JOIN   NATIONALITY NAT (NOLOCK) ON PD.NAT_ID = NAT.NAT_ID
		LEFT JOIN CRWPOOL CPL (NOLOCK) ON PD.CPL_ID = CPL.CPL_ID
		LEFT JOIN CRWPOOL CPL1 (NOLOCK) ON PD.CPL_ID_PLAN = CPL1.CPL_ID
		LEFT JOIN CRWPOOL CPL2 (NOLOCK) ON PD.cpl_id_cmp = CPL2.CPL_ID
		LEFT JOIN COMPANY CMP1 (NOLOCK) ON CMP1.CMP_ID = PD.CRW_CrewManagementOff -- SEAFARER MOCO
		LEFT JOIN COMPANY CMP2 (NOLOCK) ON CMP2.CMP_ID = PD.CRW_CrewSupplyOffice -- SEAFARER REGIONAL OFFICE
		LEFT JOIN COMPANY CMP4 (NOLOCK) ON CMP4.CMP_ID = PD.CRW_3rdPartyAgent -- TPA
		LEFT JOIN COMPANY CMP5 (NOLOCK) ON CMP5.CMP_ID = PD.CRW_SecondedOffice -- SEAFARER COORDINATION OFFICE
		LEFT JOIN globalsite CMP13 (NOLOCK) ON CMP13.sit_id = PD.CRW_ShipManagementOff --Tech Office
		LEFT JOIN COMPANY CMP14 (NOLOCK) ON CMP14.CMP_ID = PD.CRW_OwnerPool --Seafarer Owner
		Left Join FLEET FLT ON FLT.FLT_ID=PD.FLT_ID
		-- contract type 
		LEFT JOIN CRWSrvContractType TPA ON TPA.CCN_ID = pd.crw_employmenttype -- PD.CCN_ID
		LEFT JOIN COMPANY CMP12 (NOLOCK) ON CMP12.CMP_ID = sd.[SET_ContractCompany]
		LEFT JOIN VESSTATUS VS (NOLOCK) ON V.VSS_ID = VS.VSS_ID
		LEFT JOIN COUNTRY CNT1 (NOLOCK) ON V.VES_Flag = CNT1.CNT_ID
		LEFT JOIN VesManOffType VMO (NOLOCK) ON vmo.VMO_ID =  V2.VMO_ID  -- ENSURE THE FOLLOWING IS IN PLACE.
		LEFT JOIN COMPANY CMP6 (NOLOCK) ON CMP6.CMP_ID = V.VES_HeadOff -- VESSEL DOC HOLDING OFFICE
		LEFT JOIN globalsite CMP7 (NOLOCK) ON CMP7.sit_id = V.VES_OffTech -- VESSEL TECH MANAGEMENT OFFICE
		LEFT JOIN COMPANY CMP8 (NOLOCK) ON CMP8.CMP_ID = V.VES_OffCrew -- VESSEL CREWING OFFICE
		LEFT JOIN COMPANY CMP9 (NOLOCK) ON CMP9.CMP_ID = COALESCE(SD.SET_SMO, V2.SMO_ID) -- VESSEL RESPONSIBLE OFFICE
		LEFT JOIN COMPANY CMP10 (NOLOCK) ON CMP10.CMP_ID = V2.VES_OwnerGrp -- CLIENT NAME
		LEFT JOIN COMPANY CMP11 (NOLOCK) ON CMP11.CMP_ID = SD.SET_CoordOffice -- VESSEL COORDINATING OFFICE
		LEFT JOIN dbo.PORT PRT ON SD.SET_LOADPORTID = PRT.PRT_ID
		LEFT JOIN DBO.COUNTRY CNTP ON CNTP.CNT_ID = PRT.CNT_ID
		left join country country on country.CNT_ID=pd.CRW_OriginCountry
		LEFT JOIN COMPANY CMP20 (NOLOCK) ON CMP20.CMP_ID = PD.CRW_EmploymentEntity and cmp20.CMP_DELETED = 0 and cmp20.CMP_ID <> ' ' -- to get TPA Names new by tiff 11/14/2023

		WHERE	SD.SET_Cancelled = 0
		AND		SD.SET_PreviousExp = 0
		AND		PD.CRW_Cancelled = 0
		AND		RNK.RNK_VALIDSUPN = 0
		AND		(SD.SAS_ID not in (3,0)  or sd.sas_id = NULL)
		AND		((STS.STS_ValidSearch = 1 or sts.sts_id = 'IT') AND SD.STS_ID <> 'PM')
		--AND		SD.SET_EndDate > GETDATE()-360
		AND		SD.SET_StartDate <= SD.SET_EndDate
		AND		SD.SET_ActiveStatus = 1 
		AND		(sd.VES_ID is null or sd.VES_ID not IN ('GLAX00012386', 'GLAT00000027'))
		and RNK.dep_id not in ('SUPERN','SPM_OB')
		and nat.NAT_Description = 'Filipino' -- Filipino Only
		and cca.cca_isofficer = 1
		order by CURRENT_VESSEL

CREATE NONCLUSTERED INDEX ix_tempNCIndexAft2 ON #tmpcrw (crw_id); 

	--GET LAST VESSEL			
		SELECT  *
		INTO #LAST_VESSEL
		FROM (
				SELECT DISTINCT TC.CRW_ID, sd.svl_id [last_vessel_svl_id], bgl.[svl_leaveduration] as [Last Leave Duration], bgl.[svl_leavedurationunit] as [Last Leave Duration Unit], sd.set_id as last_vessel_set_id, sd.ves_id as LAST_VESSEL_ID,TV.VES_NAME AS LAST_VESSEL, TV.CLIENT AS LAST_VESSEL_CLIENT, set_startdate, set_enddate as LastSignOff,
								TV.VESSEL_IMO AS LAST_VESSEL_IMO,   case when VV.VMO_ID='GLAS00000003' then 'Full Management' else VV.VMO_Desc  end as VMO_DESC , TV.SMO_OFFICE, TV.VESSEL_TYPE, TV.VESSEL_GENERAL_TYPE, TV.VESSEL_GENERAL_SUB_TYPE,
				DENSE_RANK() OVER (
									PARTITION BY TC.CRW_ID
									ORDER BY SET_STARTDATE desc, sd.set_updatedon desc, sd.set_id asc) LV
		FROM #tmpcrw TC   
		INNER JOIN CRWSRVDETAIL SD ON SD.CRW_ID = TC.CRW_ID
		LEFT JOIN #tmpVessels TV ON TV.VES_ID = SD.VES_ID
		LEFT JOIN DBO.VesManOffType VV ON VV.VMO_ID = TV.VMO_ID 
		LEFT JOIN   CRWCLVESCREWLIST BGL (NOLOCK) ON SD.SVL_ID = BGL.SVL_ID
		WHERE SAS_ID = 2 
		AND SET_ACTIVESTATUS = 0
		AND SET_CANCELLED = 0
		AND STS_ID = 'OB'
		AND	SET_PreviousExp = 0
		AND SD.VES_ID IS NOT NULL
		AND SGT_ID IS NOT NULL
		) AA
		WHERE LV = 1 


		--GET NEXT PLANNED VESSEL			
		SELECT *
		INTO #NEXT_VESSEL
		FROM (
				SELECT DISTINCT TC.CRW_ID, sd.svl_id [next_vessel_svl_id], bgl.[svl_leaveduration] as [Next Leave Duration], bgl.[svl_leavedurationunit] as [Next Leave Duration Unit],sd.SET_ID as next_vessel_set_id, CSA.CSA_Description AS PlanningStatus, sd.ves_id as Next_Vessel_ID,TV.VES_NAME AS NEXT_VESSEL, 
								TV.CLIENT AS NEXT_VESSEL_CLIENT, case when VV.VMO_ID='GLAS00000003' then 'Full Management' else VV.VMO_Desc  end as VMO_DESC, TV.SMO_OFFICE, TV.VESSEL_TYPE, 
								TV.VESSEL_GENERAL_TYPE, TV.VESSEL_GENERAL_SUB_TYPE,
								cast(SD.SET_STARTDATE as date) AS PLAN_TO_JOIN,
								TV.VESSEL_IMO AS NEXT_VESSEL_IMO, 
								DENSE_RANK() OVER (
													PARTITION BY TC.CRW_ID
													ORDER BY SET_STARTDATE, SET_UpdatedOn ASC) LV
		FROM	#tmpcrw TC   
		INNER JOIN CRWSRVDETAIL SD (NOLOCK) ON SD.CRW_ID = TC.CRW_ID
		INNER JOIN CRWAssignedStatus  CSA ON CSA.CSA_ID = SD.CSA_ID
		LEFT JOIN #tmpVessels TV ON TV.VES_ID = SD.VES_ID
		LEFT JOIN DBO.VesManOffType VV ON VV.VMO_ID = TV.VMO_ID
		LEFT JOIN   CRWCLVESCREWLIST BGL (NOLOCK) ON SD.SVL_ID = BGL.SVL_ID
		WHERE SET_ACTIVESTATUS = 0
		AND		SAS_ID = 3 
		AND		SET_CANCELLED = 0
		AND		STS_ID = 'OB'
		AND		SGT_ID IS NULL
		AND		SD.VES_ID IS NOT NULL
		AND		SD.CRW_ID IS NOT NULL
		AND		SD.CSA_ID IN ('VSHP00000001', 'VSHP00000002','VSHP00000004','VSHP00000011','VSHP00000013')
		) AA
		WHERE LV = 1 
		order by 1

		-- v.ships services
		SELECT	TC.CRW_ID , COUNT(sd.SET_ID) AS VSHIPS_SERVICE_COUNT
		INTO	#tmpServiceCount
		FROM	#tmpcrw tc
		INNER JOIN CRWSRVDETAIL SD (NOLOCK) ON SD.CRW_ID = TC.CRW_ID
		WHERE	(SAS_ID IS NULL OR SAS_ID <> 3) 
		AND		SET_ACTIVESTATUS = 0
		AND		SET_CANCELLED = 0
		AND		SET_PreviousExp = 0
		AND		STS_ID IN ('OB', 'OV')
		AND		SD.VES_ID IS NOT NULL
		GROUP BY TC.CRW_ID


SELECT 	DISTINCT		   PCN,
								tc.ves_id, CURRENT_VESSEL,	CURENT_VESSEL_IMO,	RANK, RANK_CATEGORY,	NATIONALITY,	
								SEAFARER_SURNAME, SEAFARER_FORENAME,
								Seafarer_MOB_CELL,	seafarer_PLANNING_CELL, seafarer_CMP_CELL,
									tc.CURRENT_STATUS,	
								START_DATE,	END_DATE,
								LastSignOff,
								PLAN_TO_JOIN,	
								PlanningStatus,	
								COALESCE(SC.VSHIPS_SERVICE_COUNT, 0) AS VSHIPS_SERVICE_ONBOARD_COUNT,


								CASE WHEN tc.CURRENT_STATUS IN ('ONBOARD', 'OVERLAP', 'IN-TRANSIT') THEN 'ONBOARD' 
								WHEN PlanningStatus IS NOT NULL  THEN 'PLANNED'  
								WHEN LAST_VESSEL  IS NOT NULL  THEN 'LAST VESSEL'
								ELSE 'OPEN'
								END AS SEAFARER_STATUS,

								CASE WHEN tc.CURRENT_STATUS IN ('ONBOARD', 'OVERLAP', 'IN-TRANSIT') THEN tc.Ves_id
								WHEN PlanningStatus IS NOT NULL  THEN   Next_Vessel_ID
								ELSE LAST_VESSEL_ID
								END AS VESSEL_ID_FINAL,


								CASE WHEN tc.CURRENT_STATUS IN ('ONBOARD', 'OVERLAP', 'IN-TRANSIT') THEN tc.set_id
								WHEN PlanningStatus IS NOT NULL  THEN   next_vessel_set_id
								ELSE last_vessel_set_id
								END AS set_id_final,

								CASE WHEN tc.CURRENT_STATUS IN ('ONBOARD', 'OVERLAP', 'IN-TRANSIT') THEN tc.[current_svl_id]
								WHEN PlanningStatus IS NOT NULL  THEN   next_vessel_svl_id
								ELSE last_vessel_svl_id
								END AS svl_id_final,

								CASE WHEN tc.CURRENT_STATUS IN ('ONBOARD', 'OVERLAP', 'IN-TRANSIT') THEN tc.[Current Leave Duration]
								WHEN PlanningStatus IS NOT NULL  THEN   [Next Leave Duration]
								ELSE [Last Leave Duration]
								END AS [Leave Duration],

								CASE WHEN tc.CURRENT_STATUS IN ('ONBOARD', 'OVERLAP', 'IN-TRANSIT') THEN tc.[Current Leave Duration Unit]
								WHEN PlanningStatus IS NOT NULL  THEN   [Next Leave Duration Unit]
								ELSE [Last Leave Duration Unit]
								END AS [Leave Duration Unit],

								CASE WHEN tc.CURRENT_STATUS IN ('ONBOARD', 'OVERLAP', 'IN-TRANSIT') THEN CURRENT_VESSEL
								WHEN PlanningStatus IS NOT NULL  THEN NEXT_VESSEL 
								ELSE LAST_VESSEL
								END AS VESSEL_FINAL,
								
								CASE WHEN tc.CURRENT_STATUS IN ('ONBOARD', 'OVERLAP', 'IN-TRANSIT') THEN VESSEL_CLIENT 
								WHEN PlanningStatus IS NOT NULL  THEN NEXT_VESSEL_CLIENT  
								ELSE LAST_VESSEL_CLIENT
								END AS CLIENT_FINAL,
								
								CASE WHEN tc.CURRENT_STATUS IN ('ONBOARD', 'OVERLAP', 'IN-TRANSIT') THEN VESSEL_MANAGEMENT_TYPE  
								WHEN PlanningStatus IS NOT NULL  THEN NV.VMO_Desc    
								ELSE LV.VMO_Desc 
								END AS MANAGEMENT_TYPE_FINAL, 
								
								CASE WHEN tc.CURRENT_STATUS IN ('ONBOARD', 'OVERLAP', 'IN-TRANSIT') THEN COALESCE(VESSEL_TECH_MGT_OFFICE, VESSEL_RESPONSIBLE_OFFICE, 
								SF_TECH_OFFICE)  
								WHEN PlanningStatus IS NOT NULL  THEN coalesce( NV.SMO_OFFICE    , SF_TECH_OFFICE, 'UNKNOWN')
								ELSE coalesce( LV.SMO_OFFICE  , SF_TECH_OFFICE, 'UNKNOWN')
								END AS SMO_FINAL, 

								CASE WHEN CURRENT_STATUS IN ('ONBOARD', 'OVERLAP', 'IN-TRANSIT') THEN TC.CURRENT_VESSEL_GENERAL_TYPE  
								WHEN PlanningStatus IS NOT NULL  THEN NV.VESSEL_GENERAL_TYPE     
								ELSE LV.VESSEL_GENERAL_TYPE  
								END AS VESSEL_GENERAL_TYPE_FINAL, 

								CASE WHEN CURRENT_STATUS IN ('ONBOARD', 'OVERLAP', 'IN-TRANSIT') THEN TC.CURRENT_VESSEL_GENERAL_SUB_TYPE
								WHEN PlanningStatus IS NOT NULL  THEN NV.VESSEL_GENERAL_SUB_TYPE     
								ELSE LV.VESSEL_GENERAL_SUB_TYPE  
								END AS VESSEL_GENERAL_SUB_TYPE_FINAL, 

								CASE WHEN tc.CURRENT_STATUS IN ('ONBOARD', 'OVERLAP', 'IN-TRANSIT') THEN TC.CURRENT_VESSEL_TYPE  
								WHEN PlanningStatus IS NOT NULL  THEN NV.VESSEL_TYPE     
								ELSE LV.VESSEL_TYPE  
								END AS VESSEL_TYPE_FINAL,
								VESSEL_TECH_MGT_OFFICE
								,VESSEL_FLAG
								,tc.CRW_ID,
								 tc.rnk_id,
								 tc.[Supply Type],
								 tc.set_id_onboard

			into		#FINAL
			FROM		#tmpcrw tc
			LEFT JOIN #LAST_VESSEL LV ON LV.CRW_ID = TC.CRW_ID
			LEFT JOIN #NEXT_VESSEL NV ON NV.CRW_ID = TC.CRW_ID
			LEFT JOIN #tmpServiceCount SC ON SC.CRW_ID = TC.CRW_ID
			Left Join shipsure..CRWPayrollCard bc on bc.CRW_ID=tc.CRW_ID and BNK_ID='BNK00000152' and bc.CPC_Cancelled=0
			LEFT JOIN SHIPSURE..crwcontactdetails CCD ON CCD.CRW_ID=tc.CRW_ID AND CCD.CCN_ACTIVE=1 AND NOK_ID IS NULL AND  CCN_PRIMARY=1 AND CCT_ID='VSHP00000001'
			WHERE	(PlanningStatus is not null  or VSHIPS_SERVICE_COUNT > 0 or CURRENT_STATUS = 'onboard')

			order by  pcn,CURRENT_STATUS , CURRENT_VESSEL

			-- into loyalty

			select  *
			into #loyalty
			from	[VLOYALTYLS].[VLOYALTY].[DBO].[USER] aa
			where	iscancelled = 0
			and		isactive = 1

			select distinct aa.crw_id, cms.SRG_Total, cms.SRG_Pending, ((cast(cms.SRG_Total as float)-cast(cms.SRG_Pending as float)) / cms.SRG_Total)*100 AS cms_percentage_current_rank
			into #cms_currentrank
			from #Final aa
			inner join ShipSure..CRWProficiencyStatusRootGroups CMS on cms.CRW_PID = aa.PCN and cms.SRG_NextRank = 0
			--where cms.CRW_PID = '6711MAI92831'

			select distinct aa.crw_id, cms.SRG_Total, cms.SRG_Pending, ((cast(cms.SRG_Total as float)-cast(cms.SRG_Pending as float)) / cms.SRG_Total)*100 AS cms_percentage_next_rank
			into #cms_nextrank
			from #Final aa
			inner join ShipSure..CRWProficiencyStatusRootGroups CMS on cms.CRW_PID = aa.PCN and cms.SRG_NextRank = 1

			select distinct aa.crw_id, nan.asn_id, asn_createdon [NAN Created On] ,asn_responsedateutc as [NAN Accepted On]
			into #NAN
			from #final aa
			inner join SHIPSURE..CRWAssignmentNotification nan on nan.set_id = aa.set_id_final

			--documents upload
			Select AD.*, CDN.CNT_Desc as DocumentIssueCountry, CASE WHEN DS.IN_SCOPE = 'YES' THEN 'IN SCOPE' ELSE 'OUT OF SCOPE' END AS DocumentScope, 
			case when ad.[UploadedBy] = 'SYSTEM' then 'Seafarer' else [UploadedByUnit] end as UploadedByUnitFinal

				into #tmpdocs
				from aggregates..crew_appdocuments AD
				LEFT JOIN Aggregates..CRWMobileDocumentUploadScope DS ON DS.Doc_Desc = AD.[Name]
				LEFT JOIN Shipsure..COUNTRY CDN ON CDN.CNT_ID= AD.CRD_Country
				INNER join    shipsure.dbo.CRWPersonalDetails pd  (nolock)  on pd.CRW_ID=AD.CRW_ID
				where year(cast(AD.UploadedOn AS date)) = year(getdate())
				--AND AD.Management_type_FINAL in ('Full Management', 'Tech Mgmt')
				--AND (ad.crw_employmenttype is null or ad.crw_employmenttype <> 'VSHP00000002') -- not owner supplied

			Select F.*, 
				case 
						when F.DocumentScope = 'OUT OF SCOPE' then 'OUT OF SCOPE'
						when F.Name = 'Visa - MCV' then 'OUT OF SCOPE'
						when F.DocumentIssueCountry in ('Azerbaijan', 'Bahamas', 'Belgium', 'Belize', 'Cayman Islands', 'Cyprus', 'DANISH INTERNATIONAL REGISTER', 'Gibraltar', 'Hong Kong', 'Isle Of Man.', 'Liberia',
								'LUXEMBOURG (UN)', 'Madeira', 'Malta', 'Marshall Islands', 'Nigeria', 'Norwegian International ShipRegister', 'Panama', 'Singapore', 'St. Vincent') then 'OUT OF SCOPE'
						else 'IN SCOPE'
				end as DocumentScopeFinal

				into #tmpdocsfinal
				from #tmpdocs F

				Select distinct Crw_ID, count(distinct DocumentID) as [Documents Uploaded by SF]
				into #docsuploadedbySF
				from #tmpdocsfinal
				where DocumentScopeFinal = 'IN SCOPE'
				and UploadedByUnitFinal = 'Seafarer'
				group by Crw_ID

				Select distinct Crw_ID, count(distinct DocumentID) as [Documents Uploaded by Office]
				into #docsuploadedbyOffice
				from #tmpdocsfinal
				where DocumentScopeFinal = 'IN SCOPE'
				and UploadedByUnitFinal = 'Office'
				group by Crw_ID

				--availability
				select *  
				into #can   
				from  
				  (select  can_id, CRW_ID,ad.CAN_FromDate , ad.CAN_PreferredOnBoardDate,  
				   row_number() over(partition by crw_id order by ad.CAN_FromDate desc) as rn   
							from  [Shipsure].dbo.CRWAvailabilityNotification ad) ad where rn=1
			
			-- officers seminars
			select

			ff.crw_id,
			docs.crd_id,
			docs.doc_id,
			dm.doc_desc,
			docs.crd_number,
			docs.crd_country,
			docs.crd_Issued,
			docs.crd_expiry

			into #crewseminar
			from #final ff
			left join shipsure.[dbo].[CRWDocs] docs on docs.crw_id = ff.crw_id
			left join shipsure.[dbo].[CRWDocMaster] dm on dm.doc_id = docs.doc_id
			where docs.doc_id = 'MIAM00000019'
			and docs.crd_cancelled = 0

			select top 10 * from shipsure.[dbo].[CRWDocs] docs
			where docs.doc_id = 'MIAM00000019'

			select top 10 * from shipsure.[dbo].[CRWDocMaster]
			where doc_id = 'MIAM00000019'

-- final script

			select ff.*,
			loy.RegistrationDate as [VLoyalty Registration Date],
			case when loy.RegistrationDate is null then 'Not Registered' else 'Registered' end as [VLoyalty Registration],
			cms.SRG_Pending as [CMS Pending Current Rank],
			cms.SRG_Total [CMS Total Current Rank],
			cms.cms_percentage_current_rank [CMS Current Rank %],
			cmsn.SRG_Pending [CMS Pending Next Rank],
			cmsn.SRG_Total [CMS Total Next Rank],
			cmsn.[cms_percentage_next_rank] as [CMS Next Rank %],
			nan.[NAN Created On],
			nan.[NAN Accepted On],
			DATEDIFF(day, nan.[NAN Created On], nan.[NAN Accepted On]) as DaysBeforeNANAcceptance,
			docsf.[Documents Uploaded by SF],
			docsof.[Documents Uploaded by Office],
			av.CAN_FromDate [Availability Date],
			sem.crd_id [Crew Seminar ID],
			sem.crd_issued [Crew Seminar Issued On],
			case when [Leave Duration Unit] = 'M' then [Leave Duration] * 30   
		   when [Leave Duration Unit] = 'W' then [Leave Duration] * 7  
		   else [Leave Duration] end as [Leave Duration Days],
		   'D' as [Leave Duration Unit Days]

			into #tmpfinal
			from #final ff
			left join #loyalty loy on loy.source_pk = ff.CRW_ID
			left join #cms_currentrank cms on cms.CRW_ID = ff.CRW_ID
			left join #cms_nextrank cmsn on cmsn.CRW_ID = ff.CRW_ID
			left join #NAN nan on nan.crw_id = ff.crw_id
			left join #docsuploadedbySF docsf on docsf.Crw_ID = ff.crw_id
			left join #docsuploadedbyOffice docsof on docsof.Crw_ID = ff.crw_id
			left join #can av on av.CRW_ID = ff.crw_id
			outer apply (select top (1) os.crw_id, os.crd_id, os.crd_issued
							from #crewseminar os 
							where os.crw_id = ff.crw_id
							order by os.crd_issued desc) sem
			--where ff.MANAGEMENT_TYPE_FINAL = 'Full Management'
			where ff.RANK_CATEGORY in ('Junior Officers', 'Senior Officers')

			-- last service before ob service

			select ls.*
			into #previousservice
			from (
				select distinct
					sd.crw_id,
					sd.set_id,
					sd.set_startdate,
					sd.set_enddate,
					lag(sd.set_id) over (partition by sd.crw_id order by sd.set_enddate desc) as [Previous Service Record ID],
					lag(sd.set_enddate) over (partition by sd.crw_id order by sd.set_enddate desc) as  [Previous End Date]
				from shipsure..crwsrvdetail sd
				where sd.set_cancelled = 0
				and sd.sas_id = 2
				and sd.sts_id in ('OB', 'OV') 
				
			) LS
			inner join #tmpfinal tf on tf.set_id_final = ls.[Previous Service Record ID]
			--where ls.crw_id = 'GRAG00001106'

			select ff.*,
			case 
				when ff.management_type_final = 'Full Management' and ff.[VLoyalty Registration] = 'Registered' then 'Pool 1'
				when ff.MANAGEMENT_TYPE_FINAL = 'Full Management' and ff.[VLoyalty Registration] = 'Not Registered' then 'Pool 2'
				else 'Pool 3' end as [Pool],
			ps.[set_enddate] as [Previous End Date Final],
			case when ff.[CURRENT_STATUS] in ('ONBOARD', 'OVERLAP', 'IN-TRANSIT') then END_DATE
				 when ff.[PlanningStatus] is not null then ff.PLAN_TO_JOIN
				 else ff.LastSignOff end as [Current_Next_Last Sign Off]

			from #tmpfinal ff
			left join #previousservice PS on ps.[Previous Service Record ID] = ff.set_id_final

			drop table #tmpVessels
			drop table #tmpcrw
			drop table #last_vessel
			drop table #next_vessel
			drop table #tmpServiceCount
			drop table #FINAL
			drop table #cms_currentrank
			drop table #cms_nextrank
			drop table #loyalty
			drop table #NAN
			drop table #tmpdocs
			drop table #tmpdocsfinal
			drop table #docsuploadedbySF
			drop table #docsuploadedbyOffice
			drop table #can
			drop table #tmpfinal
			drop table #crewseminar
			drop table #previousservice