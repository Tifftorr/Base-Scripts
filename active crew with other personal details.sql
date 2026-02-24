Select distinct
	AA.Datekey,
	AA.PCN,
	PD.CRW_EmployeeNo as [Employee No.],
	CONCAT(PD.CRW_Surname, ',',' ',PD.CRW_ForeName,' ', PD.CRW_MiddleNames) as [Full Name],
	PD.CRW_Surname as Surname,
	nat.nat_description as Nationality,
	pd.CRW_MobileNo as [Mobile Number],
	pd.CRW_EmailAdd as [Email Address],
	pd.[CRW_Telephone1],
	pd.[CRW_Telephone2],
	pd.CRW_Telephone3,
	pd.CRW_Telephone4


from aggregates..CREW_AppUsers AA
inner join shipsure..CRWPersonalDetails (NOLOCK) PD on pd.crw_id = AA.crw_id
LEFT JOIN   NATIONALITY NAT (NOLOCK) ON PD.NAT_ID = NAT.NAT_ID
left join CRWDocs DOC on doc.crw_id = aa.crw_id and cast(doc.CRD_Expiry as date) >= GETDATE() and doc.doc_id = 'VGRP00000489' and doc.CRD_Cancelled = 0
left join CRWDocs DOC2 on doc2.crw_id = aa.crw_id and cast(doc2.CRD_Expiry as date) >= GETDATE() and doc2.doc_id = 'VSHP00000083' and doc2.CRD_IsPrimaryDocument = 1 and doc2.CRD_Cancelled = 0
left join shipsure..CRWPersonalEducationDetails PDE on pde.CRW_ID = AA.CRW_ID
left join shipsure..COUNTRY CTRY on CTRY.cnt_id = PDE.CNT_ID
left join shipsure..CRWLANG LN on ln.CRW_ID = AA.CRW_ID
left join shipsure..LANG L on l.LAN_ID = LN.LAN_ID
where AA.client like '%Adnoc%'
and AA.Datekey = '20241110'

/*select top 100 * from CRWDocs DOC
left join crwdocmaster CM on CM.doc_id = doc.doc_id
where CM.Doc_desc like '%Passport%'*/

--select top 10 * from shipsure..CRWPersonalEducationDetails
-- select top 10 * from shipsure..CRWLanguages
--select top 10 * from shipsure..CRWLANG;
--select top 10 * from shipsure..LANG


select top 10 * from shipsure..CRWPersonalDetails 