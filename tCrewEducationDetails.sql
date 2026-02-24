SELECT
	CED_ID as [Crew Education ID],
	crw_id as [Crew ID],
	CED_Level as [Crew Education Level],
	CASE WHEN CED_PartnerInstituteId is not NULL THEN att.Attributedesc else CED_Name END AS [Institute Name],
	CED_City as [City of College],
	CNT_ID as [Country of College],
	CED_GraduationDate as [Graduation Date],
	CED_StartDate as [Start Date],
	CED_Specialty as [Education Specialty],
	CED_GraduationScore as [Graduation Score],
	CED_PartnerInstituteId as [Partner Institute ID]

FROM
	shipsure.[dbo].[CRWPersonalEducationDetails] ced
	LEFT JOIN shipsure..attributedef att ON att.[AttributeName] = ced.CED_PartnerInstituteId and att.tablename ='PartnerInstitute'
WHERE
	CED_Cancelled = 0