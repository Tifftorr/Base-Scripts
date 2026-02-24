--tCrewBerths

Select distinct
	svl.SVL_ID [Berth ID],
	SVL_Seq [Berth Sequence],
	svl.NAT_ID [Berth Nationality ID],
	svl.SVL_NatType [Nationality Type],
	svl.RNK_ID [Berth Rank ID],
	SVL_SafeManning [Berth is Safe Manning],
	svl.SVL_From [Berth Valid From],
	svl.SVL_To [Berth Valid To],
	svl.CSS_ID [Berth Type],
	svl.SVL_UpdatedOn [Berth UpdatedOn],
	svl.SVL_UpdatedBy [Berth Updated By ID],
	svl.SVL_Reason [Berth Reason],
	svl.SVL_UseNANProcess [Berth Use NAN Process],
	svl.SVL_ManningFactor [Manning Factor]
	svl.svl_defduration [LOC],
	svl.svl_defdurationunit [LOC Unit],
	svl.svl_leaveduration [Leave Duration],
	svl.svl_leavedurationunit [Leave Duration Unit],
	svl.svl_relievernotrequired

	from shipsure.[dbo].[CRWCLVesCrewList] (NOLOCK) SVL
		where svl.SVL_Deleted = 0
