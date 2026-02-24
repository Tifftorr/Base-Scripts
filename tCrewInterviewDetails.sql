SELECT
	cri.cri_id as [Interview ID],
	cri.CRW_ID as [Crew ID],
	cri.CRI_Interviewer as [Interviewer],
	cri.[CRI_InterviewDate] as [Interview Date],
	atf.AttributeName as [Interview Outcome],
	cri.CRI_ReasonsForDecision as [Reasons for Decision],
	cri.CRI_Remarks as [Remarks],
	cri.CRI_CreatedOn as  [Interview Created On],
	cri.CRI_CreatedBy as [Interview Created By ID],
	usr.USR_DisplayName as [Interview Created By],
	cri.CRI_UpdatedOn as [Interview Updated On],
	cri.CRI_UpdatedBy as [Interview Updated By ID],
	usr2.USR_DisplayName as [Interview Updated By],
	cri.[CRI_VesselName] as [Vessel Name],
	cri.[RNK_ID] as [Interview for Rank ID],
	cri.CRI_InterviewerPosition as [Interviewer Position],
	atf2.AttributeName as [Interview Type],
	atf3.AttributeName as [Interview Rejection Reason]

FROM shipsure..CRW_InterviewDetails cri
left join AttributeDef atf ON atf.BitValue = cri.CRI_InterviewOutcome and atf.tablename = 'CrewInterviewOutcome'
left join AttributeDef atf2 ON atf2.BitValue = cri.CRI_CandidateType and atf2.TableName = 'CrewInterviewCandidateType'
left join AttributeDef atf3 ON atf3.BitValue = CRI_CandidateRejectReason and atf3.TableName = 'CrewInterviewRejectReason'
left join shipsure..USERID usr ON usr.usr_id = cri.CRI_CreatedBy
left join shipsure..USERID usr2 ON usr2.usr_id = cri.CRI_UpdatedBy
WHERE cri.CRI_Cancelled = 0