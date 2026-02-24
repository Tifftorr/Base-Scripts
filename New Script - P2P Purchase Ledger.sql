BEGIN

Select
 
	 IHResult.COY_ID			AS CoyId
	,IHResult.CMP_ID			AS CMP_ID
	,IHResult.INH_TotalCurr		AS Amount
	,IHResult.INH_TotalBase		AS AmountBase
	,IHResult.CUR_ID			AS CurrencyID
	,IHResult.INH_INDID			AS DocumentId
	,IHResult.INH_DatePaid		AS DatePaid
	,IHResult.INH_SupInv		AS InvoiceNumber
	,IHResult.INH_Text			AS InvoiceText

	,IHResult.INH_DateSupInv	AS InvoiceDate
	,IHResult.INH_DatePost		AS PostedDate
	,IHResult.INH_PAYRUNNO		AS PayRunNo
	,IHResult.INH_DateSupPay	AS DateInvoiceDue
	,IHResult.INH_DateRec		AS RecordedDate
	,IHResult.INH_Voucher		AS VoucherNumber
	,ISC.SCI_Name				AS InvoiceStatusName
	,IHResult.INH_Status		AS InvoiceStatusCode

	,IHResult.CMP_Name			AS SupplierName
	,IHResult.CMP_ID			AS SupplierCode
	,JType.JRN_ShortDesc		AS VoucherType
	,JType.JRN_Desc				AS VoucherTypeDesc
	,IHResult.INH_ID			AS InvoiceHeaderId
	,CPAY.COP_CreditDays		AS SupplierCreditDays

	,CloudES.ETT_ID				AS RemittanceAdviceDocumentId
	,IHResult.INH_Order			AS InvoiceOrderNumber
	,IHResult.AST_ID			AS AstId
	,IHResult.INH_Origin		AS InhOrigin
	,IHResult.INH_TravelVouch	As ProtasInvoiceNumber 
	,IHResult.INH_TravelDate	AS TravelDate
	,IHResult.INH_AGENTACCOUNT	AS AgentAccount
	,IHResult.INH_VESSEL		As VesselAux
	,IHResult.INH_Reference1	AS Reference1 
	,IHResult.INH_Reference2	AS Reference2 
	,IHResult.INH_Reference3	AS Reference3 
	,IHResult.INH_CostCenter	AS CostCenter
	,IHResult.INH_UpdatedBy_ID	AS UpdatedByID
	,IHResult.INH_UpdatedBy		AS UpdatedBy
	,IHResult.INH_UpdatedByEmail as UpdatedByEmailAdd
	,IHResult.INH_PostedBy as InvoicePostedBy
	,IHResult.INH_Postedbyemail as InvoicePostedByEmailAdd

into #TempResultStore
FROM 
(
	SELECT 
		IH.COY_ID as COY_ID,IH.INH_TotalCurr,IH.INH_TotalBase,Ih.CUR_ID,IH.INH_INDID,IH.INH_DatePaid,IH.INH_SupInv			
		,IH.INH_Text,IH.INH_DateSupInv,IH.INH_DatePost,IH.INH_PAYRUNNO,Ih.INH_DateSupPay,IH.INH_DateRec,IH.INH_Voucher,IH.INH_Status	
		,COMPANY.CMP_Name,COMPANY.CMP_ID
		,IH.INH_ID,IH.INH_Order			
		,IH.AST_ID,IH.INH_Origin			
		,INH_JournalType,INH_PayMethod,INH_PayNoteNum
		, CASE WHEN (SELECT TOP 1 invoiceDet.ACC_ID
		  					  FROM INVOICEDET invoiceDet
		  					  WHERE IH.COY_ID = invoiceDet.COY_ID
		  					  AND IH.INH_Voucher = invoiceDet.INH_Voucher
		  					 /* AND invoiceDet.ACC_ID = 1*/) IS NOT NULL THEN 1 ELSE 0 END 
						    AccountExist
		,INH_TravelVouch, INH_TravelDate, INH_AGENTACCOUNT, IH.INH_VESSEL, IH.INH_Reference1, IH.INH_Reference2, IH.INH_Reference3, IH.INH_CostCenter, IH.INH_UpdatedBy as INH_UpdatedBy_ID,
		USERID.USR_DisplayName as INH_UpdatedBy, userid.usr_email as INH_UpdatedByEmail,
		UID2.USR_DisplayName as INH_PostedBy, uid2.usr_email as INH_Postedbyemail
	 FROM INVOICEHDR IH  (NOLOck)
		INNER JOIN COMPANY  (NOLOck )  on COMPANY.CMP_ID  = IH.CMP_ID
		INNER JOIN ACCCompany  (NOLOck )  on ACCCompany.COY_ID  = IH.COY_ID AND ACCCompany.COY_COYTYPE='A'
		LEFT JOIN AccSourceTypes ST  (NOLOck ) on ST.AST_ID = IH.AST_ID
		LEFT JOIN USERID ON IH.INH_UpdatedBy = USERID.USR_ID
		LEFT JOIN INVAUDITLOG ON IH.INH_Voucher = INVAUDITLOG.INH_Voucher AND IH.COY_ID = INVAUDITLOG.COY_ID AND INVAUDITLOG.IAT_ID = 'GLAS00000007' -- post invoice event
		LEFT JOIN USERID UID2 ON INVAUDITLOG.IAL_UpdatedBy = UID2.USR_ID
		
	WHERE 
		--IH.COY_ID =  @CoyId
		 (IH.INH_Origin IN ( 'M', 'P', 'L', 'Q', 'T', 'S', 'K') OR (IH.AST_ID Is NOT NULL AND ST.AST_ACCType = 1))
		AND (IH.INH_Status IN (20,24,25,26,27,30) AND Ih.INH_DatePost <= GETDATE() AND cast(Ih.INH_DatePost as date) >= '2024-03-01') --AllByPostDate
		AND IH.COY_ID IN ('VCEX',
'VPSS',
'VMSL',
'VVA',
'BIPL',
'BSIN',
'CMPL',
'IMTS',
'IND',
'VSI',
'KES',
'MED',
'NSM',
'POMI',
'VABU',
'VGGS',
'VGP',
'VSO',
'CROA',
'FPIM',
'VIOM',
'ISTA',
'ROM',
'CCTC',
'VSTI',
'CBM',
'MTS',
'SCMN',
'SENG',
'SFOP',
'SRIN',
'UMC',
'ADA',
'MAD',
'SSCM',
'VSCR',
'UMCR',
'CHEN',
'ITMD',
'ITML',
'SMSG',
'VSA',
'BOS',
'VOF',
'VCY',
'DSMA',
'DSMB',
'VFR',
'GER',
'HSSG',
'NRSG',
'GLW',
'MSTN',
'VLU',
'VMIN',
'VOYA',
'VSOL',
'ITMB',
'ITMM',
'VSG',
'VSPA',
'VML',
'VMN'
'NOR')
)	IHResult

--  Additional join for additional data.
INNER JOIN InvoiceStatusCodes ISC  (NOLOck) on ISC.SCI_ID = IHResult.INH_Status
LEFT JOIN CMPPAYMENT CPAY  (NOLOck )on IHResult.CMP_ID = CPAY.CMP_ID AND (CPAY.COP_LocCode is NULL OR CPAY.COP_LocCode = 'GLAS')
LEFT JOIN JOURNALTYPE JType  (NOLOck )on JType.JRN_Type = IHResult.INH_JournalType 
LEFT JOIN CLOUD_ENTITY_SCANNED CloudES  (NOLOck ) on CloudES.COY_ID = IHResult.COY_ID And CloudES.FK_MATCHED_ID = (CASE
				WHEN IHResult.INH_PayMethod = 'M' THEN IHResult.INH_PAYRUNNO
				WHEN IHResult.INH_PayMethod = 'S' THEN IHResult.INH_PayNoteNum
				ELSE NULL
			END)
			AND CloudES.CMP_ID = IHResult.CMP_ID AND CloudES.ETX_ID = 'GLAS00000020' And CloudES.CloudStatus = 1
WHERE AccountExist <> 0 


-- Insert into Result table.
SELECT DATEDIFF(DAY,InvoiceDate,GETDATE() ) AS AgedDays
,CAST(NULL AS VARCHAR(50)) AS SupplierType ,CAST(NULL AS int) AS Memo_Exist,CAST(NULL AS varchar(150)) AS MaxAccountNumber,CAST(NULL AS int) AS DetailsCount, CoyId,CMP_ID,Amount,AmountBase,CurrencyID,DocumentId,DatePaid,InvoiceNumber,InvoiceText,InvoiceDate,
		PostedDate,PayRunNo,DateInvoiceDue,RecordedDate,VoucherNumber,InvoiceStatusName,InvoiceStatusCode,SupplierName,SupplierCode,VoucherType,VoucherTypeDesc,
		InvoiceHeaderId,SupplierCreditDays,RemittanceAdviceDocumentId,InvoiceOrderNumber,AstId,InhOrigin, ProtasInvoiceNumber, TravelDate, AgentAccount, VesselAux, Reference1, Reference2, Reference3, CostCenter, UpdatedByID ,UpdatedBy, UpdatedByEmailAdd, 
		InvoicePostedBy, InvoicePostedByEmailAdd
		INTO #InvoiceDetailFinalResult
	From 
	#TempResultStore

END

If (Exists(select 1 from #InvoiceDetailFinalResult))
BEGIN
	

			Select DISTINCT  InvoiceDet.ACC_ID as MaxAccount,  InvoiceDet.COY_ID,InvoiceDet.INH_Voucher
			INTO #ACCOUNTS
				FROM #InvoiceDetailFinalResult 
				    INNER JOIN INVOICEDET InvoiceDet
					   ON #InvoiceDetailFinalResult.CoyId = InvoiceDet.COY_ID
					   AND #InvoiceDetailFinalResult.VoucherNumber = InvoiceDet.INH_Voucher

			SELECT DISTINCT
			COY_ID, INH_Voucher ,
			STUFF((SELECT '; ' + c.MaxAccount 
			FROM #ACCOUNTS c
			WHERE c.COY_ID=cc.COY_ID and  c.INH_Voucher=cc.INH_Voucher
			order by c.MaxAccount
			FOR XML PATH('')), 1, 1, '') MaxAccount
			into #ACCOUNTS_FINAL
			FROM #ACCOUNTS cc
			GROUP BY cc.COY_ID, INH_Voucher

			 UPDATE #InvoiceDetailFinalResult
			 SET MaxAccountNumber = h.MaxAccount
				
			 FROM #ACCOUNTS_FINAL h
			Where h.COY_ID= #InvoiceDetailFinalResult.CoyId AND h.INH_Voucher = #InvoiceDetailFinalResult.VoucherNumber

END

UPDATE #InvoiceDetailFinalResult
		SET
		#InvoiceDetailFinalResult.Memo_Exist = CASE WHEN tempmemo.tempMemoCount>0 THEN 1 ELSE 0 END
		from #InvoiceDetailFinalResult res 
		INNER JOIN (SELECT [IME_InvoiceINH_ID] AS invHeaderId, COUNT(IME_ID) as tempMemoCount FROM [INVMEMO] GROUP BY [IME_InvoiceINH_ID]) tempmemo
		ON res.InvoiceHeaderId=tempmemo.invHeaderId

	CREATE TABLE #CompanyTypeList (CMP_ID VARCHAR(12),CMT_ID VARCHAR(6),CMP_MarcasTier INT)  -- Stores company with its type.
	CREATE TABLE #CMPList (CMP_ID VARCHAR(12),IsProcessed BIT DEFAULT (0))				 -- Stores Company Ids.
		
-- Supplier type Logic
INSERT INTO #CompanyTypeList (CMP_ID, CMT_ID, CMP_MarcasTier)
		SELECT
			COMPANY.CMP_ID
			,CMT_ID
			,CMP_MarcasTier
		FROM COMPANY
		INNER JOIN COMPSERV
			ON COMPANY.CMP_ID = COMPSERV.CMP_ID
		WHERE COMPANY.CMP_ID IN (SELECT DISTINCT
				SupplierCode
			FROM #InvoiceDetailFinalResult)

INSERT INTO #CMPList (CMP_ID)
		SELECT DISTINCT
			cmp_id
		FROM #CompanyTypeList

DECLARE	@cmpId VARCHAR(12)
		,@firstCMTId VARCHAR(50)

WHILE (EXISTS (SELECT
		*
	FROM #CMPList
	WHERE IsProcessed = 0)
)
BEGIN
SELECT TOP 1
	@cmpId = cmp_id
FROM #CMPList
WHERE IsProcessed = 0

IF (EXISTS (SELECT
			*
		FROM #CompanyTypeList
		WHERE cmp_id = @cmpId
		AND cmt_id = 'EGROUP')
	)
BEGIN
DELETE FROM #CompanyTypeList
WHERE cmp_id = @cmpId
	AND cmt_id <> 'EGROUP'
END
ELSE
IF (EXISTS (SELECT
			*
		FROM #CompanyTypeList
		WHERE cmp_id = @cmpId
		AND cmt_id = 'OMVC')
	)
BEGIN
DELETE FROM #CompanyTypeList
WHERE cmp_id = @cmpId
	AND cmt_id <> 'OMVC'
END
ELSE
IF (EXISTS (SELECT
			*
		FROM #CompanyTypeList
		WHERE cmp_id = @cmpId
		AND cmt_id = 'VINSC')
	)
BEGIN
DELETE FROM #CompanyTypeList
WHERE cmp_id = @cmpId
	AND cmt_id <> 'VINSC'
END
ELSE
IF (EXISTS (SELECT
			*
		FROM #CompanyTypeList
		WHERE cmp_id = @cmpId
		AND cmt_id = 'MCASUP')
	)
BEGIN
DELETE FROM #CompanyTypeList
WHERE cmp_id = @cmpId
	AND cmt_id <> 'MCASUP'
END
ELSE
BEGIN

SELECT TOP 1
	@firstCMTId = cmt_id
FROM #CompanyTypeList
WHERE cmp_id = @cmpId
DELETE FROM #CompanyTypeList
WHERE cmp_id = @cmpId
	AND cmt_id <> @firstCMTId
END

UPDATE #CMPList
SET IsProcessed = 1
WHERE cmp_id = @cmpId
END

-- Update for Supplier Type in result table.
UPDATE INV
SET INV.SupplierType = (CASE
	WHEN cmp.cmt_id = 'EGROUP' THEN 'Group Company'
	WHEN (cmp.cmt_id = 'OMVC' OR
		cmp.cmt_id = 'VINSC') THEN 'Insurance'
	WHEN (cmp.cmt_id = 'MCASUP' AND
		cmp.CMP_MarcasTier = 1) THEN 'Contract Company - Priority 1'
	WHEN (cmp.cmt_id = 'MCASUP' AND
		(cmp.CMP_MarcasTier <> 1 OR
		cmp.CMP_MarcasTier IS NULL)) THEN 'Contract Company - Priority 2'
	ELSE 'Others'
END)
FROM #InvoiceDetailFinalResult INV
INNER JOIN #CompanyTypeList cmp
	ON INV.SupplierCode = cmp.cmp_id

	select * from #InvoiceDetailFinalResult
	where cast(PostedDate as date) <= GETDATE() AND cast(PostedDate as date) >= '2024-03-01'

	drop table #TempResultStore
	drop table #InvoiceDetailFinalResult
	drop table #CompanyTypeList
	drop table #cmplist
	drop table #ACCOUNTS
	drop table #ACCOUNTS_FINAL