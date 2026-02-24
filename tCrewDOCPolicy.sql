SELECT
	CPA.Crw_id AS [Crew ID],
	CPA.SFA_ID AS [Crew Policy Assignment ID],
	CPA.SET_ID AS [Service Record ID],
	BB.sfp_name AS [Policy Name],
	AA.SFI_ID AS [Crew Policy Detail ID],
	CPA.SFA_CreatedBy [Crew Policy Assignment Created By ID],
	USR.USR_DisplayName as [Crew Policy Assignment Created By],
	CPA.SFA_CreatedOn [Crew Policy Assignment Created On],
	AA.SFI_PolicyAgreedOn [Crew Policy Agreed On],
	AA.SFI_PolicyAgreedFromIP [Crew Policy Agreed From IP],
	AA.SFI_PolicyAssignedOn [Crew Policy Assigned On],
	AA.SFI_IsPolicyAgreed [Is Policy Agreed]
	
FROM shipsure..CRWPolicyAssignment CPA
INNER JOIN [dbo].[CRWPolicyDetail]  AA (NOLOCK) ON CPA.SFA_ID = AA.SFA_ID
INNER JOIN CRWPOLICYHEADER BB (NOLOCK) ON BB.SFP_ID = AA.SFP_ID AND BB.SFP_Deleted = 0
INNER JOIN SHIPSURE..[AttributeDef] AD  (NOLOCK) ON AD.AttributeName = AA.SFP_ID  AND TableName = 'PolicyForMobDashboard'
LEFT JOIN SHIPSURE..USERID USR on USR.USR_ID = CPA.SFA_CreatedBy
WHERE (CPA.SFA_IsCancelled is null or CPA.SFA_IsCancelled = 0)