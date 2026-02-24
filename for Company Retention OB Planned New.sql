Select
[RowID],
[Datekey],
[RecInsertedOn],
[RecUpdatedon],
[CRW_ID],
[PCN],
[Rnk_id],
[Rank],
[RankCategory],
[Department],
[Nationality],
[MobilisationOffice_ID],
[MobilisationOffice],
[SMO_ID],
[SMO],
[Client_ID],
[Client],
[PlanningCell_ID],
[PlanningCell],
[MobilisationCell_ID],
[MobilisationCell],
[CurrentStatus],
[PlanningStatus],
[VESSEL_ID_FINAL],
[VESSEL_NAME_FINAL],
[VESSEL_TYPE_FINAL],
[SECTOR_FINAL],
[Management_type_FINAL],
--[CRW_EmploymentType],
sct.CCN_Description as [Crw Employment]

from Aggregates..CREW_AppUsers act
left join shipsure..CRWSrvContractType sct ON sct.CCN_ID = act.[CRW_EmploymentType]
where datekey = '20250928' -- last sunday of the reporting month
and (act.CurrentStatus = 'ONBOARD' or act.PlanningStatus is not NULL)
and RankCategory in ('Officers', 'Senior Officers')
and [Sector_final] = 'CARGO'
and (sct.CCN_Description is null or sct.CCN_Description <> 'Third Party Crew')