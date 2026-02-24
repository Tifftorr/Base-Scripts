--tCrewDocuments

SELECT DISTINCT
	crd.crd_id as [Crw Doc ID],
	crd.crw_id as [Crew ID],
	crd.doc_id as [Doc ID],
	cm.doc_desc as [Document Name],
	crd.dst_id as [Doc Status ID],
	dst.dst_description as [Doc Status],
	crd.crd_number as [Doc Number],
	crd.crd_country as [Doc Country],
	crd.crd_issued as [Issued On],
	crd.crd_expiry as [Expiry],
	crd.crd_comments as [Comments],
	crd.crd_approvedby as [Approved By],
	crd.crd_place as [Doc Place],
	crd.crd_supersededby as [Superseded By],
	crd.crd_isprimarydocument as [Is Primary Document],
	crd.crd_updatedby as [Updated By ID],
	ud.USR_DisplayName as [Updated By],
	crd.CRD_UpdatedOn as [Updated On],
	crd.crd_reviewedby as [Reviewed By ID],
	ud2.USR_DisplayName as [Reviewed By],
	crd.crd_reviewedon as [Reviewed On],
	crd.crd_createdon as [Created On],
	crd.crd_createdby as [Created By ID],
	ud3.USR_DisplayName as [Created By],
	BINARY_CHECKSUM(
		crd.crd_id,
		crd.crw_id,
		crd.doc_id,
		cm.doc_desc,
		crd.dst_id,
		dst.dst_description,
		crd.crd_number,
		crd.crd_country,
		crd.crd_issued,
		crd.crd_expiry,
		crd.crd_comments,
		crd.crd_approvedby,
		crd.crd_place,
		crd.crd_supersededby,
		crd.crd_isprimarydocument,
		crd.crd_updatedby,
		ud.USR_DisplayName,
		crd.CRD_UpdatedOn,
		crd.crd_reviewedby,
		ud2.USR_DisplayName,
		crd.crd_reviewedon,
		crd.crd_createdon,
		crd.crd_createdby,
		ud3.USR_DisplayName
	) [ChangeIdentifier]

FROM shipsure.dbo.crwdocs CRD
LEFT JOIN shipsure.dbo.crwdocmaster CM on CM.doc_id = crd.doc_id
LEFT JOIN shipsure.[dbo].[CRWDocStatus] DST ON DST.DST_ID = CRD.DST_ID
LEFT JOIN shipsure..USERID (NOLOCK) UD on UD.USR_ID = CRD.crd_updatedby
LEFT JOIN shipsure..USERID (NOLOCK) UD2 on UD2.USR_ID = CRD.crd_reviewedby
LEFT JOIN shipsure..USERID (NOLOCK) UD3 on UD2.USR_ID = CRD.crd_createdby
WHERE cast(crd.crd_createdon as date) BETWEEN DATEADD(year,-2,getdate()) AND GETDATE()
AND crd.crd_cancelled = 0