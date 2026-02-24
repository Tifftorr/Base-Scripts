SELECT
	RECINSERTEDON AS [Record Inserted On],
	recruitment_cell_id AS [Recruitment Cell ID],
	RECRUITMENT_CELL AS [Recruitment Cell],
	ENDORSED_CANDIDATES AS [Endorsed Candidates],
	APPROVED_CANDIDATES AS [Approved Candidates],
	NEW_HIRED_OFFICERS_WITH_CRW16 AS [New Hired Officers Compliant with CRW16],
	NEW_HIRED_OFFICERS_YTD AS [New Hired Officers],
	NEWHHIRES_PROCESSED_VIA_RECRUITMENTTRACKING AS [New Hires Processed Via Recruitment Tracking],
	NEWHIRES_ALL AS [New Hired Seafarers],
	URGENT_APPROVED_CANDIDATES_BEFORE_STARTDATE AS [Urgent Approved Candidates Before Start Date],
	URGENT_RECRUITMENT_REQUESTS AS [Urgent Recruitment Requests],
	NON_URGENT_APPROVED_CANDIDATES_BEFORE_STARTDATE AS [Non Urgent Approved Candidates Before Start Date],
	NON_URGENT_RECRUITMENT_REQUESTS AS [Non Urgent Recruitment Request],
	ASSESSMENT_PASSED AS [New Hired Officers Who Passed Assessment],
	ASSESSMENT_DENOM AS [New Hired Officers Who Has Taken The Assessment],
	NEW_HIRED_OFFICERS_WITH_CRW16_W_TPA AS [New Hired Officers Compliant with CRW16 TPA],
	NEW_HIRED_OFFICERS_YTD_W_TPA AS [New Hired Officers TPA],
	APPROVED AS [Approved Seafarers],
	JOINED AS [Joined Seafarers]

FROM Aggregates.[dbo].[CREW_RECRUITMENTSCORECARD]