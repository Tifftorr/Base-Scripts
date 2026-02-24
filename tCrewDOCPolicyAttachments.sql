SELECT

ett.ETT_ID AS [Attachment ID],
ett.FK_Matched_ID AS [FK Document ID],
ett_filename AS [Attachment File Name],
ett.ett_desc AS [Attachment Description],
ett.cloudstatus AS [Cloud Status],
ett.ett_updateby AS [Updated By ID],
usr.usr_displayname AS [Updated By],
ett.ett_updateon AS [Updated On],
ett.ett_createdby AS [Attachment Created By ID],
usr2.usr_displayname AS [Attachment Created By],
ett.ves_id AS [Linked Vessel ID],
ett.crw_id AS [Crew ID]

FROM shipsure.dbo.CLOUD_ENTITY_SCANNED ett
LEFT JOIN  ShipSure..userid usr on usr.usr_id = ett.ett_updateby
LEFT JOIN  ShipSure..userid usr2 on usr2.usr_id = ett.ett_createdby
WHERE ett.ett_reference_2 = 'GLAS00000030' -- only for declaration of compliance policy attachments
AND ett.ett_cancelled = 0