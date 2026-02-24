use shipsure
go

select
v.VES_IMOnumber, 
v.VES_Name, 
company.CMP_Name [Supplier Name],
INVAUDITLOG.ial_updatedon [Approved On],
usr.USR_DisplayName as [Approved by], 
sci.sci_name [Invoice Status], 
ih.* 

from [dbo].[INVOICEHDR] IH
INNER JOIN COMPANY  (NOLOck )  on COMPANY.CMP_ID  = IH.CMP_ID
inner join [dbo].[VESMANAGEMENTDETAILS] vmd on vmd.coy_id = ih.coy_id
left join shipsure..vessel v on v.ves_id = vmd.ves_id
LEFT JOIN INVAUDITLOG ON IH.INH_Voucher = INVAUDITLOG.INH_Voucher AND IH.COY_ID = INVAUDITLOG.COY_ID AND INVAUDITLOG.IAT_ID = 'GLAS00000009' -- by approved date
--LEFT JOIN INVAUDITLOG [INVAUDITLOG2] ON INVOICEHDR.INH_Voucher = INVAUDITLOG2.INH_Voucher AND IH.COY_ID = INVAUDITLOG2.COY_ID AND INVAUDITLOG2.IAT_ID = 'GLAS00000007' -- posted
--LEFT JOIN INVAUDITLOG [INVAUDITLOG3] ON IH.INH_Voucher = INVAUDITLOG3.INH_Voucher AND IH.COY_ID = INVAUDITLOG3.COY_ID AND INVAUDITLOG3.IAT_ID = 'GLAS00000009' -- approved
left join shipsure..USERID usr on usr.USR_ID = [INVAUDITLOG].ial_updatedby
left join InvoiceStatusCodes sci on sci.sci_id = ih.INH_Status
where ast_id = 'GLAS00000001' 
--agent dinvoices 
--'GLAS00000001' -- travel invoices
and cast(INVAUDITLOG.ial_updatedon as date) >= '2025-01-01' and  cast(INVAUDITLOG.ial_updatedon as date) <= '2025-03-31'
and ih.dep_id = 'CREW'
--INH_ID = '7247564193'
--ih.INH_Voucher = '250034V7'
--and ih.COY_ID = '2341'



-- sample for agent disbursement 7247564193

select top 10 * from shipsure..INVAUDITLOG
where ial_event like '%Approved%'
and iat_id is not null

select * from [dbo].[INVHEADER]
where DST_COY_ID = '6472'
--SRC_COY_ID = '6472'

select * from [dbo].[INVOICEHDR]
where COY_ID = '6472'
and inh_totalcurr = '2817.94'

--GLAS00000019 ast id for agent disbursements

select iv.*,  
from shipsure..INVAUDITLOG iv
left join shipsure..USERID usr on usr.usr_id = iv.ial_updatedby
where --inh_voucher = '250299V7' -- open invoice for hamburg
inh_voucher = '250034V7'
--and iat_id = 'GLAS00000009'
and coy_id = '2341' --nordic freedom
order by IAL_UpdatedOn desc

shipsure..USERID usr on usr.USR_ID = [INVAUDITLOG3].ial_updatedby


select * from [dbo].[InvoiceAuditEventType] -- iat_ID // to find the types of events on invoice


--GLAS00000039 -- event for updating invoice - coding for invoice na crew related lang then routed to other dept