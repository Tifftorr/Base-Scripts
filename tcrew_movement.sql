
	
	declare @sDateTime as date
       select @sDateTime = '01-Jan-1900'
	  --  select @sDateTime = '01-Jan-2024'

	  ; WITH vessels AS (

	   select vd.vmd_id,
vd.vmo_id,
v.ves_id,
v.VES_IMONumber
from shipsure..vessel v
inner join shipsure..VESMANAGEMENTDETAILS vd (NOLOCK) on vd.VES_ID=v.VES_ID  

	   ),

	        office AS (

   SELECT DISTINCT VMD.VMD_ID AS [Vessel Mmgt ID]
         ,vos.CMP_ID AS [Office ID]
		 ,comp.[CMP_SHORTNAME] AS [Office]
         ,vos.VOT_ID AS [Office Type ID]
		 ,CAST(vos.VOS_ValidFrom AS DATE) AS [Valid From]
		 ,CAST(vos.VOS_ValidTo AS DATE) AS [Valid To]
   FROM [dbo].[VesManagementDetails] VMD
   INNER JOIN VESOFFICESERVICE vos ON vos.vmd_id = vmd.vmd_id AND ISNULL(vos.VOS_Deleted, 0) = 0
   INNER JOIN [dbo].[VESOFFICETYPE] vot ON vot.VOT_ID = vos.VOT_ID
   INNER JOIN [dbo].[company] comp ON comp.[CMP_ID] = VOS.[CMP_ID]
   WHERE ISNULL(vmd.VMD_Deleted, 0) = 0
   AND COALESCE(VMD.VMD_ManageStart,vmd.VMD_PurchStart) IS NOT NULL  
   AND VOS_ValidFrom IS NOT NULL

   ),

--into onsigners
	Onsigners AS (

       select distinct sd.CRW_ID as [Crew ID],	   
										COALESCE(brank.rnk_description, rank.rnk_description) AS [Crew Rank],
										COALESCE(bd.DEP_Name, d.DEP_Name) AS [Crew Department],
										CASE WHEN sas_id = 1 THEN 'Onboard'
										     WHEN sas_id = 2 THEN 'History'
											 WHEN sas_id = 3 THEN 'Planned'
											 ELSE 'Unmapped'
											 END AS [Crew Movement Status],
										sct.CCN_Description AS [Crew Contract Type],
                                         sd.SET_StartDate AS [SET_StartDate],
                                         sd.SET_EndDate AS [SET_EndDate],
										 case when  SD.SET_ContractLengthUnit = 'M' then SD.set_contdays * 30 
										      when SD.SET_ContractLengthUnit = 'W' then SD.set_contdays * 7
										      else SD.set_contdays 
											  end as [Contract Days],
										CMP2.CMP_Name as [SFC],
										case when sd.SET_ContractType = 'VSHP00000003' or ([SET_3rdPartyAgent] IS NOT NULL or PD.CRW_3rdPartyAgent is not null) then coalesce(CMP3.CMP_NAME, CMP4.cmp_name) 
										      ELSE NULL 
											  end as [TPA],
                                         p.PRT_Name AS [Load Port],
                                         c.CNT_Desc AS [Country],
                                         sd.ves_id AS [Vessel ID], 
										 v.VES_IMONumber AS [IMO],
										 vms.vmd_id AS [Vessel Mgmt ID],
										 tech.[Office ID] AS [Tech Mgmt Office ID],										 
										 rep.[Office ID] AS [Reporting Office ID],
										 crew.[Office ID] AS [Crewing Office ID],										 
										 crew.[Office] AS [Crewing Office],
                                         NULL  as [SignOff Reason],
                                         'SignOn' as [Action],
									    cast(sd.SET_StartDate as date) as [Activity Date],
										1 as [Change Count],
										--coalesce(sd.vmd_id,v.vmd_id) as [VMD_ID],
										--coalesce(sd.vmo_id,v.vmo_id) as [VMO_ID],
										sd.vmo_id,
										rel.CRW_ID as [Reliever Crew ID],
										rel.crw_forename AS [Reliever Crew Name],
									    rel.crw_surname AS [Reliever Crew Surname],
										relf.SET_StartDate AS [Relief Date],
										cast(ph.CPH_UpdatedOn AS DATE) as [Approved on Date],
										CCA.CCA_Description AS [Crew Rank Category],
										CL.CSS_ID as [Berth Type],
										CL.SVL_RelieverNotRequired as [Reliever Not Required],
										pl.cpl_description as [Seafarer Planning Cell],
										mob.cpl_description as [Seafarer Mobilisation Cell],
										cast(CH.MCH_Signedon as date) as [Mobilisation Checklist Signed On],
										cast(PH2.CPH_UpdatedOn as date) as [Marked as Ready On],
										cast(ET.EXT_CrewReadyOn as date) as [Estimated Readiness Date],
										NULL as [Last Completed Appraisal Reviewed On],
										NULL as [Debriefing Contacted On],
										cast(f2f.CJB_BreifingDate as date) as [F2F Pre-Joining Supt Briefing Date]
																	
										
              from          shipsure.dbo.CRWSrvDetail sd (nolock) 
              INNER join    shipsure.dbo.CRWPersonalDetails pd  (nolock)  on pd.CRW_ID=sd.CRW_ID and pd.CRW_Cancelled=0
              LEFT join     shipsure.dbo.CRWSignOffType cc (nolock)  on cc.SGT_ID = sd.SGT_ID 
              LEFT join     shipsure.dbo.company cp (nolock)  on cp.cmp_id=pd.CRW_CrewManagementOff
			  LEFT join     shipsure.dbo.company cp1 (nolock) on cp1.cmp_id=pd.CRW_SecondedOffice 			   
	          LEFT JOIN COMPANY CMP2 (NOLOCK) ON CMP2.CMP_ID = PD.CRW_CrewSupplyOffice
			  LEFT JOIN COMPANY CMP3 (NOLOCK) ON CMP3.CMP_ID = sd.[SET_ContractCompany]
	          LEFT JOIN COMPANY CMP4 (NOLOCK) ON CMP4.CMP_ID = PD.CRW_3rdPartyAgent
			  LEFT join     shipsure.dbo.CRWPool mob (nolock) on mob.cpl_id=pd.CPL_ID
			  LEFT join     shipsure.dbo.CRWPool pl (nolock) on pl.cpl_id=pd.CPL_ID_plan
              LEFT join     shipsure.dbo.PORT p (nolock) on p.PRT_ID=sd.SET_LoadPortID
              LEFT join     shipsure.dbo.country c (nolock) on c.CNT_ID=p.CNT_ID
			  LEFT join shipsure.dbo.NATIONALITY n (nolock) on n.nat_id=pd.nat_id
			  LEFT join shipsure.dbo.crwranks  rank (nolock)  on rank.rnk_id=sd.rnk_id	
			  LEFT JOIN shipsure.dbo.department d On d.DEP_ID = rank.DEP_ID		  
			  left join shipsure.dbo.crwranks brank (nolock) on brank.rnk_id=sd.RNK_ID_Budgeted
			  LEFT JOIN shipsure..CRWRankCategory cca (NOLOCK) on cca.CCA_ID = brank.CCA_ID 
			  LEFT JOIN shipsure.dbo.department bd On bd.DEP_ID = brank.DEP_ID	
			  LEFT join vessels v (nolock) on v.ves_id=sd.ves_id
			  OUTER APPLY (

							SELECT TOP (1) vms.VMD_ID
							FROM shipsure.dbo.VESMANAGEMENTDETAILS vms (nolock)  
							WHERE vms.VES_ID=sd.VES_ID 
							AND cast(sd.SET_StartDate as DATE) BETWEEN vms.VMD_ManageStart AND ISNULL(vms.VMD_ManageEnd, GETDATE())					
							AND ISNULL(vms.VMD_Deleted, 0) = 0
							ORDER BY COALESCE(vms.VMD_ManageStart, vms.VMD_PurchStart) DESC

			  ) vms
              LEFT JOIN office tech ON tech.[Vessel Mmgt ID] = vms.vmd_id AND tech.[Office Type ID] = 'GLAS00000005' AND (cast(sd.SET_StartDate as DATE) BETWEEN tech.[Valid From] AND ISNULL(tech.[Valid To], GETDATE()) OR cast(sd.SET_EndDate as DATE) BETWEEN tech.[Valid From] AND ISNULL(tech.[Valid To], GETDATE()))
              LEFT JOIN office rep ON rep.[Vessel Mmgt ID] = vms.vmd_id AND rep.[Office Type ID] = 'GLAS00000010' AND (cast(sd.SET_StartDate as DATE) BETWEEN rep.[Valid From] AND ISNULL(rep.[Valid To], GETDATE()) OR cast(sd.SET_EndDate as DATE) BETWEEN rep.[Valid From] AND ISNULL(rep.[Valid To], GETDATE()))
			  LEFT JOIN office crew ON crew.[Vessel Mmgt ID] = vms.vmd_id AND crew.[Office Type ID] = 'GLAS00000006' AND (cast(sd.SET_StartDate as DATE) BETWEEN crew.[Valid From] AND ISNULL(crew.[Valid To], GETDATE()) OR cast(sd.SET_EndDate as DATE) BETWEEN crew.[Valid From] AND ISNULL(crew.[Valid To], GETDATE()))
			  LEFT join    shipsure.dbo.CRWPersonalDetails rel (nolock) on rel.CRW_ID=sd.SET_RelieverID and rel.CRW_Cancelled=0			  
			  LEFT JOIN  shipsure.dbo.CRWSrvContractType sct ON sct.CCN_ID = sd.set_contracttype
						outer apply (
							Select top (1) cph.cph_updatedon
								from Shipsure..CRWPlanningHistory (nolock) cph
								where cph.CSA_ID_New = 'VSHP00000002'
								and cph.cph_cancelled = 0
								and cph.set_id = sd.set_id
								order by cph.cph_updatedon asc				
						) PH

			  LEFT JOIN shipsure.[dbo].[CRWCLVesCrewList] (NOLOCK) CL on cl.svl_id = sd.svl_id and cl.svl_deleted = 0 --connect to berths
						outer apply (
							Select top (1) mch.MCH_SignedOn
								from Shipsure..CRWMobilisationCheckListHeader (nolock) mch
								where mch.MCH_Status IN ('GLAS00000002','GLAS00000003')
								and mch.MCH_Cancelled = 0
								and mch.set_id = sd.set_id
								order by mch.mch_signedon asc		
						) CH
						outer apply (
							Select top (1) cph2.cph_updatedon
								from Shipsure..CRWPlanningHistory (nolock) CPH2
								where cph2.CSA_ID_New = 'VSHP00000004'
								and cph2.cph_cancelled = 0
								and cph2.set_id = sd.set_id
								order by cph2.cph_updatedon asc

						) PH2

						outer apply (
							Select top (1) ext.EXT_CrewReadyOn
								from shipsure..[CRWSrvDetailExtension] (nolock) EXT
								where ext.ext_cancelled = 0
								and ext.set_id = sd.set_id
								order by ext.EXT_CrewReadyOn desc
						) ET

						outer apply (
							Select top (1) CJB.CJB_BreifingDate
								from shipsure..CRWOBJoiningBrief (nolock) CJB
								where CJB.SET_ID  = sd.set_id
								and cjb.CJB_BreifingDate >= dateadd(month,datediff(month,0,sd.SET_StartDate)-24,0)
								and cjb.CJB_IsDeleted = 0
								and cjb.CJB_IsAddedInOffice = 1
								and cjb.AAL_ID_ReviewedBy = 'GLAS00000024'
								and cjb.CJB_AttendanceType = 1
								order by CJB.CJB_BreifingDate desc
						) F2F
						

			  			  OUTER APPLY (
							SELECT TOP (1) sd1.SET_StartDate
							FROM shipsure.dbo.CRWSrvDetail sd1
							WHERE sd1.[VES_ID] = sd.VES_ID
							AND sd.SET_RelieverID = sd1.CRW_ID
							and sd1.SET_Cancelled=0
							AND sd1.SET_StartDate > sd.SET_StartDate
							ORDER BY sd1.SET_StartDate ASC
							) relf

	              where           sd.SET_Cancelled=0
              and           sd.SET_PreviousExp = 0
              and                        pd.CRW_Cancelled = 0
              and           (sas_id is null or sas_id <> (3) )
              and           sd.STS_ID in ('OB','OV')
              and           cast(sd.SET_StartDate as DATE) >@sDateTime
              --and           cast(sd.SET_StartDate as DATE) < GETDATE()
			 ),

    OffSigners AS (			

       select distinct sd.CRW_ID as [Crew ID],
										COALESCE(brank.rnk_description, rank.rnk_description) AS [Crew Rank],
                                        COALESCE(bd.DEP_Name, d.DEP_Name) AS [Crew Department],
										CASE WHEN sas_id = 1 THEN 'Onboard'
										     WHEN sas_id = 2 THEN 'History'
											 WHEN sas_id = 3 THEN 'Planned'
											 ELSE 'Unmapped'
											 END AS [Crew Movement Status],
										sct.CCN_Description AS [Crew Contract Type],
                                         sd.SET_StartDate AS [SET_StartDate],
                                         sd.SET_EndDate AS [SET_EndDate],
										 case when  SD.SET_ContractLengthUnit = 'M' then SD.set_contdays * 30 
										      when SD.SET_ContractLengthUnit = 'W' then SD.set_contdays * 7
										      else SD.set_contdays 
											  end as [Contract Days],
										CMP2.CMP_Name as [SFC],
										case when sd.SET_ContractType = 'VSHP00000003' or ([SET_3rdPartyAgent] IS NOT NULL or PD.CRW_3rdPartyAgent is not null) then coalesce(CMP3.CMP_NAME, CMP4.cmp_name) 
										      ELSE NULL 
											  end as [TPA],
                                         p.PRT_Name AS [Load Port],
                                         c.CNT_Desc AS [Country],
                                         sd.ves_id AS [Vessel ID], 
										 v.VES_IMONumber AS [IMO],
										 vms.vmd_id  AS [Vessel Mgmt ID],
										 tech.[Office ID] AS [Tech Mgmt Office ID],										 
										 rep.[Office ID] AS [Reporting Office ID],
										 crew.[Office ID] AS [Crewing Office ID],
										 crew.[Office] AS [Crewing Office],
                                        SGT_Desc  as [SignOff Reason],
                                        'SignOff' as [Action],
                                        sd.SET_EndDate as [Activity Date],
										1 as [Change Count],
										--coalesce(sd.vmd_id,v.vmd_id) as [VMD_ID],
										--coalesce(sd.vmo_id,v.vmo_id) as [VMO_ID],
										sd.vmo_id,
										rel.CRW_ID as [Reliever Crew ID],
										rel.crw_forename AS [Reliever Crew Name],
									    rel.crw_surname AS [Reliever Crew Surname],
										relf.SET_StartDate AS [Relief Date],
										NULL AS [Approved on Date],
										CCA.CCA_Description AS [Crew Rank Category],
										NULL as [Berth Type],
										NULL as [Reliever Not Required],
										pl.cpl_description as [Seafarer Planning Cell],
										mob.cpl_description as [Seafarer Mobilisation Cell],
										NULL as [Mobilisation Checklist Signed On],
										NULL as [Marked as Ready On],
										NULL as [Estimated Readiness Date],
										cast(APPR.CAH_ReviewedOn as date) as [Last Completed Appraisal Reviewed On],
										cast(DEB.CDB_ContactedOn as date) as [Debriefing Contacted On],
										NULL as [F2F Pre-Joining Supt Briefing Date]

              from shipsure.dbo.CRWSrvDetail sd
              INNER join    shipsure.dbo.CRWPersonalDetails pd (nolock) on pd.CRW_ID=sd.CRW_ID and pd.CRW_Cancelled=0
              LEFT join     shipsure.dbo.CRWSignOffType cc (nolock)  on cc.SGT_ID = sd.SGT_ID 
              LEFT join     shipsure.dbo.company cp (nolock)  on cp.cmp_id=pd.CRW_CrewManagementOff
			  LEFT join     shipsure.dbo.company cp1 (nolock)  on cp1.cmp_id=pd.CRW_SecondedOffice 
	          LEFT JOIN COMPANY CMP2 (NOLOCK) ON CMP2.CMP_ID = PD.CRW_CrewSupplyOffice
			  LEFT JOIN COMPANY CMP3 (NOLOCK) ON CMP3.CMP_ID = sd.[SET_ContractCompany]
	          LEFT JOIN COMPANY CMP4 (NOLOCK) ON CMP4.CMP_ID = PD.CRW_3rdPartyAgent
			  LEFT join     shipsure.dbo.CRWPool mob (nolock)  on mob.cpl_id=pd.CPL_ID
			  LEFT join     shipsure.dbo.CRWPool pl (nolock)  on pl.cpl_id=pd.CPL_ID_plan
              LEFT join     shipsure.dbo.PORT p (nolock)  on p.PRT_ID=sd.set_disportID
              LEFT join     shipsure.dbo.country c (nolock)  on c.CNT_ID=p.CNT_ID
			  LEFT join shipsure.dbo.nationality n (nolock)  on n.nat_id=pd.NAT_ID
			  LEFT join shipsure.dbo.crwranks  rank (nolock)  on rank.rnk_id=sd.rnk_id
			  LEFT JOIN shipsure..CRWRankCategory cca (NOLOCK) on cca.CCA_ID = rank.CCA_ID 
			  LEFT JOIN shipsure.dbo.department d On d.DEP_ID = rank.DEP_ID		  
			  left join shipsure.dbo.crwranks brank (nolock) on brank.rnk_id=sd.RNK_ID_Budgeted
			  LEFT JOIN shipsure.dbo.department bd On bd.DEP_ID = brank.DEP_ID		  
			  LEFT join vessels v (nolock)  on v.ves_id=sd.ves_id
			  OUTER APPLY (

							SELECT TOP (1) vms.VMD_ID
							FROM shipsure.dbo.VESMANAGEMENTDETAILS vms (nolock)  
							WHERE vms.vmd_id=sd.vmd_id 
							AND cast(sd.SET_enddate as DATE) BETWEEN vms.VMD_ManageStart AND ISNULL(vms.VMD_ManageEnd, GETDATE())	
							ORDER BY COALESCE(vms.VMD_ManageStart, vms.VMD_PurchStart) DESC

			  ) vms
			  LEFT JOIN office tech ON tech.[Vessel Mmgt ID] = vms.vmd_id AND tech.[Office Type ID] = 'GLAS00000005' AND (cast(sd.SET_StartDate as DATE) BETWEEN tech.[Valid From] AND ISNULL(tech.[Valid To], GETDATE()) OR cast(sd.SET_EndDate as DATE) BETWEEN tech.[Valid From] AND ISNULL(tech.[Valid To], GETDATE()))
              LEFT JOIN office rep ON rep.[Vessel Mmgt ID] = vms.vmd_id AND rep.[Office Type ID] = 'GLAS00000010' AND (cast(sd.SET_StartDate as DATE) BETWEEN rep.[Valid From] AND ISNULL(rep.[Valid To], GETDATE()) OR cast(sd.SET_EndDate as DATE) BETWEEN rep.[Valid From] AND ISNULL(rep.[Valid To], GETDATE()))
			  LEFT JOIN office crew ON crew.[Vessel Mmgt ID] = vms.vmd_id AND crew.[Office Type ID] = 'GLAS00000006' AND (cast(sd.SET_StartDate as DATE) BETWEEN crew.[Valid From] AND ISNULL(crew.[Valid To], GETDATE()) OR cast(sd.SET_EndDate as DATE) BETWEEN crew.[Valid From] AND ISNULL(crew.[Valid To], GETDATE()))
		      LEFT join    shipsure.dbo.CRWPersonalDetails rel (nolock) on rel.CRW_ID=sd.SET_RelieverID and rel.CRW_Cancelled=0
			  LEFT JOIN  shipsure.dbo.CRWSrvContractType sct ON sct.CCN_ID = sd.set_contracttype
			  OUTER APPLY (
							SELECT TOP (1) sd1.SET_StartDate
							FROM shipsure.dbo.CRWSrvDetail sd1
							WHERE sd1.[VES_ID] = sd.VES_ID
							AND sd.SET_RelieverID = sd1.CRW_ID
							and sd1.SET_Cancelled=0
							AND sd1.SET_StartDate > sd.SET_StartDate
							ORDER BY sd1.SET_StartDate ASC

							) relf

			outer apply (
				Select top (1) cah.CAH_ReviewedOn
					from Shipsure..CRWOBAppraisal (NOLOCK) CAH
					inner join Shipsure..CRWAppraisalAttributeLookup (nolock) aal on aal.AAL_ID = CAH.AAL_ID_Status
					where aal.AAL_Name = 'Completed'
					and CAH.CAH_IsDeleted = 0
					and cah.SET_ID_Appraisee =  sd.set_id
					order by cah.CAH_ReviewedOn desc
			) APPR

			outer apply (
				Select top (1) cdb.CDB_ContactedOn
					from ShipSure..[CRWDebriefing] CDB
					where cdb.CDB_Cancelled = 0
					and (cdb.cdb_statusid = 3 or cdb.cdb_statusid = 1)
					and cdb.set_id = sd.set_id
					order by cdb.CDB_ContactedOn desc
			) DEB

              where           sd.SET_Cancelled=0
              and           sd.SET_PreviousExp = 0
              and           pd.CRW_Cancelled = 0
              and           (sas_id is null or sas_id <> (3) )
              and           sd.STS_ID in ('OB','OV')
              and           cast(sd.SET_enddate as DATE) >=@sDateTime
              and           cast(sd.SET_enddate as DATE) <= GETDATE()
              and                  SET_ActiveStatus = 0
		
		)



			  select ROW_NUMBER() OVER(ORDER BY [Crew ID] ASC) AS [Row],
			         LHS.[Crew ID],
					 LHS.[Crew Rank],
					 LHS.[Crew Department],
					 LHS.[Crew Movement Status],
					 LHS.[Crew Contract Type],
					 LHS.SET_StartDate,
					 LHS.SET_EndDate,
					 LHS.[Contract Days],
					 LHS.[SFC],
					 LHS.[TPA],
					 LHS.[Load Port],
					 LHS.[Country],
					 LHS.[Vessel ID], 
					-- LHS.IMO,
					 LHS.[Vessel Mgmt ID],
					 LHS.[Tech Mgmt Office ID],										 
					 LHS.[Reporting Office ID],
					 LHS.[Crewing Office ID],
					 LHS.[Crewing Office],
					 COALESCE(LHS.[Tech Mgmt Office ID], LHS.[Reporting Office ID]) AS [ShipSure Mapping Office ID],
					 LHS.[SignOff Reason],
					 LHS.[Action],
					 LHS.[Activity Date],
					 LHS.[Change Count],
					-- LHS.[VMD_ID],
					 LHS.[VMO_ID],
					 LHS.[Reliever Crew ID],
					 LHS.[Reliever Crew Name],
					 LHS.[Reliever Crew Surname],
					 LHS.[Relief Date],
					 /*LHS.[Approved on Date],
					 LHS.[Crew Rank Category],
					 LHS.[Berth Type],
					 LHS.[Reliever Not Required],
					 LHS.[Seafarer Planning Cell],
					 LHS.[Seafarer Mobilisation Cell],
					 LHS.[Mobilisation Checklist Signed On],*/
					 BINARY_CHECKSUM(LHS.[Crew ID],
					                 LHS.[Crew Rank],
									LHS.[Crew Department],
									LHS.[Crew Movement Status],
									 LHS.SET_StartDate,
									 LHS.SET_EndDate,
									 LHS.[Contract Days],
									 LHS.[SFC],
									 LHS.[TPA],
									 LHS.[Load Port],
									 LHS.[Country],
									 LHS.[Vessel ID], 
									-- LHS.IMO,
									LHS.[Vessel Mgmt ID],
									LHS.[Tech Mgmt Office ID],										 
									LHS.[Reporting Office ID],
									LHS.[Crewing Office ID],
									LHS.[Crewing Office],
									COALESCE(LHS.[Tech Mgmt Office ID], LHS.[Reporting Office ID]),
									 LHS.[SignOff Reason],
									 LHS.[Action],
									 LHS.[Activity Date],
									 LHS.[Change Count],
									-- LHS.[VMD_ID],
									 LHS.[VMO_ID],
									 LHS.[Reliever Crew ID],
									 LHS.[Reliever Crew Name],
									 LHS.[Reliever Crew Surname],
									 LHS.[Relief Date]) AS [ChangeIdentifier],
									 LHS.[Approved on Date],
									 LHS.[Crew Rank Category],
									 LHS.[Berth Type],
									 LHS.[Reliever Not Required],
									 LHS.[Seafarer Planning Cell],
									 LHS.[Seafarer Mobilisation Cell],
									 LHS.[Mobilisation Checklist Signed On],
									 LHS.[Marked as Ready On],
									 LHS.[Estimated Readiness Date],
									 LHS.[Last Completed Appraisal Reviewed On],
									 LHS.[Debriefing Contacted On],
									 LHS.[F2F Pre-Joining Supt Briefing Date]

		FROM 
    (   select  *, ROW_NUMBER() OVER (PARTITION BY [Vessel ID], [Crew ID] ORDER BY [Activity Date] DESC) AS [OnOrder], NULL AS [OffOrder]
       from Onsigners
       union 
       select *, NULL AS [OnOrder], ROW_NUMBER() OVER (PARTITION BY [Vessel ID], [Crew ID] ORDER BY [Activity Date] DESC) AS [OffOrder]
       from OffSigners 
	   
      ) LHS 
where  ([SignOff Reason] is null or [SignOff Reason] not in ('Promotion', 'Transfer'))
--AND LHS.IMO = '9387683'
--and lhs.[Crew ID] = 'VGR300041973'
ORDER BY [Activity Date] ASC