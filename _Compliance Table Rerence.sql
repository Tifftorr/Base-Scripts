
SELECT * INTO #tmpVes FROM(
		select v.ves_id
		, v.VES_Name/*
		, cpt.CMP_Name as TechOffice
		, cpr.CMP_Name as RespOffice*/
		, cpc.CMP_Name as CrewOffice/*
		, cmp.CMP_Name as Client
		,vmd_managestart*/
		,vd.VMD_ID
		,DENSE_RANK() OVER (PARTITION BY V.VES_ID ORDER BY  vd.vmd_managestart desc, vmd_UpdatedOn ) LV
		from shipsure..vessel v
		inner join shipsure..VESMANAGEMENTDETAILS vd (NOLOCK) on vd.VES_ID=v.VES_ID  
		
		LEFT JOIN shipsure..VESOFFICESERVICE ot (NOLOCK) ON ot.VMD_ID = VD.VMD_ID AND ot.VOS_Deleted = 0 AND ot.VOT_ID IN ('GLAS00000005') -- technical office
		LEFT JOIN shipsure..VESOFFICESERVICE ro (NOLOCK) ON ro.VMD_ID = VD.VMD_ID AND ro.VOS_Deleted = 0 AND ro.VOT_ID IN ('GLAS00000003') -- responsible office*/
		LEFT JOIN shipsure..VESOFFICESERVICE co (NOLOCK) ON co.VMD_ID = VD.VMD_ID AND co.VOS_Deleted = 0 AND co.VOT_ID IN ('GLAS00000006') -- crew office
		left join shipsure..COMPANY cpt (NOLOCK) on cpt.CMP_ID=ot.CMP_ID
		left join shipsure..COMPANY cpr (NOLOCK) on cpr.CMP_ID=ro.CMP_ID
		left join shipsure..COMPANY cpc (NOLOCK) on cpc.CMP_ID=co.CMP_ID
		left join shipsure..company cmp (NOLOCK) on cmp.cmp_id = VD.VMD_Owner

		
		where -- vd.VMO_ID IN ('GLAS00000007','GLAS00000003')and 
		(VMD_ManageEnd IS NULL or cast(VMD_ManageEnd as date)>=cast(GETDATE() as date))
		and (VMD_Deleted is null or VMD_Deleted=0) 
		AND  ( ((cast(VMD_ManageStart as date)<=cast(GETDATE() as date) or (VMD_ManageStart is null 
		AND(cast(VMD_ManESTDateStart as date) is null or cast(VMD_ManESTDateStart as date)<=cast(GETDATE() as date)))) and VSS_ID in ('01','06')) OR ( VSS_ID='06' AND VMD_ManESTDateStart is not null))
		and v.VES_Onboard2>0
		and v.VSS_ID in ('01','06')
		--and v.ves_id='GLAS00011674'
		--and cpt.cmp_name like '%glasgow%'
	--	and ves_name='uruguay'

		) LH WHERE LV=1
	--	select * from #tmpVes where VES_Name like '%shakti%'
	
select
	r.CRW_PID as PCN
	,r.crw_id
    , r.VES_ID
	, v.VMD_ID
	--,r.VES_Name
    , r.CRW_Surname
--  , r.NAT_ID
    , nat.NAT_Description as CrewNationality,
	r.rnk_id
	,Rank_SN1 = case  
				 when CCA_IsOfficer = 1 then '0' + cast(rnk.RNK_SequenceNumber as varchar(20))
				 when CCA_IsOfficer = 0 then '1' + cast(rnk.RNK_SequenceNumber as varchar(20))  end 
    , mc.CPL_Description as MobCell
    , cc.CMP_Name  as MobilisationOffice
 -- , mc.SIT_ID  as MobilisationOfficeID
    , pc.CPL_Description as PlanCell
    , cd.SIT_Name as PlanningOffice
	 , cmp.CPL_Description as CMPCell
    --, cd1.SIT_Name as CMPOffice
    , CAST(r.SET_StartDate as Date) as StartDate
    , CAST(r.SET_EndDate as Date) as EndDate
    , Crew_Status = case when Crew_Status = 'O' then 'Onboard' else 'Reliever' end
	, r.CRD_Number
	, r.DOC_ID
    , CRD_Country
    , CRD_Issued
    , CRD_Expiry
    , r.DOC_Desc
	,m.DOC_Desc as DocumentGeneralName
    ,SignOn_Status = case when r.TMC_ShortCode='REC' THEN 'Warning'
	when SignOn_Status='N' then 'Non-Compliant'
                           when SignOn_Status='W' then 'Warning'		
						   else 'Compliant' end

     ,SignOff_Status= Case when r.TMC_ShortCode='REC' THEN 'Warning'
						when (  SignOn_Status!='N' and ( SignOff_Note like '%Document%expires%before Sign Off%' or SignOff_Note like 'Validity Period%expires before Sign Off%' or SignOff_Note like 'Grace period of%will expire before Sign Off%' or SignOn_Note like '%Grace period of%from Sign On allowed%')) or SignOff_Status='W' then 'Warning' 
							when SignOff_Status='N' then 'Non-Compliant'
                            else 'Compliant' end
/*,case when signon_note='' or signon_note is null or signon_note=' By Waiver' or signon_note like '%covered%' or  SignOn_Note like '%Equivalent%'  or signon_note like 'Grace period of%from Sign On allowed' then signoff_note else signon_note end as Note*/
		, Note =case when signon_note like'%waiver%' and  signoff_note!='' then  signoff_note+ '. By Waiver'
					when (signon_note='' or signon_note is null or signon_note like'%waiver%' or signon_note like '%covered%' or  SignOn_Note like '%Equivalent%'  or signon_note like 'Grace period of%from Sign On allowed') and signoff_note!='' then signoff_note
					when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' )and r.TMC_ShortCode like '%12M%' and  (cast(dateadd(MONTH,12,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O')then 'Grace period of 12 Months from Sign On allowed'
					when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' )and r.TMC_ShortCode like '%6M%' and  (cast(dateadd(MONTH,6,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O')then 'Grace period of 6 Months from Sign On allowed'
					when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' )and r.TMC_ShortCode like '%12W%' and  (cast(dateadd(WEEK,12,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O')then 'Grace period of 12 weeks from Sign On allowed'
					when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' ) and  r.TMC_ShortCode like '%8W%' and  (cast(dateadd(WEEK,8,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O') then 'Grace period of 8 weeks from Sign On allowed'
					when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' ) and  r.TMC_ShortCode like 'M%' and  (cast(dateadd(WEEK,4,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O') then 'Grace period of 4 weeks from Sign On allowed'
					when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' )and r.TMC_ShortCode like 'W%' and  (cast(dateadd(WEEK,1,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O')then 'Grace period of 1 week from Sign On allowed'
					when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' )and r.TMC_ShortCode like '%12M%' and  (cast(dateadd(MONTH,12,r.SET_StartDate) as date)<=cast(getdate() as date) )then 'Grace period of 12 Months from Sign On has passed'
					when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' )and r.TMC_ShortCode like '%6M%' and  (cast(dateadd(MONTH,6,r.SET_StartDate) as date)<=cast(getdate() as date) )then 'Grace period of 6 Months from Sign On has passed'
					when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' ) and r.TMC_ShortCode like '%12W%' and  cast(dateadd(WEEK,12,r.SET_StartDate) as date)<=cast(getdate() as date) then 'Grace period of 12 weeks from Sign On has passed'
					when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' ) and  r.TMC_ShortCode like '%8W%' and  cast(dateadd(WEEK,8,r.SET_StartDate) as date)<=cast(getdate() as date) then 'Grace period of 8 weeks from Sign On has passed'
					when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' ) and  r.TMC_ShortCode like 'M%' and  cast(dateadd(WEEK,4,r.SET_StartDate) as date)<=cast(getdate() as date) then 'Grace period of 4 weeks from Sign has passed'
					when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' ) and  r.TMC_ShortCode like 'W%' and  cast(dateadd(WEEK,1,r.SET_StartDate) as date)<=cast(getdate() as date) then 'Grace period of 1 week from Sign has passed'
					when signon_note=''and SignOff_Note='' then 'Compliant' 
					else signon_note end 
	 , GracePeriodWeeks= case when r.TMC_ShortCode like '%12M%'then '12 Months'
						 when r.TMC_ShortCode like '%6M%'then '6 Months'
						when r.TMC_ShortCode like '%12W%' then '12 weeks'
						when  r.TMC_ShortCode like '%8W%'  then '8 weeks'
						when  r.TMC_ShortCode like 'M%' then '4 weeks'
						when  r.TMC_ShortCode like 'W%' then '1 week' end
		
	,signon_note
	,signoff_note
    ,tmt.TMT_Name
	,TMT_Core
    ,r.TMC_ShortCode
	,cmm.TMC_Description
	,cmm.TMC_Description as TMC_Description1
	,r.TMC_ShortCode as TMC_ShortCode1
	,case when tMC_Description like '%Within%'and  r.TMC_ShortCode like '%M%' then cast(dateadd(WEEK,4,r.SET_StartDate) as date)
	    	when tMC_Description like '%Within%'and  r.TMC_ShortCode like '%12W%' then cast(dateadd(WEEK,12,r.SET_StartDate) as date)
			when tMC_Description like '%Within%'and  r.TMC_ShortCode like '%8W%' then cast(dateadd(WEEK,8,r.SET_StartDate) as date) end as GracePeriodLastDate
					
 /* , VesFlag
    , VesType
    , VesGenType
    , Client
    ,FLEET
    , TechOffice
    , RespOffice*/
  , CrewOffice
	 /*
	  Case when ( SignOn_Status='C' and Signoff_Status='N' and
				( SignOff_Note like '%Document (vessel) expires%before Sign Off%' or SignOff_Note like 'Validity Period%expires before Sign Off%' or SignOff_Note like 'Grace period of%will expire before Sign Off%') ) then 0
	 when
	 ((SignOff_Status='N' and SignOn_Status!='W')or SignOn_Status='N')  then 1 else 0  end as 'Doc_NonCopliant',
	 */

	 , Doc_NonCopliant=  Case when r.TMC_ShortCode='REC' THEN 0
							when ( SignOn_Status='C' and  Signoff_Status='N' and ( SignOff_Note like '%Document%expires%before Sign Off%' or SignOff_Note like 'Validity Period%expires before Sign Off%' or SignOff_Note like 'Grace period of%will expire before Sign Off%') ) then 0
							  
							  when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' )and r.TMC_ShortCode like '%12M%' and  (cast(dateadd(MONTH,12,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O')then 0
							when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' )and r.TMC_ShortCode like '%6M%' and  (cast(dateadd(MONTH,6,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O')then 0
							when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' )and r.TMC_ShortCode like '%12W%' and  (cast(dateadd(WEEK,12,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O')then 0
							when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' ) and  r.TMC_ShortCode like '%8W%' and  (cast(dateadd(WEEK,8,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O') then 0
							when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' ) and  r.TMC_ShortCode like 'M%' and  (cast(dateadd(WEEK,4,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O') then 0
							when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' )and r.TMC_ShortCode like 'W%' and  (cast(dateadd(WEEK,1,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O')then 0
							--when  tMC_Description like '%Within%' and signon_note like '%Validity Period of%expires before Sign On%'  and  cast(dateadd(WEEK,12,r.SET_StartDate) as date)>cast(getdate() as date) then 0
							  when ((SignOff_Status='N' and SignOn_Status!='W') or SignOn_Status='N') then 1
						--	  when dat.doc_id is not null and( SignOn_Note like '%Grace period%from Sign On has passed'or SignOn_Note like '%Missing Mandatory document with no grace period%') then 1
			  --when SignOn_Note like '%auto update%' then 1
							 else 0  end

	 ,Documentcompliance= Case when r.TMC_ShortCode='REC' then 'Compliant'
	 when ( SignOn_Status='C' and  Signoff_Status='N' and ( SignOff_Note like '%Document%expires%before Sign Off%' or SignOff_Note like 'Validity Period%expires before Sign Off%' or SignOff_Note like 'Grace period of%will expire before Sign Off%') ) then 'Compliant'
							   
							    when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' )and r.TMC_ShortCode like '%12M%' and  (cast(dateadd(MONTH,12,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O')then 'Compliant'
								when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' )and r.TMC_ShortCode like '%6M%' and  (cast(dateadd(MONTH,6,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O')then 'Compliant'
								when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' )and r.TMC_ShortCode like '%12W%' and  (cast(dateadd(WEEK,12,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O')then 'Compliant'
								when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' ) and  r.TMC_ShortCode like '%8W%' and  (cast(dateadd(WEEK,8,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O') then 'Compliant'
								when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' ) and  r.TMC_ShortCode like 'M%' and  (cast(dateadd(WEEK,4,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O') then 'Compliant'
								when tMC_Description like '%Within%' and (signon_note like '%Validity Period of%expires before Sign On%' or SignOn_Note like '%Document expired%before Sign On%' )and r.TMC_ShortCode like 'W%' and  (cast(dateadd(WEEK,1,r.SET_StartDate) as date)>cast(getdate() as date) or Crew_Status!='O')then 'Compliant'
								--when  tMC_Description like '%Within%' and signon_note like '%Validity Period of%expires before Sign On%'  and  cast(dateadd(WEEK,12,r.SET_StartDate) as date)>cast(getdate() as date)then 'Compliant'
							   when ((SignOff_Status='N' and SignOn_Status!='W') or SignOn_Status='N') then 'Non-Compliant'
							  -- when dat.doc_id is not null and( SignOn_Note like '%Grace period%from Sign On has passed'or SignOn_Note like '%Missing Mandatory document with no grace period%') then 'Non-Compliant'
			--  when SignOn_Note like '%auto update%' then 'Non-Compliant'
							  else 'Compliant'  end 
--  ,m.DOC_Ref
	  ,tmt.TMT_ID
	  ,COALESCE(TPA.CCN_DESCRIPTION, 'Internal Supply')  AS CONTRACT_TYPE
	  ,CMP12.CMP_NAME as TPA
	  ,CompanyToExclude= case when CMP12.CMP_ID='VGRP00071032' /*and vesex.CPIReport='Excluded'*/ then 'Uniteam-Exclude' else 'Others' end
	  /*,ECDIS=			 case when m.DOC_Desc='ECDIS (Company Specific)' then ' ECDIS (Company Specific)'
							  when m.DOC_Desc='ECDIS (Generic 2010)' then 'ECDIS (Generic 2010)'
							  when m.DOC_Desc like 'ECDIS%' then 'ECDIS (Type Specific)' 
							  else 'Other' end*/
	  ,TemplateRequirement= case when r.TMC_ShortCode='REC' then 'Recommended' else 'Mandatory' end 
	   /*dat.tdi_effectivestartdate
		, dat.tdi_reportingstartdate,
		--dat.ExclusionStartDate as TrainingExclusionStartDate,
		case when dat.doc_id is not null and (dat.tdi_reportingStartDate>getdate() or dat.tdi_reportingStartDate is null) then 'New Training' else 'Old Training' end as Training,*/
	  ,tdi_effectivestartdate=/*case  when r.doc_id='VGRP00000456' and r.tmt_id in ('GLAS00000124','VGRP00000073') then '07-DEC-2021 00:00:00'else*/ dat.tdi_effectivestartdate --end
	  ,tdi_reportingstartdate--=case  when r.doc_id='VGRP00000456' and r.tmt_id in ('GLAS00000124','VGRP00000073') then '10-JAN-2022 00:00:00'else dat.tdi_reportingstartdate end 
		--dat.ExclusionStartDate as TrainingExclusionStartDate,
	  ,Training= case  --when r.doc_id='VGRP00000456' and r.tmt_id in ('GLAS00000124','VGRP00000073') then 'New Training' --ADDED HARRASSMENT
						when dat.doc_id is not null and ( cast(TDI_ReportingStartDate as date)>cast(GETDATE() as date) or dat.tdi_reportingStartDate is null) then 'New Training' 
						else 'Old Training' end
	  ,CPIReport= case when (DocumentRequirement='Statutory' or r.DOC_ID  in ('VSHP00000042','GLAS00000432','VSHP00000125') )and VESEX.ExclusionCategory='Statutory' /*and v.CPIReport='Excluded' */then 'Excluded'
					   when DocumentRequirement='VMS'  and VESEX.ExclusionCategory='VMS' and r.DOC_ID  in ('VSHP00000042','GLAS00000432','VSHP00000125') /*and v.CPIReport='Excluded'*/ then 'Excluded'
					   when VESEXall.ExclusionCategory='ALL'/* and v.CPIReport='Excluded' */then 'Excluded' 
					   when vesextpi.ExclusionCategory='TPA_TMPI' /*and v.CPIReport='Excluded'*/ and  pd.cpl_id='VGR500000053' and DocumentRequirement='VMS'then 'Excluded'
					   else 'Included' end
,COALESCE (VESEX.ExclusionStartDate,VESEXall.ExclusionStartDate,vesextpi.ExclusionStartDate) as ExclusionStartDate
,COALESCE (VESEX.ExclusionEndDate,VESEXall.ExclusionEndDate,vesextpi.ExclusionEndDate) as ExclusionEndDate
,COALESCE (VESEX.ExclusionCategory,VESEXall.ExclusionCategory,vesextpi.ExclusionCategory) as ExclusionCategory
	 --,v.ExclusionStartDate
	 --,v.ExclusionEndDate
	 --,v.ExclusionCategory
	 ,COALESCE (VESEX.REMARK,VESEXall.REMARK,vesextpi.REMARK)REMARK
	 ,FlagState= case when r.DOC_Desc like '%flag%' then 'YES' else 'No' end 
	 ,RequirementType= case when r.DOC_ID in ('VSHP00000084','VSHP00000016','VSHP00000083') then 'Statutory' else typ.DocumentRequirement end 
	 ,DefaultTemplate= case when DT.TMT_ID IS NOT NULL THEN 'YES' ELSE 'NO' END,
	  
	  case when typ.CDT_ID in ('VSHP00000002','GLAS00000029','GLAS00000032','') or typ.DOC_CertifOfCompetency=1 then 'COC' 
		when typ.CDT_ID in ('VSHP00000007','GLAS00000035') or typ.DocumentRequirement='Statutory'  then 'STCW'
		when typ.CDT_ID in ('VSHP00000001') then '05 Personal/ Travel' else 'Other' end as DocumentGroupType
 into #Part
from CrewCompliance..ComplianceRunOutcome r (NOLOCK)
inner join #tmpVes v on v.VES_ID=r.VES_ID 
inner join Shipsure..CRWPersonalDetails pd (NOLOCK) on r.crw_id=pd.crw_id
left join Shipsure..NATIONALITY nat (NOLOCK) on nat.NAT_ID=pd.NAT_ID
left join shipsure..crwpool mc (NOLOCK) on mc.cpl_id=pd.cpl_id --and mc.CPL_Type=1
left join shipsure.dbo.COMPANY cc (NOLOCK) on cc.cmp_id = mc.SIT_ID --- should use this as just the ID and link to new Dundas Hieracrhy
left join shipsure..crwpool pc (NOLOCK) on pc.cpl_id=pd.cpl_id_plan --and pc.CPL_Type=2
left join shipsure.dbo.globalsite cd (NOLOCK) on cd.SIT_ID = pc.SIT_ID
left join shipsure..crwpool cmp (NOLOCK) on cmp.cpl_id=pd.cpl_id_cmp --and pc.CPL_Type=2
left join shipsure.dbo.globalsite cd1 (NOLOCK) on cd1.SIT_ID = cmp.SIT_ID
inner join Shipsure..CRWTrainingMatrixTemplate tmt (NOLOCK) on r.TMT_ID=tmt.TMT_ID
inner join Shipsure.dbo.CRWTrainingMatrixCompliance cmm on cmm.TMC_ID=r.TMC_ID
inner join shipsure.dbo.CRWDocMaster m (NOLOCK) on m.doc_id=r.doc_id
inner join shipsure.dbo.crwsrvdetail sd  (NOLOCK) on sd.set_id=r.SET_ID

left join shipsure.dbo.CRWTrainingMatrixTemplateDate dat (NOLOCK) on  dat.DOC_ID=r.DOC_ID and dat.tmt_id=tmt.TMT_ID and dat.TDI_Active=1 -- and cast(TDI_ReportingStartDate as date)>=cast(GETDATE() as date) and cast(TDI_EffectiveStartDate as date)<=cast(GETDATE() as date)
--left join #CRWTrainingMatrixTemplateDate dat (NOLOCK) on  dat.DOC_ID=r.DOC_ID --and dat.tmt_id=tmt.TMT_ID 
LEFT JOIN   CRWSrvContractType TPA ON TPA.CCN_ID = pd.CRW_EmploymentType -- PD.CCN_ID
LEFT JOIN   COMPANY CMP12 (NOLOCK) ON CMP12.CMP_ID =  coalesce(pd.CRW_3rdPartyAgent, CRW_employmentEntity)
LEFT JOIN CRWRANKS rnk on rnk.rnk_id=r.RNK_ID
LEFT JOIN SHIPSURE..CRWRankCategory CCA on CCA.CCA_ID=rnk.CCA_ID
--Left join shipsure.dbo.AttributeDef def (NOLOCK) on def.AttributeName=r.VES_ID and TableName='ComplianceVesselExclusion'
Left join Aggregates.dbo.vDocumentsType typ on typ.doc_id=r.DOC_ID
LEFT JOIN Aggregates..CRWTrainingComplianceDefaultTemplate DT on DT.TMT_ID=r.TMT_ID and DT.TMT_DEFAULT_ACTIVE=1
LEFT JOIN Aggregates..CRWTrainingComplianceVesselExclusion vesex on VESEX.VES_ID=r.VES_ID  AND (VESEX.ExclusionEndDate>=getdate() or VESEX.ExclusionEndDate is null) and (VESEX.ExclusionCategory=DocumentRequirement or VESEX.ExclusionCategory is null) and VESEX.Exclusion_Active=1
LEFT JOIN Aggregates..CRWTrainingComplianceVesselExclusion vesexall on vesexall.VES_ID=r.VES_ID  AND (vesexall.ExclusionEndDate>=getdate() or vesexall.ExclusionEndDate is null) and (vesexall.ExclusionCategory='ALL') and vesexall.Exclusion_Active=1
LEFT JOIN Aggregates..CRWTrainingComplianceVesselExclusion vesextpi on vesextpi.VES_ID=r.VES_ID  AND (vesextpi.ExclusionEndDate>=getdate() or vesextpi.ExclusionEndDate is null) and (vesextpi.ExclusionCategory='TPA_TMPI') and vesextpi.Exclusion_Active=1
WHERE (dat.TDI_EffectiveStartDate is null or cast(TDI_EffectiveStartDate as date)<=cast(GETDATE() as date))
and RNK.dep_id not in ('SUPERN','SPM_OB')
-- Left join aggregates.dbo.vDocumentsType typ on typ.doc_id=r.DOC_ID
--where r.doc_desc like '%performance appraisal%'
--where r.crw_pid in ('4121STE09118')
--and r.doc_desc like '%cold%'
--and Crew_Status='o'
--where dat.doc_id is not null
--and r.DOC_ID='VSHP00000016'
--and r.crw_pid='0121MUB56136'
 -- and r.TMT_ID='GLAS00000054'
order by crw_id
/*
select crw_id, --sum(Doc_NonCopliant),
case when sum(Doc_NonCopliant) >=1 then 'Non-Compliant' else  'Compliant' end as 'Crew_Compliance',
case when sum(Doc_NonCopliant) >=1 then 1 else  0 end as 'NonCompliantCrew'
into #CREW
from #Part
group by CRW_ID 
order by crw_id

*/


-----------------------COURSES AFTER 1st JUL----------------------
	UPDATE #Part
	 SET SignOn_Status = case when SignOn_Status = 'Non-Compliant' then 'Warning' else SignOn_Status end,
		  SignOn_Note = case when SignOn_Status = 'Non-Compliant' then 'Eff. 01/07/2021 - auto update' else SignOn_Note end,
		  SignOff_Status = case when SignOff_Status = 'Non-Compliant' then 'Warning' else SignOff_Status end,
		  SignOff_Note = case when SignOff_Status = 'Non-Compliant' then 'Eff. 01/07/2021 - auto update' else SignOff_Note end,
		  Note= case when Note like '%Waiver%' then  Note + '. Eff. 01/07/2021' else '. Eff. 01/07/2021 - auto update' end,
		  Doc_NonCopliant=0,
		  Documentcompliance='Compliant'
	 WHERE TMT_ID in ('VGRP00000073','GLAS00000124')
	   and ((DOC_ID in ( 'VSHP00000119','GLAS00000523')/* and RNK_ID not in ('VSHP00000002','VSHP00000010','VSHP00000008','VSHP00000012','VSHP00000068','VSHP00000071','VSHP00000072')*/)
		or (DOC_ID IN ('GLAS00000477') and (SignOff_Note not like 'Missing%' or SignOn_Note not like 'Missing')
				and Note not like 'Missing%' ))
	   and (SignOn_Status = 'Non-Compliant' or SignOff_Status='Non-Compliant' or note like '%Waiver%')
	   and StartDate<'2021-07-01'
	   
		--CLEAR OUT PRE (SO) for VMS_OTG TEmplate
		--Risk Management--
	UPDATE #Part
   SET SignOn_Status = case when note like '%waiver%' then SignOn_Status else 'Warning' end,
       SignOn_Note = case when note like '%waiver%' then 'By Waiver. (Grace Period allowed)' else 'Grace period of 12 weeks from Sign On allowed - auto update' end,
       SignOff_Status = case when note like '%waiver%' then Signoff_status /*when cast(dateadd(WEEK,12,StartDate) as date)<cast(EndDate as Date)  then 'Warning' else 'Compliant'*/ else 'Warning' end,
       SignOff_Note = case when note like '%waiver%'then '' when cast(dateadd(WEEK,12,StartDate) as date) <cast(EndDate as Date) then 'Grace period of 12 weeks will expire before Sign Off '+convert(nchar(10),dateadd(WEEK,12,EndDate),103) else '' end,
	   Note= case when note like '%waiver%' then Note else 'Grace period of 12 weeks will expire before Sign Off '+convert(nchar(10),EndDate,103) /*convert(nchar(10),dateadd(WEEK,12,StartDate),103) */end,
	   GracePeriodLastDate=cast(dateadd(WEEK,12,StartDate) as date),
	 --  TMC_ShortCode= case when TMC_ShortCode='PRE (SO)' then 'PRE(SO)+12W' else TMC_ShortCode end,
	  --TMC_Description=case when TMC_ShortCode='PRE (SO)' then TMC_Description +'. Within 12 weeks.' else TMC_Description end,
	   Doc_NonCopliant= 0,
	  Documentcompliance='Compliant'
 WHERE TMT_ID= 'VGRP00000073'
   and DOC_ID='VSHP00000119'
   and cast(dateadd(WEEK,12,StartDate) as date)>cast(getdate() as date)
   and (SignOn_Status = 'Non-Compliant' or SignOff_Status = 'Non-Compliant' or note like '%waiver%')
 

   ------------------------------------------------------ ANTI-CORRUPTION FOR SEAFARERS and others
   
   UPDATE #Part
	 SET SignOn_Status = case when SignOn_Status = 'Non-Compliant' then 'Warning' else SignOn_Status end,
		  SignOn_Note = case when SignOn_Status = 'Non-Compliant' then 'Eff. 10/01/2022 - auto update' else SignOn_Note end,
		  SignOff_Status = case when SignOff_Status = 'Non-Compliant' then 'Warning' else SignOff_Status end,
		  SignOff_Note = case when SignOff_Status = 'Non-Compliant' then 'Eff. 10/01/2022 - auto update' else SignOff_Note end,
		  Note= case when Note like '%Waiver%' then  'By Waiver' + '. Eff. 10/01/2022' else '. Eff. 10/01/2022 - auto update' end,
		  Doc_NonCopliant=0,
		  Documentcompliance='Compliant'
	 WHERE  TMT_ID in ('VGRP00000073','GLAS00000124','GLAS00000134','GLAS00000192')
		and DOC_ID in ('GLAS00000222','GLAS00000172','MANI00000053','GLAS00000360')
		--and (SignOff_Note not like 'Missing%' or SignOn_Note not like 'Missing%')
		and Note not like 'Missing%' 
	    and (SignOn_Status = 'Non-Compliant' or SignOff_Status='Non-Compliant' or note like '%Waiver%')
	    and StartDate<'2022-01-10'
	   

	   ---***Cadets***---
	      UPDATE #Part
	 SET SignOn_Status = case when SignOn_Status = 'Non-Compliant' then 'Warning' else SignOn_Status end,
		  SignOn_Note = case when SignOn_Status = 'Non-Compliant' then 'Eff. 10/01/2022 - auto update' else SignOn_Note end,
		  SignOff_Status = case when SignOff_Status = 'Non-Compliant' then 'Warning' else SignOff_Status end,
		  SignOff_Note = case when SignOff_Status = 'Non-Compliant' then 'Eff. 10/01/2022 - auto update' else SignOff_Note end,
		  Note= case when Note like '%Waiver%' then  'By Waiver' + '. Eff. 10/01/2022' else '. Eff. 10/01/2022 - auto update' end,
		  Doc_NonCopliant=0,
		  Documentcompliance='Compliant'
	 WHERE TMT_ID in ('VGRP00000073','GLAS00000124','GLAS00000134')
			and DOC_ID in ('MANI00000053') 
		    and RNK_ID in ('VSHP00000018') 
		    and (SignOn_Status = 'Non-Compliant' or SignOff_Status='Non-Compliant' or note like '%Waiver%')
		    and StartDate<'2022-01-10'
	   
   
   -----------------Update Dummy columns so documents will be reported as Grace Period
   UPDATE #Part
   SET
	  TMC_Description1=case when TMC_ShortCode1='PRE (SO)' then TMC_Description1 +' Within 12W' else TMC_Description1 end,
	  TMC_ShortCode1= case when TMC_ShortCode1='PRE (SO)' then 'PRE(SO)+12W' else TMC_ShortCode1 end
	 -- ,Note=Case when SignOn_Status = 'Non-Compliant' or SignOff_Status= 'Non-Compliant' then Note + '. Grace period of 12W.' else Note end
 WHERE TMT_ID='VGRP00000073'
   and DOC_ID='VSHP00000119'
   

   -----------Medical Fitness Cert-------
      update #Part
   set SignOff_Status = case when dateadd(M,3,CRD_Expiry)>EndDate then 'Warning' 
                             when DATEADD(M,3,CRD_Expiry)>=GETDATE() then 'Warning'
                        else SignOff_Status end,
       SignOff_Note = case when dateadd(M,3,CRD_Expiry)>EndDate then 'Grace period until '+convert(varchar,dateadd(M,3,CRD_Expiry),103)+' to renew certificate.' 
                           when DATEADD(M,3,CRD_Expiry)>=GETDATE() then 'Grace period until '+convert(varchar,dateadd(M,3,CRD_Expiry),103)+' to renew certificate.' 
                      else 'Grace period to renew certificate has passed on '+convert(varchar,dateadd(M,3,CRD_Expiry),103) end,
					  Note= case when dateadd(M,3,CRD_Expiry)>EndDate then 'Grace period until '+convert(varchar,dateadd(M,3,CRD_Expiry),103)+' to renew certificate.' 
                           when DATEADD(M,3,CRD_Expiry)>=GETDATE() then 'Grace period until '+convert(varchar,dateadd(M,3,CRD_Expiry),103)+' to renew certificate.' 
                      else 'Grace period to renew certificate has passed on '+convert(varchar,dateadd(M,3,CRD_Expiry),103) end,
		Doc_NonCopliant=case when dateadd(M,3,CRD_Expiry)>EndDate then 0 
                             when DATEADD(M,3,CRD_Expiry)>=GETDATE() then 0
                        else 1 end,
		Documentcompliance=case when dateadd(M,3,CRD_Expiry)>EndDate then 'Compliant'
                             when DATEADD(M,3,CRD_Expiry)>=GETDATE() then 'Compliant'
                        else 'Non-Compliant' end
 where DOC_ID='VSHP00000016'
   and TMT_ID='GLAS00000054'
   and (SignOn_Status<>'Non-Compliant' and SignOff_Status='Non-Compliant')
   
   --select * from #part where pcn='4111GLS08873' and doc_desc like 'Senior%'
   ---------------------COURSES excluded before/ seafarers signed on before effective date----
	UPDATE #Part
	 SET SignOn_Status = case when SignOn_Status = 'Non-Compliant' then 'Compliant' else SignOn_Status end,
		 -- SignOn_Note = case when SignOn_Status = 'Non-Compliant' then 'Eff. 01/07/2021 - auto update' else SignOn_Note end,
		  SignOff_Status = case when SignOff_Status = 'Non-Compliant' then 'Compliant' else SignOff_Status end,
		  --SignOff_Note = case when SignOff_Status = 'Non-Compliant' then 'Eff. 01/07/2021 - auto update' else SignOff_Note end,
		 -- Note= case when Note like '%Waiver%' then  Note + '. Eff. 01/07/2021' else '. Eff. 01/07/2021 - auto update' end,
		  Doc_NonCopliant=0,
		  Documentcompliance='Compliant'
	 WHERE Training='Old Training' and
	 cast(StartDate as date)<tdi_effectivestartdate
     ------------------------------------------------------------------------------------------------------************************************************************************-------------------------------------------------------------------------------------
   --Check Anti Corruption for seafarers is not PRE SO
   --select distinct note from #Part where Documentcompliance='Non-Compliant' and crew_status='onboard' order by 1
  --  select * from #Part where Documentcompliance='Non-Compliant' and crew_status='onboard' and note='Grace period of 12 weeks from Sign On allowed'order by 1
   	UPDATE #Part
   SET SignOn_Status = case when note like '%waiver%' then SignOn_Status else 'Warning' end,
     --  SignOn_Note = case when note like '%waiver%' then 'By Waiver. (Grace Period allowed)' else 'Grace period of 12 weeks from Sign On allowed - auto update' end,
       SignOff_Status = case when note like '%waiver%' then Signoff_status /*when cast(dateadd(WEEK,12,StartDate) as date)<cast(EndDate as Date)  then 'Warning' else 'Compliant'*/ else 'Warning' end,
       SignOff_Note = case when note like '%waiver%'then '' else SignOff_Note  end,
	   Note= case when note like '%waiver%' then Note else 'Pre(SO)'+ Note /*convert(nchar(10),dateadd(WEEK,12,StartDate),103) */end,
	 --  GracePeriodLastDate=cast(dateadd(WEEK,12,StartDate) as date),
	 --  TMC_ShortCode= case when TMC_ShortCode='PRE (SO)' then 'PRE(SO)+12W' else TMC_ShortCode end,
	  --TMC_Description=case when TMC_ShortCode='PRE (SO)' then TMC_Description +'. Within 12 weeks.' else TMC_Description end,
	   Doc_NonCopliant= 0,
	  Documentcompliance='Compliant'
where  (TMT_ID IN(
'GLAS00000124',
'VGRP00000073',
'GLAS00000106',
'GLAS00000197',
'GLAS00000219',
'GLAS00000085',
'GLAS00000222',
'GLAS00000128',
'GLAS00000189',
'GLAS00000190',
'GLAS00000193',
'GLAS00000243',
'GLAS00000244',
'GLAS00000160',
'GLAS00000161',
'VGRP00000071',
'VGRP00000072',
'GLAS00000082',
'GLAS00000195',
'GLAS00000216'
,'GLAS00000131',
'GLAS00000194',
'GLAS00000135',
'GLAS00000136') or TMT_Name like '%ECDIS%')
AND RequirementType in ('VMS','Other')
 --  and DOC_ID in ('GLAT00000028','GLAS00000222')--Anti-Corruption for seafarers , Accident & Incident Investigatio
 --  AND ( TMC_Description like '%Within%'  or TMC_Description like '%Mandatory Pre-joining%months%')
   AND ( Note like '%Validity Period of%months expire%before Sign Off%'
   or Note like 'Document%expire%whilst on board%' or Note like 'Document%expire%before Sign Off%')
   and Documentcompliance='Non-Compliant'

   --and cast(dateadd(WEEK,12,StartDate) as date)>cast(getdate() as date)
 --  and (SignOn_Status = 'Non-Compliant' or SignOff_Status = 'Non-Compliant' or note like '%waiver%')

 -- for Culture Mngmt and Competency Mgmt adn MTI Media Course
UPDATE #Part
   SET  SignOn_Status = case when note like '%waiver%' then SignOn_Status else 'Warning' end,
       SignOn_Note = 'Grace period of 12 weeks from Sign On allowed - auto update',
       SignOff_Status = case when cast(dateadd(WEEK,12,'2022-09-15') as date) < cast(EndDate as Date) then 'N' else 'C' end,
       SignOff_Note = case when cast(dateadd(WEEK,12,'2022-09-15') as date) < cast(EndDate as Date) then 'Grace period of 12 weeks will expire before Sign Off '+convert(nchar(10),dateadd(WEEK,12,StartDate),103) else 'Compliant' end,
	   Note= case when cast(dateadd(WEEK,12,'2022-09-15') as date) < cast(EndDate as Date) then 'Grace period of 12 weeks will expire before Sign Off '+convert(nchar(10),dateadd(WEEK,12,StartDate),103) else 'Compliant' end,
	   Doc_NonCopliant= 0 ,
	   Documentcompliance=  'Compliant' 
 WHERE TMT_ID='VGRP00000073'
   and DOC_ID in ('VGRP00000575','VGR400000682','VGR400000748')
   and SignOn_Note like '%grace period% has passed%'
   --and cast(EndDate as Date) > '2022-09-15'
   and cast(StartDate as Date) <= '2022-09-15'
   and cast(getdate() as date)<cast(dateadd(WEEK,12,'2022-09-15') as date);

   
-- for VOC
UPDATE #Part
   SET SignOn_Status = case when note like '%waiver%' then SignOn_Status else 'Warning' end,
       SignOn_Note = 'Grace period of 1 month from Sign On allowed - auto update',
       SignOff_Status = case when cast(dateadd(M,1,'2022-09-15') as date) < cast(EndDate as Date) then 'N' else 'C' end,
       SignOff_Note = case when cast(dateadd(M,1,'2022-09-15') as date) < cast(EndDate as Date) then 'Grace period of 1 month will expire before Sign Off '+convert(nchar(10),dateadd(WEEK,12,StartDate),103) else 'Compliant' end,
	   Note= case when cast(dateadd(M,1,'2022-09-15') as date) < cast(EndDate as Date) then 'Grace period of 1 month will expire before Sign Off '+convert(nchar(10),dateadd(WEEK,12,StartDate),103) else 'Compliant' end,
	   Doc_NonCopliant= 0 ,
	   Documentcompliance=  'Compliant' 
 WHERE TMT_ID='GLAS00000194'
   and DOC_ID in ('GLAS00000210')
   and SignOn_Note like '%grace period% has passed%'
 --  and cast(EndDate as Date) > '2022-09-15'
   and cast(StartDate as Date) <= '2022-09-15'
   and rnk_id in ('VSHP00000079','VSHP00000077','VSHP00000072','VSHP00000068','VSHP00000002','VSHP00000012','VSHP00000014')
   and cast(getdate() as date)<cast(dateadd(M,1,'2022-09-15') as date);

   
-- for Port State Control and Toolbox Talks
UPDATE #Part
   SET SignOn_Status = case when note like '%waiver%' then SignOn_Status else 'Warning' end,
       SignOn_Note = 'Grace period of 8 weeks from Sign On allowed - auto update',
       SignOff_Status = case when cast(dateadd(WEEK,8,'2022-09-15') as date) < cast(EndDate as Date) then 'N' else 'C' end,
       SignOff_Note = case when cast(dateadd(WEEK,8,'2022-09-15') as date) < cast(EndDate as Date) then 'Grace period of 8 weeks will expire before Sign Off '+convert(nchar(10),dateadd(WEEK,12,StartDate),103) else 'Compliant' end,
	     Note= case when cast(dateadd(WEEK,8,'2022-09-15') as date) < cast(EndDate as Date) then 'Grace period of 8 weeks will expire before Sign Off '+convert(nchar(10),dateadd(WEEK,12,StartDate),103) else 'Compliant' end,
	   Doc_NonCopliant= 0 ,
	   Documentcompliance=  'Compliant' 
 WHERE TMT_ID='VGRP00000073'
   and DOC_ID in ('GLAT00000014','VGR400000724')
   and SignOn_Note like '%grace period% has passed%'
 --  and cast(EndDate as Date) > '2022-09-15'
   and cast(StartDate as Date) <= '2022-09-15'
   and cast(getdate() as date)<cast(dateadd(M,2,'2022-09-15') as date);


   
-- for Oily Water
UPDATE #Part
   SET  SignOn_Status = case when note like '%waiver%' then SignOn_Status else 'Warning' end,
       SignOn_Note = 'Grace period of 1 month from Sign On allowed - auto update',
       SignOff_Status = case when cast(dateadd(M,1,'2022-09-15') as date) < cast(EndDate as Date) then 'N' else 'C' end,
       SignOff_Note = case when cast(dateadd(M,1,'2022-09-15') as date) < cast(EndDate as Date) then 'Grace period of 1 month will expire before Sign Off '+convert(nchar(10),dateadd(WEEK,12,StartDate),103) else 'Compliant' end,
	    Note= case when cast(dateadd(M,1,'2022-09-15') as date) < cast(EndDate as Date) then 'Grace period of 1 month will expire before Sign Off '+convert(nchar(10),dateadd(WEEK,12,StartDate),103) else 'Compliant' end,
	   Doc_NonCopliant= 0 ,
	   Documentcompliance=  'Compliant' 
 WHERE TMT_ID='VGRP00000073'
   and DOC_ID in ('GLAT00000048')
   and SignOn_Note like '%grace period% has passed%'
 --  and cast(EndDate as Date) > '2022-09-15'
   and cast(StartDate as Date) <= '2022-09-15'
   and rnk_id in ('VSHP00000002')
   and cast(getdate() as date)<cast(dateadd(M,1,'2022-09-15') as date);
   
   
    UPDATE #Part
	 SET 
		 Note= Note + '. Document Expires in less than 30 day after planned Sign Off Date'
	 WHERE DATEDIFF(day, CRD_Expiry, EndDate)<30 and Note='Compliant'


	 ----MEdical Care for Filipino 2nd Off

	  UPDATE #Part
	  SET

	   SignOn_Status = case when SignOn_Status = 'Compliant'then 'Compliant' else  'Warning' end,
       SignOn_Note = case when SignOn_Status = 'Compliant'then 'Compliant' else  'Missing Recommended document' end,
       SignOff_Status = case when SignOff_Note = 'Compliant'then 'Compliant' else  'Warning' end,
       SignOff_Note =  case when SignOff_Note = 'Compliant'then 'Compliant' else  'Missing Recommended document' end,
	   Note = case when Note = 'Compliant'then 'Compliant' else  'Missing Recommended document' end,
	   Doc_NonCopliant= 0 ,
	   Documentcompliance=  'Compliant' ,
	   TMC_ShortCode='REC'

 WHERE  DOC_ID='VSHP00000024'
 AND RNK_ID='VSHP00000012'
  AND CrewNationality='Filipino'
 -- AND TMC_ShortCode='PRE(NE)'
 -- and (SignOn_Status = 'Non-Compliant' or SignOff_Status='Non-Compliant')
  and tmt_id in ('GLAS00000124','VGRP00000073')

    ------------------------------------------------------------------------------------------------------************************************************************************-------------------------------------------------------------------------------------

   
    -------------------------------------------------------------------------------------------------------NRS UPDATE TEMP-----------------------------------------------------------------------------------------------------------------------------------------
	 UPDATE #Part
	 SET SignOn_Status =  'Compliant' ,
		  SignOff_Status = 'Compliant',
		 CPIReport='Incl-NRS',
		  Doc_NonCopliant=0,
		  Documentcompliance='Compliant'
	 WHERE remark like 'STATUTORY documents are not reported%' and CPIReport='Excluded' and RequirementType='Statutory'
	 
	   ---------------------------EXEMPTIONS END---------------------
	   
   ---------------------------------------------------------------------
Select distinct 
	p.*--c.Crew_Compliance, c.NonCompliantCrew,
	,IsCoreTemplate= case when 	 TMT_Core=1 then 'YES' else'NO' end 
	, SignOn14D= case when datediff(day,startdate,getdate()) >14 then 'No' else 'Yes' end 
	, RUNDay= GETUTCDATE() 
-----------------CASUAL ELEMENTS--------------------------------

	,DocumentMissing =case  when (note like '%Missing Mandatory document with no grace period%' or note like '%Missing Flag Specific document%'  or note like '%No document marked as Primary%' or  note like '%Grace period%from Sign On%')  and Documentcompliance='Non-Compliant' then 1 else 0 end
	,DocumentexpiredatSignOff = case  when (note like '%Document%expires%before Sign Off%' or note like '%Validity Period%expires before Sign Off%' /*or note like '%Document expired%whilst on board%' */or note like '%Document expires%before Sign Off%')  and Documentcompliance='Non-Compliant' then 1 else 0 end
	,DocumentExpired= case when (note like '%Validity Period%expires before Sign On%' or note like '%Document%expired%before Sign On%' or note like '%Expiry date missing for document%' or note like '%Document%expired%whilst on board%'or note like 'Grace period to renew certificate has passed on%' ) and Documentcompliance='Non-Compliant' 	then 1 else 0 end
	,GracePeriodAllowance= case when TMC_Description1 like '%Within%' then 'YES' else 'NO' end
	,DpocumentStatus=case when (note like '%Missing Mandatory document with no grace period%' or note like '%Missing Flag Specific document%'  or note like '%No document marked as Primary' or  note like '%Grace period%from Sign On%')  and Documentcompliance='Non-Compliant' then 'Missing'
						  when (note like '%Document%expires%before Sign Off%' or note like '%Validity Period%expires before Sign Off%'/* or note like '%Document expired%whilst on board%' */or note like '%Document expires%before Sign Off%')  and Documentcompliance='Non-Compliant' then  'Expired at SignOff'
						  when (note like '%Validity Period%expires before Sign On%' or note like '%Document%expired%before Sign On%' or note like '%Expiry date missing for document%' or note like '%Document%expired%whilst on board%' or note like 'Grace period to renew certificate has passed on%' ) and Documentcompliance='Non-Compliant'  then  'Expired' 
						else 'OK' end 
	,BPMDocumentStatus= case when TMC_ShortCode='REC' then NULL
	
	when (note like '%Document%expired%before Sign On%' or note like '%Validity Period%expires before Sign On%') then 'Expired before Sign-On' 
							 when (note like '%Document%expired%whilst on board%' or note like 'Grace period to renew certificate has passed on%')  then 'Expired while On Board'
							 when (note like '%Document%expires%before Sign Off%' or note like '%Validity Period%expires before Sign Off%')   then 'Expires before Sign-Off'
							 when (note like '%Expiry date missing for document%')   then 'Missing expiry date' 
							 when (note like  '%Grace period of%from Sign On has passed%'  or note like '%Missing Flag Specific document%' or note like '%Missing Mandatory document with no grace period%'or note like '%No document marked as Primary%' /*or note like '%Eff. 01/07/2021 - auto update%'*/ or
									( note like '%waiver%' and note not like '%. Eff.%' and SignOn_Note not like '%By Waiver. (Grace Period allowed)%') )  then 'Missing mandatory document' end 	
	
	,ExpiryStatus=case when (note like '%Missing Mandatory document with no grace period%' or note like '%Missing Flag Specific document%'  or note like '%No document marked as Primary' or  note like '%Grace period%from Sign On%')  and Documentcompliance='Non-Compliant' then 'Missing'
						  when (note like '%Document%expires%before Sign Off%' or note like '%Validity Period%expires before Sign Off%'/* or note like '%Document expired%whilst on board%' */or note like '%Document expires%before Sign Off%' or note like 'Grace period until%to renew certificate.') /* and Documentcompliance='Non-Compliant' */then  'Expiring'
						  when (note like '%Validity Period%expires before Sign On%' or note like '%Document%expired%before Sign On%' or note like '%Expiry date missing for document%' or note like '%Document%expired%whilst on board%' or note like 'Grace period to renew certificate has passed on%' ) and Documentcompliance='Non-Compliant'  then  'Expired' 
						else 'OK' end 
	,DaysToExpire=case when (note like '%Missing Mandatory document with no grace period%' or note like '%Missing Flag Specific document%'  or note like '%No document marked as Primary' or  note like '%Grace period%from Sign On%')  and Documentcompliance='Non-Compliant' then 'Missing'
						  when (note like '%Document%expires%before Sign Off%' or note like '%Validity Period%expires before Sign Off%'/* or note like '%Document expired%whilst on board%' */or note like '%Document expires%before Sign Off%' or note like 'Grace period until%to renew certificate.') and DATEDIFF(day,GETDATE(),crd_expiry)<31 /* and Documentcompliance='Non-Compliant' */then  'Expiring in 30 Days'
						 when (note like '%Document%expires%before Sign Off%' or note like '%Validity Period%expires before Sign Off%'/* or note like '%Document expired%whilst on board%' */or note like '%Document expires%before Sign Off%' or note like 'Grace period until%to renew certificate.') and DATEDIFF(day,GETDATE(),crd_expiry)>=31 /* and Documentcompliance='Non-Compliant' */then  'Expiring >30 Days'
						 when (note like '%Validity Period%expires before Sign On%' or note like '%Document%expired%before Sign On%' or note like '%Expiry date missing for document%' or note like '%Document%expired%whilst on board%' or note like 'Grace period to renew certificate has passed on%' ) and Documentcompliance='Non-Compliant'  then  'Expired' 
						else 'OK' end 
					-----------------CASUAL ELEMENTS-------------------------------- END
					------------------ DISPENSAIONS +CASUALS ------------------

	,DocumentMissingWithoutDispensation= case  when ((note like '%Missing Mandatory document with no grace period%' or note like '%Missing Flag Specific document%'  or note like '%No document marked as Primary%' or  note like '%Grace period%from Sign On%')  
			and Documentcompliance='Non-Compliant') or  ( note like '%waiver%' and note not like '%. Eff.%' and SignOn_Note not like '%By Waiver. (Grace Period allowed)%') then 1 else 0 end

	,DocumentexpiredatSignOffWithoutDispensation= case  when (note like '%Document%expires%before Sign Off%' or note like '%Validity Period%expires before Sign Off%' /*or note like '%Document expired%whilst on board%' */or note like '%Document expires%before Sign Off%')  and Documentcompliance='Non-Compliant' and note not like  '%waiver%' then 1 else 0 end
	,DocumentExpiredWithoutDispensation =case when (note like '%Validity Period%expires before Sign On%' or note like '%Document%expired%before Sign On%' or note like '%Expiry date missing for document%' or note like '%Document%expired%whilst on board%'or note like 'Grace period to renew certificate has passed on%' ) and Documentcompliance='Non-Compliant' and note not like  '%waiver%' then 1 else 0 end
	,Dispensationstatus= case when CRD_Expiry<getdate() and note like '%waiver%' then 'Expired'		
							  when CRD_Expiry<(getdate()+30) and CRD_Expiry>=getdate()  and note like '%waiver%' then 'DueToExpire'  
							  when (CRD_Expiry>=(getdate()+30) or CRD_Expiry is null) and note like '%waiver%' then 'Active' end 

	
	,Dispensation= case when note like '%waiver%' then 'YES' else 'NO' end
	,DocNonCompIgnoringDispensation= Case when ( note like '%waiver%' and note not like '%. Eff.%' and SignOn_Note not like '%By Waiver. (Grace Period allowed)%') then 1 else Doc_NonCopliant end
	,DocComplianceIgnoringDispensation= Case when ( note like '%waiver%' and note not like '%. Eff.%' and SignOn_Note not like '%By Waiver. (Grace Period allowed)%')  then 'Non-Compliant' else Documentcompliance end
	

						------------------ DISPENSAIONS +CASUALS ------------------ END	
	 
						--------------------------- GRACE PERIOD -----------
	
	,NonCompliantGrace= case when TMC_Description1 like '%Within%' and( note like '%Grace period of%from Sign On has passed%' and note not like '%Eff.%Grace period of%from Sign On has passed%'/*or   note like '%auto update%'*/) then 1
							when  TMC_Description1 like '%Within%' and  SignOff_Status='Warning' and note not like '%Eff.%'  or (SignOn_Note like '%Validity Period%expire%before Sign On%' and Doc_NonCopliant=0)then 2
							else Doc_NonCopliant end 
	,GracePeriodExists = case when TMC_Description1 like '%Within%' and (( note like '%Waiver%' and Doc_NonCopliant=0)or note  like '%Eff.%'or note like '%Compliant%' or note like '%Equivalent%'or note like '%Covered%'or  note like 'Pre(SO) Document expire%whilst on board%'
									or note like 'Pre(SO) Document expires%before Sign%'or note like 'Seafarer rank excluded from compliance' ) then 1 else 0 end 
	,GracePeriodMissing = case when TMC_Description1 like '%Within%' and ( (note like '%Grace period of%from Sign On has passed%' and note not like '%Eff.%Grace period of%from Sign On has passed%')or note like'%Missing Mandatory document with no grace period%' or note like '%Document%expired%before Sign On%'/*or note like '%auto update%'*/) then 1 else 0 end
	,GracePeriodWithinGracePeriod= case when TMC_Description1 like '%Within%' and (note like '%Grace period of%from Sign On allowed%' or note like '%Grace period of%will expire before Sign Off%')  then 1 else 0 end
	,GracePeriodExpiredatSignOff = case when TMC_Description1 like '%Within%' and (note like '%Validity Period of%expires before Sign Off%'or note like '%Document%expired%whilst on board%' or note like '%Document expires%before Sign Off%')  and (Documentcompliance ='Non-Compliant' or SignOff_Status= 'Warning') then 1 else 0 end
	,GracePeriodDocumentStatus= case when TMC_Description1 like '%Within%' and ( note like 'Seafarer rank excluded from compliance' or( note like '%Waiver%' and Doc_NonCopliant=0)or  note  like '%Eff.%'or note like '%Compliant%' or note like '%Equivalent%' or note like '%Covered%'  or  note like 'Pre(SO) Document expire%whilst on board%' 	or note like 'Pre(SO) Document expires%before Sign%') then 'Exists'
									 when TMC_Description1 like '%Within%' and (note like '%Grace period of%from Sign On has passed%' or note like'%Missing Mandatory document with no grace period%' or note like '%Document%expired%before Sign On%'/*or note like '%auto update%'*/) then 'Missing'
									 when TMC_Description1 like '%Within%' and (note like '%Grace period of%from Sign On allowed%' or note like '%Grace period of%will expire before Sign Off%') then 'Within Grace Period'
									 when TMC_Description1 like '%Within%' and (note like '%Validity Period of%expires before Sign Off%'or note like '%Document%expired%whilst on board%' or note like '%Document expires%before Sign Off%')  and (Documentcompliance ='Non-Compliant' or SignOff_Status= 'Warning') then 'Expired at Sign Off' end 
	,GraceincludeDispensationCompliance= case  when  TMC_Description1 like '%Within%' and (note like '%Grace period of%from Sign On has passed%'  and note not like '%Eff.%Grace period of%from Sign On has passed%' /* or note like '%auto update%'*/) then 'Non-Compliant' 
											   when  TMC_Description1 like '%Within%' and SignOff_Status='Warning' and note not like '%Eff.%' or (SignOn_Note like '%Validity Period%expire%before Sign On%' and Doc_NonCopliant=0) then 'Warning' else Documentcompliance end

--------------------------- GRACE PERIOD ----------- END
--------------------------- GRACE PERIOD + DISPENSATIONS----------- 
	
	,GraceDispensationCompliance = case when  ( note like '%waiver%' and note not like '%. Eff.%' and SignOn_Note not like '%By Waiver. (Grace Period allowed)%') /* or   note like '%auto update%' */then 'Non-Compliant' 
										when  TMC_Description1 like '%Within%' and note like '%Grace period of%from Sign On has passed%' and note not like '%Eff.%Grace period of%from Sign On has passed%' then 'Non-Compliant' 
										when  (TMC_Description1 like '%Within%' and SignOff_Status='Warning' and note not like '%Eff.%') or (SignOn_Note like '%Validity Period%expire%before Sign On%' and Doc_NonCopliant=0)/*) or   note like '%auto update%'*/ then 'Warning' else Documentcompliance end
	,NonCompliantGraceDisp= case when ( note like '%waiver%' and note not like '%. Eff.%' and SignOn_Note not like '%By Waiver. (Grace Period allowed)%')  /* or   note like '%auto update%' */ then 1 
								 when  TMC_Description1 like '%Within%' and note like '%Grace period of%from Sign On has passed%' and note not like '%Eff.%Grace period of%from Sign On has passed%' then 1
								 when  (TMC_Description1 like '%Within%' and SignOff_Status='Warning'and note not like '%Eff.%') or (SignOn_Note like '%Validity Period%expire%before Sign On%' and Doc_NonCopliant=0)/*) or   note like '%auto update%'*/ then 2 else Doc_NonCopliant end
	,GracePeriodDispensationDocumentStatus= case when TMC_Description1 like '%Within%' and (( (note like '%Compliant%' or note like '%Equivalent%' or note like '%Covered%')and note not like '%waiver%') or ( note not like '%waiver%' and note  like '%Eff.%' and SignOn_Note  not like '%By Waiver. (Grace Period allowed)%')
														or  note like 'Pre(SO) Document%expired%whilst on board%' 	or note like 'Pre(SO) Document expires%before Sign%' or  note like 'Seafarer rank excluded from compliance' ) then 'Exists'
												 when TMC_Description1 like '%Within%' and (( note like '%waiver%' and note not like '%Eff.%' and SignOn_Note not like '%By Waiver. (Grace Period allowed)%') or note like '%Grace period of%from Sign On has passed%' or note like'%Missing Mandatory document with no grace period%' or note like '%Document%expired%before Sign On%'/* or   note like '%auto update%' */) then 'Missing'
												 when TMC_Description1 like '%Within%' and (note like '%Grace period of%from Sign On allowed%' or note like '%Grace period of%will expire before Sign Off%' or   SignOn_Note  like '%By Waiver. (Grace Period allowed)%') then 'Within Grace Period'
												 when TMC_Description1 like '%Within%' and (note like '%Validity Period of%expires before Sign Off%' or note like '%Document%expired%whilst on board%' or note like '%Document expires%before Sign Off%')  and (Documentcompliance ='Non-Compliant' or SignOff_Status= 'Warning') then 'Expired at Sign Off'end
	,GracePeriodDISPExists =case when TMC_Description1 like '%Within%' and ( note not like '%Waiver%' /*or SignOn_Note like '%By Waiver. (Grace Period allowed)%') */ and( note  like '%Eff.%' or note like 'Seafarer rank excluded from compliance' or note like '%Compliant%' or note like '%Equivalent%' or note like '%Covered%' or  note like 'Pre(SO) Document expire%whilst on board%'
										or note like 'Pre(SO) Document expires%before Sign%') )then 1 else 0 end
	,GracePeriodDispMissing= case when TMC_Description1 like '%Within%' and (( note like '%waiver%' and note not like '%Eff.%' and SignOn_Note not like '%By Waiver. (Grace Period allowed)%') or ( note like '%Grace period of%from Sign On has passed%' and note not like '%Eff.%Grace period of%from Sign On has passed%') or note like'%Missing Mandatory document with no grace period%' or note like '%Document%expired%before Sign On%'/* or   note like '%auto update%' */) then 1 else 0 end
	,OTGCodeGrace= case when TMC_Description1 like '%Within%' and (note like '%Grace period of%from Sign On allowed%' or note like '%Grace period of%will expire before Sign Off%')  then GracePeriodWeeks
											when note like '%waiver%' and note not like '%Eff.%' then 'DISP'  End 
	,CourseColourCategory= Case when TMC_Description1 like '%Mandatory%Pre-Joining%' then 'Red' when TMC_Description1 like '%Within%' then 'Orange' else 'Other' end
--------------------------- GRACE PERIOD + DISPENSATIONS----------- END
--into #final
	from #part p
	WHERE  (note not like 'Seafarer rank excluded from compliance' or note is null)
	--and note like 'Grace period to renew certificate has passed on%'
 --join #CREW c on c.crw_id=p.CRW_ID
 --and TMC_Description1 like '%within%'
 --and Doc_NonCopliant=1
--and   note like '%waiver%'
 --and Crew_Status='onboard'
 --and note like 'grace Period%'
-- order by DocumentGeneralName
--and training='new training'
	 order by Rank_SN1
	--select * from #final where GracePeriodDocumentStatus is null --and effec
	/*
	 select * from #final where Doc_NonCopliant=1 and (DocumentExpired=1 ) and GracePeriodAllowance='yes' and
 Crew_Status='onboard'
	
*/
drop table #part
drop table #tmpVes
