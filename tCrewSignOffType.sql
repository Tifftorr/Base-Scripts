--tCrewSignOffType 

select distinct
	SGT_ID [SignOff Reason ID],
	SGT_SeqNum [SGT Sequence],
	SGT_GroupSignoffType [SGT Group Type],
	SGT_IsValidForCrewChange [Is Valid for Crew Change],
	SGT_IsValidForTransfer [Is Valid for Vessel Transfer],
	SGT_IsValidForPromotion [Is Valid for Promotion],
	SGT_IsValidForDemotion [Is Valid for Demotion],
	SGT_IsValidForSuperN [Is Valid for Supernumerary],
	SGT_IsValidForVesselCrewChange [Is Valid for Vessel Crew Change],
	SGT_IsValidForLeftManagement [Is Valid for Vessel Left Mgmt],
	SGT_Desc [SignOff Reason],
	SGT_ShortCode [SignOff Reason Short],
	SGT_UpdatedOn [SGT UpdatedOn],
	SGT_UpdatedBy [SGT Updated By ID]

	from shipsure.dbo.CRWSignOffType (NOLOCK)