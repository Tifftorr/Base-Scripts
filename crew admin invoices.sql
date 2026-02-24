use shipsure
go

select distinct
v.VES_IMOnumber, 
v.VES_Name, 
company.CMP_Name [Supplier Name],
INVAUDITLOG.ial_updatedon [Approved On],
usr.USR_DisplayName as [Approved by],
--usr1.USR_DisplayName as [Agent Invoices Updated By],
sci.sci_name [Invoice Status],
ih.inh_journaltype,
jrn.jrn_desc as [journal type desc],
ih.coy_id,
ih.INH_Voucher,
ih.INH_Status,
ih.CMP_ID,
ih.CUR_ID,
ih.INH_SupInv,
ih.INH_Order,
ih.INH_TotalCurr,
ih.INH_TotalBase,
ih.INH_TotalUSD,
ih.INH_Text,
ih.INH_PayType,
ih.INH_PayAccnt,
ih.INH_PayMethod,
ih.INH_DateSupInv,
ih.INH_DateSupPay,
ih.INH_DateRec,
ih.INH_DateRecAct,
ih.INH_DatePost,
ih.INH_DatePostAct,
ih.INH_DatePaid,
ih.INH_DatePaidAct,
ih.INH_DateStatChg,
ih.INH_DateStatChgAct,
ih.INH_ID,
ih.INH_UpdatedOn,
ih.INH_PayRun,
ih.INH_UpdatedBy,
ih.INH_Origin,
ih.INH_TravelDate,
ih.INH_TravelVouch,
ih.INH_CreatedOn,
ih.INH_OrderNo,
ih.AST_ID, -- invoice type
ih.DEP_ID
--invdet.[ind_id],
--invdet.[ind_amountcurr]

from [dbo].[INVOICEHDR] IH
INNER JOIN COMPANY  (NOLOck )  on COMPANY.CMP_ID  = IH.CMP_ID
inner join [dbo].[VESMANAGEMENTDETAILS] vmd on vmd.coy_id = ih.coy_id
left join shipsure..vessel v on v.ves_id = vmd.ves_id
LEFT JOIN INVAUDITLOG ON IH.INH_Voucher = INVAUDITLOG.INH_Voucher AND IH.COY_ID = INVAUDITLOG.COY_ID AND INVAUDITLOG.IAT_ID = 'GLAS00000009' -- by approved date
--LEFT JOIN INVAUDITLOG [INVAUDITLOG2] ON INVOICEHDR.INH_Voucher = INVAUDITLOG2.INH_Voucher AND IH.COY_ID = INVAUDITLOG2.COY_ID AND INVAUDITLOG2.IAT_ID = 'GLAS00000007' -- posted
--LEFT JOIN INVAUDITLOG [INVAUDITLOG3] ON IH.INH_Voucher = INVAUDITLOG3.INH_Voucher AND IH.COY_ID = INVAUDITLOG3.COY_ID AND INVAUDITLOG3.IAT_ID = 'GLAS00000009' -- approved
--LEFT JOIN INVAUDITLOG [INVAUDITLOG4] ON IH.INH_Voucher = INVAUDITLOG4.INH_Voucher AND IH.COY_ID = INVAUDITLOG4.COY_ID AND INVAUDITLOG4.IAT_ID = 'GLAS00000039' -- invoice updated --for those invoices where crew admin pass along to other departments
left join shipsure..USERID usr on usr.USR_ID = INVAUDITLOG.ial_updatedby
--left join shipsure..USERID usr1 on usr1.USR_ID = [INVAUDITLOG4].ial_updatedby
left join InvoiceStatusCodes sci on sci.sci_id = ih.INH_Status
left join JOURNALTYPE jrn on jrn.jrn_type = ih.inh_journaltype
--left join shipsure.[dbo].[INVOICEDET] invdet on invdet.[coy_id] = IH.[coy_id] and invdet.[inh_voucher] = ih.INH_Voucher
where  cast(INVAUDITLOG.ial_updatedon as date) >= '2025-08-01' and  cast(INVAUDITLOG.ial_updatedon as date) <= '2025-08-31'

--and jrn.jrn_desc = 'Agents Disbursement Invoice' -- agents disbursements
--and company.CMP_Name like '%Global Marine Travel%' -- gmt as supplier

and ih.dep_id = 'CREW'
-- shanghai vessels
/*
and ih.coy_id in ('6155',
'6320',
'5244',
'6597',
'5639',
'6598',
'6599',
'6160',
'4780',
'4922',
'6099',
'4796',
'4895',
'5652',
'5653',
'5650',
'5656',
'6423',
'6386',
'6383',
'6377',
'6336',
'6288',
'6175',
'6296',
'6176',
'6374',
'6237',
'6153',
'6224',
'6240',
'6364',
'6212',
'6206',
'6421',
'6291',
'6297',
'6292',
'6003',
'6010')*/


--select top 10 * from [dbo].[INVOICEHDR]

--and company.CMP_Name like '%Global Marine Travel%'
--and dep_id = ''

--ast_id = 'GLAS00000019' --agent dinvoices --'GLAS00000001' -- travel invoices
--ih.INH_SupInv = 'VGP-2025-275221'
--ast_id = 'GLAS00000006'
--and company.CMP_Name = 'V.GROUP MANPOWER SERVICES'
-- additional costs NFI supplier name = 'V.GROUP MANPOWER SERVICES'
-- pero may difference sa laman ng invoice if fixed or non-fixed

-- check logs, 
-- 


/*select top 10 * from [dbo].[InvoiceHdrExtraInfo]
select top 10 * from [dbo].[INVOICEHDRGROUP]
select top 10 * from [dbo].[INVOICEHEADERAUDITLOG]
select top 10 * from [dbo].[InvoiceStatusCodes]
select top 10 * from [dbo].[InvoiceSubTypes]
select top 10 * from JOURNALTYPE

select top 10 * from shipsure..attributedef
where tablename like '%Journal%'*/

/*select * from shipsure.[dbo].[INVOICEDET]
where coy_id = '6044'
and inh_voucher = '250063V7'*/


-- agent disbursement and travel invoices
-- March 2025
-- invoice_supinv (invoice number) 7446533540
-- coy id 6044
-- voucher number 250063V7