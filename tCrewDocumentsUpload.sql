SELECT app.RowID AS [Row ID Aggregates],
	app.InsertedOn AS [Inserted On],
	app.crw_id AS [Crew ID],
	app.[Rank],
	app.Client_ID AS [Client ID],
	app.CurrentStatus AS [Current Status],
	app.VESSEL_ID_FINAL AS [Vessel ID],
	app.AttachementID AS [Attachment ID],
	app.UploadedbyUnit AS [Uploaded by Unit],
	app.Description AS [Document Description],
	app.FileName AS [File Name],
	app.documentID AS [Document ID],
	app.Name AS [Document Name],
	app.Comments,
	app.Status AS [Document Status],
	app.crd_country AS [Document Issued Country ID],
	CASE WHEN DS.IN_SCOPE = 'YES' THEN 'IN SCOPE' ELSE 'OUT OF SCOPE' END AS [Document Scope],
	app.PlanningCell_iD AS [Mobilisation Cell ID]
FROM Aggregates.DBO.crew_appdocuments app
	LEFT JOIN Aggregates.DBO.CRWMobileDocumentUploadScope DS ON DS.Doc_Desc = App.[Name]
	LEFT JOIN Shipsure.DBO.CRWSrvContractType ccn ON ccn.CCN_ID = app.CRW_EmploymentType
WHERE CASE 
		WHEN (@{CONCAT('''',pipeline().parameters.DateFrom,'''')}!='NULL' OR @{CONCAT('''',pipeline().parameters.DateTo,'''')}!='NULL') 
		AND (CAST(app.InsertedOn AS DATE) BETWEEN COALESCE(NULLIF(@{CONCAT('''',pipeline().parameters.DateFrom,'''')},''), '1900-01-01') 
		AND COALESCE(NULLIF(@{CONCAT('''',pipeline().parameters.DateTo,'''')},''), GETDATE())) 
			THEN 1
		WHEN @{CONCAT('''',pipeline().parameters.DateFrom,'''')}='NULL' AND @{CONCAT('''',pipeline().parameters.DateTo,'''')}='NULL' 
			THEN 1
		ELSE 0
		END = 1
