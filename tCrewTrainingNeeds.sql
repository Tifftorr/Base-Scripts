--tCrewTrainingNeeds

SELECT
	CT.TND_ID AS [Training Need ID],
	CT.CRW_ID AS [Crew ID],
	CT.TST_ID AS [Status ID],
	CTS.TST_Desc AS [Status],
	CT.TND_CourseRecommended AS [Course Recommended],
	CT.TND_RaisedBy AS [Training Need Raised By],
	CT.TND_RaisedOn AS [Training Need Raised On],
	CT.TND_SchTrainDAte AS [Training Need Schedule Training Date],
	CT.TND_ActualTrainDate AS [Training Need Actual Training Date],
	CT.CMP_ID AS [Mobilisation Office ID],
	CT.SET_ID AS [Service Record ID],
	CT.TND_CM_USR_ID AS [Crew Manager User ID],
	USR.USR_DisplayName AS [Crew Manager],
	CT.TND_CreatedBy AS [Training Need Created By ID],
	USR2.USR_DisplayName AS [Training Need Created By],
	CT.TND_CreatedOn AS [Training Need Created On],
	CT.TND_UpdatedBy AS [Training Need Updated By ID],
	USR3.USR_DisplayName AS [Training Need Updated By],
	CT.TND_UpdatedOn AS [Training Need Updated On],
	CT.COU_ID AS [Course ID],
	CTT.COU_Desc AS [Course Description],
	CT.Mandatory_Requirement AS [Is Mandatory Requirement],
	CT.TND_Desc [Training Need Name],
	CT.TND_Training_Comments AS [Training Need Comments],
	CT.CAH_ID AS [Appraisal ID],
	CT.TND_IsAddedByVessel AS [Is Added by Vessel],
	BINARY_CHECKSUM(
	CT.TND_ID,
	CT.CRW_ID,
	CT.TST_ID,
	CTS.TST_Desc,
	CT.TND_CourseRecommended,
	CT.TND_RaisedBy,
	CT.TND_RaisedOn,
	CT.TND_SchTrainDAte,
	CT.TND_ActualTrainDate,
	CT.CMP_ID,
	CT.SET_ID,
	CT.TND_CM_USR_ID,
	USR.USR_DisplayName,
	CT.TND_CreatedBy,
	USR2.USR_DisplayName,
	CT.TND_CreatedOn,
	CT.TND_UpdatedBy,
	USR3.USR_DisplayName,
	CT.TND_UpdatedOn,
	CT.COU_ID,
	CTT.COU_Desc,
	CT.Mandatory_Requirement,
	CT.TND_Desc,
	CT.TND_Training_Comments,
	CT.CAH_ID,
	CT.TND_IsAddedByVessel) [ChangeIdentifier]
	
FROM shipsure..crwtrainingneed CT
LEFT JOIN shipsure..crwtrainingstatus CTS ON CTS.TST_ID = CT.TST_ID
left join shipsure..crwcourses ctt on ctt.cou_id = ct.cou_id
LEFT JOIN ShipSure..userid USR ON USR.USR_ID = CT.TND_CM_USR_ID
LEFT JOIN ShipSure..userid USR2 ON USR2.USR_ID = CT.TND_CreatedBy
LEFT JOIN ShipSure..userid USR3 ON USR3.USR_ID = CT.TND_UpdatedBy
WHERE
	CT.TND_Cancelled = 0
	AND CTS.TST_Desc <> 'Cancelled'