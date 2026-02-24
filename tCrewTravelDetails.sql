SELECT
	cmm.tri_id AS [Travel Main ID],
	cmm.[crw_id] AS [Crew ID],
	cmm.[set_id] AS [Service Record ID],
	cmm.[lnp_id] AS [Line Up ID],
	att2.[attributedesc] AS [Travel Type],
	cmm.[tri_bookingref] AS [Booking Reference],
	att1.[attributedesc] AS [Booking Status],
	cmm.tri_from AS [Destination From],
	cmm.tri_to AS [Destination To],
	cmm.tri_departuredate AS [Departure Date],
	cmm.TRI_ArrivalDate as [Arrival Date],
	att.[attributedesc] AS [Travel Provider],
	cmm.TRI_UpdatedOn AS [Updated On],
	usr.usr_displayname AS [Updated By],
	cms.tse_details AS [Flight Details]

FROM shipsure..CRWTravelMain CMM
LEFT JOIN shipsure..CRWTravelSegments CMS ON CMS.TRI_ID=CMM.TRI_ID AND CMS.TSE_CANCELLEd=0 AND CMS.TSE_TYPE=10
LEFT JOIN shipsure..AttributeDef ATT ON ATT.AttributeName=CMM.TRI_TravelProvider AND ATT.TableName='TravelProvider'
LEFT JOIN shipsure..AttributeDef ATT1 ON ATT1.AttributeName=CMM.TRI_Status AND ATT1.TableName='TravelBookingStatus'
LEFT JOIN shipsure..AttributeDef ATT2 ON  ATT2.AttributeName=CMM.[tri_traveltype] AND ATT2.TableName='TravelType'
LEFT JOIN shipsure..userid usr ON usr.usr_id = cmm.TRI_UpdatedBy
WHERE CMM.TRI_TravelType in (10, 20)
AND CMM.TRI_Cancelled=0