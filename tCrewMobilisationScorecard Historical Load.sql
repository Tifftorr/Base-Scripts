SELECT
	Mob.RecordInstertedOn AS [Date],
	Mob.MobilisationCell_ID AS [Mobilisation Cell ID],
	CPL.CPL_Description AS [Mobilisation Cell],
	SUM(Mob.CREW_OB_ALL_TN_COMPLETE) AS [Training Needs Completed],
	SUM(Mob.CREW_OB_TN) AS [Total Training Needs],
	SUM(Mob.DIGITAL_CHECKLIST_SIGNEDOFF) AS [Digital Checklist Signed Off],
	SUM(Mob.DIGITAL_CHECKLIST_JOINERS) AS [Digital Checklist Joiners],
	SUM(Mob.DOCUMENTS_UPLOADED_BY_SF) AS [Documents Uploaded by Seafarer],
	SUM(Mob.TOTAL_DOCUMENTS_UPLOADED) AS [Total Documents Uploaded],
	SUM(Mob.CHECKLIST_SIGNEDOFF_BEFORE_EST_READINESS_DATE) AS [Ready Status Updated On Time],
	SUM(Mob.JOINERS_MOBILISATION_RELIABILITY) AS [Mobilisation Reliability Joiners],
	SUM(Mob.PRE_JOINING_STAT_COMP) AS [Pre Joining Compliance Statutory Compliant Crew],
	SUM(Mob.PRE_JOINING_STAT_ONBOARD) AS [Pre Joining Compliance Statutory Onboard Crew],
	SUM(Mob.PRE_JOINING_VMS_COMP) AS [Pre Joining Compliance VMS Compliant Crew],
	SUM(Mob.PRE_JOINING_VMS_ONBOARD) AS [Pre Joining Compliance VMS Onboard Crew],
	SUM(Mob.PRE_JOINING_DECLARATION_SIGNED) AS [Declaration of Compliance Signed Pre Joining],
	SUM(Mob.CREW_ONBOARD_PRE_JOINING_DECLARATION) AS [Crew Onboard Pre Joining Declaration of Compliance],
	SUM(Mob.CREW_ACCEPTED_ON_WN_2_DAYS) AS [Crew Approved To Join Accepted By Mobilisation On Time],
	SUM(Mob.APPROVED_READY_PLANNED_CREW) AS [Crew Approved To Join],
	SUM(Mob.CREW_SIGNEDOFF_DEBFRIEFING_COMPLETED_WN15DAYS) AS [Crew Debriefing Done On Time],
	SUM(Mob.CREW_SIGNEDOFF_DEBRIEFING) AS [Crew Debriefing Offsigners],
	SUM(Mob.OVERDUE_RATINGS_ONBOARD) - SUM(Mob.OVERDUE_RATINGS) AS [Timely Relieved Ratings],
	SUM(Mob.OVERDUE_RATINGS_ONBOARD) AS [Ratings Onboard],
	SUM(Mob.CRW_LAST_APPRAISAL_REVIEWED_W_N_2_DAYS_DISEMBARKATION) AS [Crew With Appraisal Review Completion On Time],
	SUM(Mob.CRW_APPRAISALS_OFFSIGNERS) AS [Crew Appraisal Offsigners]

FROM [Aggregates].[dbo].[CREW_MobilisationScorecard] Mob
LEFT JOIN ShipSure..CRWPOOL CPL (NOLOCK) ON Mob.MobilisationCell_ID = CPL.CPL_ID
WHERE cast(Mob.RecordInstertedOn AS Date) >= '2024-01-01'
AND CPL.CPL_Description is not NULL
Group By 
	Mob.RecordInstertedOn,
	Mob.MobilisationCell_ID,
	CPL.CPL_Description
Order By 1
