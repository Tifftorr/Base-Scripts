select
	RowID as [Row ID],
	RecInsertedOn as [Record Inserted On],
	Vessel_ID as [Vessel ID],
	Department as [Department],
	RankCategory as [Rank Category],
	PlanningStatus as [Planning Status],
	Number_of_crew as [Number of Crew],
	Chem_Years as [Years in Chemical Tanker],
	Dry_Years as [Years in Dry Cargo],
	Gas_Years as [Years in Gas Tanker],
	Oil_Years as [Years in Oil Tanker],
	Rank_Years as [Years in Rank],
	Vms_Years as [Years in VMS],
	MatrixRockstar as [Experience Matrix Rockstar],
	Rank_Compliance as [Rank Compliance],
	Type_Compliance as [Vessel Type Compliance],
	VMS_Compliance as [VMS Compliance],
	REQUIREMENT_TYPE as [Requirement Type],
	OMR_Rank as [Oil Major Requirement in Rank],
	OMR_Operator as [Oil Major Requirement in Operator],
	OMR_Type as [Oil Major Requirement in Vessel Type],
	OMR_ALL_Tanker as [Oil Major Requirement All Tankers],
	ALL_Tankers_COMPLIANCE as [All Tankers Compliance],
	All_Tankers_YEARS as [Years in All Tankers]

from aggregates..[CREW_Experience]
WHERE RecInsertedOn >= '2023-01-01'