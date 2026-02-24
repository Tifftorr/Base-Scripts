/*use shipsure
go

select top 10 * from [dbo].[INVOICEHDR] IH
where inh_payrunno = 'VGR7R0284184'

select * from AccSourceTypes

select top 10 * from [dbo].[INVHEADER]*/

SELECT
			INVOICEHDR.COY_ID,
			INVOICEHDR.INH_ID,
			INVOICEHDR.INH_PAYRUNNO,
			INVOICEHDR.INH_TotalCurr,
			INVOICEHDR.CUR_ID,
			INVOICEHDR.INH_TotalBase as FuntionalAmount,
			INVOICEHDR.INH_DatePaid,
			INVOICEHDR.inh_DateRecAct as [Actual Date Recorded],
			USERID.USR_DisplayName as [Paid Processed By],
			USERID2.USR_DisplayName as [Posted By],
			INVOICEHDR.INH_DatePaidAct as IAL_UpdatedOn
		FROM
			INVOICEHDR
			LEFT JOIN INVAUDITLOG ON INVOICEHDR.INH_Voucher = INVAUDITLOG.INH_Voucher AND INVOICEHDR.COY_ID = INVAUDITLOG.COY_ID AND INVAUDITLOG.IAT_ID = 'GLAS00000021'
			LEFT JOIN INVAUDITLOG [INVAUDITLOG2] ON INVOICEHDR.INH_Voucher = INVAUDITLOG2.INH_Voucher AND INVOICEHDR.COY_ID = INVAUDITLOG2.COY_ID AND INVAUDITLOG2.IAT_ID = 'GLAS00000007' -- posted
			LEFT JOIN USERID ON INVAUDITLOG.IAL_UpdatedBy = USERID.USR_ID
			LEFT JOIN USERID as [USERID2] ON INVAUDITLOG2.IAL_UpdatedBy = USERID2.USR_ID

		WHERE 
			/*INVOICEHDR.COY_ID = @sCoyId AND*/ INVOICEHDR.INH_Origin = 'R' AND INVOICEHDR.INH_Status = 30 
			AND cast(INVOICEHDR.INH_DatePaid as date) BETWEEN '2024-03-01' AND GETDATE()
			AND INVOICEHDR.COY_ID IN ('CHEN', 'BMPL', 'BMSL',
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
'VSOL',
'ITMB',
'ITMM',
'VSG',
'VML',
'NOR',
'BIPL',
'BSIN',
'CMPL',
'IMTS',
'IMT',
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
'FPIM',
'VIOM',
'ISTA',
'VMN',
'ROM',
'CCTC',
'VSTI',
'MTS',
'ADA',
'MARC',
'SSCM',
'VSCR',
'VSPA',
'VCEX',
'VPSS',
'VMSL',
'VVA')
		ORDER BY
			INVOICEHDR.INH_DatePaid desc