--tCrewBerths

SELECT DISTINCT
	svl.SVL_ID [Berth ID],
	SVL_Seq [Berth Sequence],
	svl.NAT_ID [Berth Nationality ID],
	NAT.nat_description [Berth Nationality],
	svl.SVL_NatType [Nationality Type ID],
	att.attributeDesc [Nationality Type],
	svl.RNK_ID [Berth Rank ID],
	rnk.RNK_Description [Berth Rank],
	SVL_SafeManning [Berth is Safe Manning],
	svl.SVL_From [Berth Valid From],
	svl.SVL_To [Berth Valid To],
	svl.CSS_ID [Berth Type ID],
	css.css_description [Berth Type],
	svl.SVL_UpdatedOn [Berth Updated On],
	svl.SVL_UpdatedBy [Berth Updated By ID],
	UD.USR_DisplayName [Berth Updated By],
	svl.SVL_Reason [Berth Reason],
	svl.SVL_UseNANProcess [Berth Use NAN Process],
	svl.SVL_ManningFactor [Manning Factor],
	svl.svl_defduration [Length Of Contract],
	svl.svl_defdurationunit [Length Of Contract Unit],
	svl.svl_leaveduration [Leave Duration],
	svl.svl_leavedurationunit [Leave Duration Unit],
	svl.svl_relievernotrequired [Reliever Not Required],
	BINARY_CHECKSUM (
		svl.SVL_ID,
		SVL_Seq,
		svl.NAT_ID,
		NAT.nat_description,
		svl.SVL_NatType,
		att.attributeDesc,
		svl.RNK_ID,
		rnk.RNK_Description,
		SVL_SafeManning,
		svl.SVL_From,
		svl.SVL_To,
		svl.CSS_ID,
		css.css_description,
		svl.SVL_UpdatedOn,
		svl.SVL_UpdatedBy,
		UD.USR_DisplayName,
		svl.SVL_Reason,
		svl.SVL_UseNANProcess,
		svl.SVL_ManningFactor,
		svl.svl_defduration,
		svl.svl_defdurationunit,
		svl.svl_leaveduration,
		svl.svl_leavedurationunit,
		svl.svl_relievernotrequired
	) [ChangeIdentifier]

FROM shipsure.[dbo].[CRWCLVesCrewList] (NOLOCK) SVL
	left join shipsure..CRWRanks (NOLOCK) rnk ON rnk.rnk_id = svl.RNK_ID
	left join shipsure..CRWServiceStatus (NOLOCK) CSS ON CSS.css_id = svl.css_id
	left join shipsure..USERID (NOLOCK) UD on UD.USR_ID = svl.SVL_UpdatedBy
	left join Shipsure..NATIONALITY (NOLOCK) NAT ON Nat.NAT_ID = svl.NAT_ID
	left join shipsure..AttributeDef (NOLOCK) att ON att.bitValue = svl.SVL_NatType and att.tableName = 'NATIONALITY_TYPE'
WHERE svl.SVL_Deleted = 0