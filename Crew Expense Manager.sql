Use ExpenseManager
go

SELECT          AA.CRW_ID, AA.SET_ID, AA.VES_ID, AA.EXH_ID, CC.EDD_ID, AA.PCN, FULLNAME, NAT_ID, RNK_ShortCode, CP.CPL_Description AS MOB_CELL, Assignment_Description,  VES_NAME, BB.SAT_Description AS EXPENSE_STATUS, -- TOTAL_VALUE, AA.CURRENCY AS HEADER_CURRENCY, 
				Submitted_Date, DD.SAT_Description AS LINE_STATUS,   CC.Description, CC.VALUE, CC.Currency AS LINE_CURRENCY, AA.CURRENCY AS VESSEL_CURRENCY, ExchangeRate, cc.CalculatedValue, 
				 CAT2.CATEGORY_NAME AS ACTIVITY, CAT.Category_Name, AL.AL_Name AS RECHARGE_TYPE, CC.COY_ID, ACC_ID + '-' + ACC_Description AS ACCOUNT_CODE,  REJ_Description AS REJECTION, EDD_RejectedOn , 
				 EDD_ApprovedOn as Approval_Date, u2.USR_DISPLAYNAME as Approved_By, 	 u.USR_DISPLAYNAME AS CREATED_BY,  AL2.AL_NAME AS PAYMENT_METHOD, PAYMENTMETHODIDENTIFIER
				 ,  CP2.CPL_Description AS CMP_CELL, U3.USR_DisplayName AS CMP, VAL.Createdon as [Validated On], [IP].CreatedOn as [In Processed On], [SP].CreatedOn as [Sent Payment On]  
INTO #EXPENSE
FROM ExpenseHeader AA
INNER JOIN SHIPSURE..USERID U (NOLOCK) ON U.USR_ID = AA.UpdatedBy
INNER JOIN ExpenseStatus BB ON BB.SAT_ID = AA.SAT_ID
INNER JOIN EXPENSEDETAIL CC ON CC.EXH_ID = AA.EXH_ID
INNER JOIN ExpenseCategory CAT ON CAT.CAT_ID = CC.CAT_ID
INNER JOIN ExpenseStatus DD ON DD.SAT_ID = CC.SAT_ID
LEFT JOIN ExpenseRejectionReason RR ON RR.REJ_ID = CC.REJ_ID
LEFT JOIN ExpenseAttributeLookup AL ON AL.AL_ID = CC.AL_ID_CompanyType AND AL.AL_LookupCode = 'CompanyAccountingType'
LEFT JOIN ExpenseAttributeLookup AL2 ON AL2.AL_ID = AA.AL_ID_PaymentMethodType AND AL2.AL_LookupCode = 'CrewExpensePaymentMethodType'
LEFT JOIN ExpenseCategory CAT2 ON CAT2.CAT_ID = AA.Activity_ID  AND CAT2.AL_ID_ExpenseCategoryType = 10
INNER JOIN SHIPSURE..CRWPERSONALDETAILS PD (NOLOCK) ON PD.CRW_ID = AA.CRW_ID 
LEFT JOIN SHIPSURE..CRWPOOL CP (NOLOCK) ON CP.CPL_ID = PD.CPL_ID AND CP.CPL_TeamType = 1 AND CP.CPL_Cancelled = 0 
left JOIN SHIPSURE..USERID U2 (NOLOCK) ON U2.USR_ID = cc.EDD_ApprovedBy
LEFT JOIN SHIPSURE..CRWPOOL CP2 (NOLOCK) ON CP2.CPL_ID = PD.CPL_ID_CMP AND CP2.CPL_Type = 5 --AND CP2.CPL_Cancelled = 0 
LEFT JOIN SHIPSURE..CRWPOOLTEAM CPT (NOLOCK) ON CPT.CPL_ID = CP2.CPL_ID AND CPT.POT_Cancelled = 0 AND CPT.POT_Manager = 1
left JOIN SHIPSURE..USERID U3 (NOLOCK) ON U3.USR_ID = CPT.USR_ID
outer apply (Select top (1) al.CreatedOn
				from [dbo].[ExpensesAuditLog] (NOLOCK) AL
				left join [dbo].[ExpenseAuditEventType] aet on aet.aet_id = al.aet_id
				where al.al_id = 1 and aet.aet_id = 6
				and al.source_id = aa.exh_id
				order by al.createdon desc) val -- validated on

outer apply (Select top (1) al.CreatedOn
				from [dbo].[ExpensesAuditLog] (NOLOCK) AL
				left join [dbo].[ExpenseAuditEventType] aet on aet.aet_id = al.aet_id
				where al.al_id = 1 and aet.aet_id = 7
				and al.source_id = aa.exh_id
				order by al.createdon desc) [IP] -- in process

outer apply (Select top (1) al.CreatedOn
				from [dbo].[ExpensesAuditLog] (NOLOCK) AL
				left join [dbo].[ExpenseAuditEventType] aet on aet.aet_id = al.aet_id
				where al.al_id = 1 and aet.aet_id = 8
				and al.source_id = aa.exh_id
				order by al.createdon desc) [SP] -- sent for payment

WHERE AA.EXH_Cancelled = 0
AND CC.EDD_Cancelled = 0
--AND AA.CreatedOn < getdate() -180
ORDER BY AA.CRW_ID, AA.SET_ID, LINE_STATUS



SELECT  EXH_ID, EDD_ID,  CAL_BANKNAME AS BANK, CNT_DESC AS BANK_COUNTRY, CAL_Allotee AS RECIPIENT, NOK_NAME+' '+NOK_SURNAME AS BENEFICIARY_NOK,
		CAL_ACCOUNTCURRENCY AS ACC_CURRENCY, CAL_ACCOUNTNO AS ACC_NUMBER,  DD.AttributeName AS [SORT/SWIFT],  CAL_BANKSORTCODE AS [SORT/SWIFT NR],
		EE.AttributeName AS [IFSC/IBAN], CAL_IBANCODE AS [IFSC/IBAN NR]
 --SELECT AA.*, DD.AttributeName, EE.AttributeName
INTO #BANKDETAILS
FROM SHIPSURE..CRWALLOTMENTS2 AA
INNER JOIN #EXPENSE BB ON BB.PAYMENTMETHODIDENTIFIER = AA.CAL_ID AND PAYMENT_METHOD = 'BankAccount'
INNER JOIN SHIPSURE..COUNTRY C ON C.CNT_ID = AA.CNT_ID
LEFT JOIN SHIPSURE..CRWNextOfKin NOK ON NOK.NOK_ID = AA.CRW_NOK_CRW_ID
LEFT JOIN SHIPSURE..ATTRIBUTEDEF DD ON DD.BITVALUE = AA.CAL_BankCodeType2 AND DD.TABLENAME  = 'CrewAllotmentBankCodeType2' 
LEFT JOIN SHIPSURE..ATTRIBUTEDEF EE ON EE.BITVALUE = AA.CAL_BankCodeType1 AND EE.TABLENAME  = 'CrewAllotmentBankCodeType1' 

SELECT EXH_ID, EDD_ID, BNK_NAME AS  CARD_PROVIDER , convert(VARCHAR, CPC_RegistrationOn, 101) AS REGISTERED_ON
INTO #CARDDETAILS
FROM SHIPSURE..CRWPayrollCard AA
INNER JOIN #EXPENSE BB ON BB.PAYMENTMETHODIDENTIFIER = AA.CPC_ID AND PAYMENT_METHOD = 'PaymentCard'
INNER JOIN SHIPSURE..CRWAllotmentsBank  CC ON CC.BNK_ID = AA.BNK_ID

--SELECT * FROM SHIPSURE..ATTRIBUTEDEF WHERE TABLENAME LIKE '%BANK%'
--SELECT * FROM #EXPENSE WHERE PAYMENT_METHOD = 'BankAccount'
--SELECT * FROM #EXPENSE WHERE PAYMENT_METHOD = 'PaymentCard'

SELECT distinct AA.*, BANK, BANK_COUNTRY, COALESCE(RECIPIENT,BENEFICIARY_NOK) AS BENEFICIARY, ACC_CURRENCY, ACC_NUMBER, [SORT/SWIFT], [SORT/SWIFT NR], [IFSC/IBAN], [IFSC/IBAN NR],
		CARD_PROVIDER, REGISTERED_ON
FROM #EXPENSE AA 
LEFT JOIN #BANKDETAILS BB ON BB.EDD_ID = AA.EDD_ID 
LEFT JOIN #CARDDETAILS CC ON CC.EDD_ID = AA.EDD_ID
ORDER BY Submitted_Date DESC


DROP TABLE #EXPENSE
DROP TABLE #BANKDETAILS
DROP TABLE #CARDDETAILS