SELECT
	aa.[CAI_ID] as [Appraisal Item ID],
	aa.CAH_ID as [Appraisal ID],
	aa.AID_ID as [Appraisal Item Detail ID],
	aa.CAI_Comments as [Appraisal Item Comments],
	aa.CAI_CreatedBy as [Appraisal Item Created By ID],
	uu.USR_DisplayName as [Appraisal Item Created By],
	aa.CAI_CreatedOn as [Appraisal Item Created On],
	aa.CAI_UpdatedBy as [Appraisal Item Updated By ID],
	uu2.USR_DisplayName as [Appraisal Item Updated By],
	aa.cai_updatedon as [Appraisal Item Updated On],
	bb.AIH_ID as [Appraisal Item Header ID],
	bb.ASL_ID as [Appraisal Scale ID],
	bb.AID_ScaleDescription as [Appraisal Scale Description],
	bb.AID_IsTrainingRequired as [Appraisal Item Detail Is Training Required],
	cc.AIH_ID_Parent as [Appraisal Item Header Parent ID],
	cc2.AIH_Title as [Appraisal Item Title],
	cc2.AIH_Description as [Appraisal Item Description],
	cc2.AIH_SortOrder as [Appraisal Item Sort Order],
	asl.asl_description as [Appraisal Scale Result],
	asl.asl_value as [Appraisal Scale Value],
	BINARY_CHECKSUM(
		aa.[CAI_ID],
		aa.CAH_ID,
		aa.AID_ID,
		aa.CAI_Comments,
		aa.CAI_CreatedBy,
		uu.USR_DisplayName,
		aa.CAI_CreatedOn,
		aa.CAI_UpdatedBy,
		uu2.USR_DisplayName,
		aa.cai_updatedon,
		bb.AIH_ID,
		bb.ASL_ID,
		bb.AID_ScaleDescription,
		bb.AID_IsTrainingRequired,
		cc.AIH_ID_Parent,
		cc2.AIH_Title,
		cc2.AIH_Description,
		cc2.AIH_SortOrder,
		asl.asl_description,
		asl.asl_value
	) [ChangeIdentifier]


FROM shipsure.[dbo].[CRWOBAppraisalItem] aa (NOLOCK)
left join shipsure.[dbo].[CRWAppraisalItemDetail] bb (NOLOCK) on bb.AID_ID = aa.AID_ID and bb.aid_isdeleted = 0
left join [dbo].[CRWAppraisalItemHeader] cc (NOLOCK) on cc.aih_id = bb.aih_id and cc.AIH_IsDeleted = 0
left join [dbo].[CRWAppraisalItemHeader] cc2 (NOLOCK) on cc2.aih_id = cc.AIH_ID_Parent and cc2.AIH_IsDeleted = 0 -- to get the parent name description
left join shipsure.[dbo].[CRWAppraisalScale] asl (NOLOCK) on ASL.asl_id = bb.ASL_ID and asl_isdeleted = 0
left join userid uu (NOLOCK) on uu.usr_id = aa.CAI_CreatedBy and uu.usr_deleted = 0
left join userid uu2 (NOLOCK) on uu2.usr_id = aa.CAI_UpdatedBy and uu2.usr_deleted = 0
where aa.CAI_Isdeleted = 0