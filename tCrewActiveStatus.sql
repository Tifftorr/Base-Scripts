SELECT
	  AA.RowID AS [Row ID]
    , AA.RecInsertedOn AS [Record Inserted On]
    , AA.set_id AS [Service Record ID]
    , AA.crw_id AS [Crew ID]
    , AA.rnk_id AS [Rank ID]
    , AA.PoolStatus AS [Pool Status]
    , AA.mobilisationcell_id AS [Mobilisation Cell ID]
    , AA.PlanningCell_ID AS [Planning Cell ID]
    , AA.CPL_ID_CMP AS [CMP Cell ID]
    , AA.CURRENT_STATUS AS [Seafarer Status]
    , AA.StartDate AS [Start Date]
    , AA.EndDate AS [End Date]
    , AA.PlanningStatus AS [Planning Status]
    , CASE WHEN AA.Current_Status = 'ONBOARD' THEN AA.[VESSEL_ID_FINAL] END AS [Current Vessel ID]
    , CASE WHEN AA.Current_status <> 'ONBOARD' AND AA.PlanningStatus IS NOT NULL THEN AA.[Vessel_ID_final] END AS [Planned Vessel ID]
    , CASE WHEN AA.Current_status <> 'ONBOARD' AND AA.PlanningStatus IS NULL THEN AA.[Vessel_ID_final] END AS [Last Vessel ID]
    , AA.VMD_ID AS [Vessel Mgmt ID]
    , AA.CLIENT_FINAL AS [Vessel Client]
    , AA.MANAGEMENT_TYPE_FINAL AS [Mgmt Type]
    , AA.VESSEL_TECH_MGT_OFFICE AS [Vessel Technical Office]
    , AA.Fleet AS [Vessel Fleet]
    , AA.VSHIPS_SERVICE_ONBOARD_COUNT AS [V.Ships Services Onboard Count]
    , sct.CCN_Description AS [Crew Employment Type]
    , AA.AvailabilityDate AS [Availability Date]
    , AA.ASN_ID_NAN AS [NAN ID]
    , AA.Promotion_Plan AS [Promotion Plan]
    , AA.SF_TECH_OFFICE AS [Seafarer Technical Office ID]
    , AA.Seafarer_Fleet AS [Seafarer Fleet ID]
    , AA.OwnerSeafarer AS [Seafarer Owner]
    , AA.OVERDUE_TODAY30D AS [Actual Overdue Today]
    , AA.OverdueNoExtToday AS [Overdue Today Basis Original Contract]
FROM Aggregates.[dbo].[CREW_ActiveCrew] AA
LEFT JOIN shipsure..CRWSrvContractType sct ON sct.CCN_ID = AA.crw_employmenttype
WHERE CAST(RecInsertedOn AS DATE) >= '2022-01-01'
  AND CASE 
    WHEN (@{CONCAT('''',pipeline().parameters.DateFrom,'''')}!='NULL' OR @{CONCAT('''',pipeline().parameters.DateTo,'''')}!='NULL') 
    AND (CAST(RecInsertedOn AS DATE) BETWEEN COALESCE(NULLIF(@{CONCAT('''',pipeline().parameters.DateFrom,'''')},''), '1900-01-01') 
    AND COALESCE(NULLIF(@{CONCAT('''',pipeline().parameters.DateTo,'''')},''), GETDATE())) 
      THEN 1
    WHEN @{CONCAT('''',pipeline().parameters.DateFrom,'''')}='NULL' AND @{CONCAT('''',pipeline().parameters.DateTo,'''')}='NULL' 
      THEN 1
    ELSE 0
    END = 1