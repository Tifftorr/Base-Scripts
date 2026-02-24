--tCrewMobilisationChecklist
SELECT top 1000
	mch.MCH_ID as [Checklist ID],
	mch.CRW_ID as [Crew ID],
	mch.SET_ID as [Service Record ID],
	mch.mch_status as [Checklist Status ID],
	att.attributedesc as [Checklist Status],
	mch.mch_createdby as [Checklist Created By ID],
	usr.USR_DisplayName as [Checklist Created By],
	mch.MCH_CreatedOn as [Checklist Created On],
	mch.mch_updatedby as [Checklist Updated By ID],
	usr2.USR_DisplayName as [Checklist Updated By],
	mch.mch_UpdatedOn as [Checklist Updated On],
	mch.mch_signedby as [Checklist Signed By ID],
	usr3.USR_DisplayName as [Checklist Signed By],
	mch.mch_signedon as [Checklist Signed On],
	mch.mch_completedby as [Checklist Completed By ID],
	usr4.USR_DisplayName as [Checklist Completed By],
	mch.mch_rejectreason as [Checklist Rejection Reason],
	BINARY_CHECKSUM(
		mch.MCH_ID,
		mch.CRW_ID,
		mch.SET_ID,
		mch.mch_status,
		att.attributedesc,
		mch.mch_createdby,
		usr.USR_DisplayName,
		mch.MCH_CreatedOn,
		mch.mch_updatedby,
		usr2.USR_DisplayName,
		mch.mch_UpdatedOn,
		mch.mch_signedby,
		usr3.USR_DisplayName,
		mch.mch_signedon,
		mch.mch_completedby,
		usr4.USR_DisplayName,
		mch.mch_rejectreason
		) [ChangeIdentifier]

FROM shipsure..CRWMobilisationCheckListHeader MCH
LEFT JOIN shipsure..attributedef ATT on ATT.AttributeName = mch.mch_status and tablename = 'CRWMOCheckListStatus'
LEFT JOIN shipsure..USERID (NOLOCK) USR ON USR.USR_ID = MCH.mch_createdby
LEFT JOIN shipsure..USERID (NOLOCK) USR2 ON USR2.USR_ID = MCH.mch_updatedby
LEFT JOIN shipsure..USERID (NOLOCK) USR3 ON USR3.USR_ID = MCH.mch_signedby
LEFT JOIN shipsure..USERID (NOLOCK) USR4 ON USR4.USR_ID = MCH.mch_completedby
WHERE
	MCH.MCH_Cancelled = 0