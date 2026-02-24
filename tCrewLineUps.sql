SELECT
	lnp.lnp_id AS [Line Up ID],
	lnp.ves_id AS [Vessel ID],
	lnp.lnp_calldate AS [Line Up Call Date],
	lnp.lnp_desc AS [Line Up Description],
	lnp.LNP_Notes AS [Line Up Notes],
	lnp.lnp_createdon AS [Line Up Created On],
	usr.USR_DisplayName AS [Line Up Created By],
	lnp.LNP_UpdatedOn AS [Line Up Updated On],
	usr.USR_DisplayName AS [Line Up Updated By],
	lnp.LNP_Active AS [Line Up is Active],
	lnp.LNP_Departure AS [Line Up Departure],
	lnp.LNP_CompletedOn AS [Line Up Completed On]


FROM Shipsure..CRWLineups lnp
LEFT JOIN shipsure..userid usr ON usr.usr_id = lnp.LNP_CreatedBy
LEFT JOIN shipsure..userid usr2 ON usr2.usr_id = lnp.LNP_UpdatedBy
WHERE lnp.lnp_cancelled = 0