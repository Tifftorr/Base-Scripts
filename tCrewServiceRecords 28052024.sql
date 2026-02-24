SELECT DISTINCT

	sd.Set_id [Service Record ID],
	sd.Crw_Id [Crew ID],
	sd.RNK_ID [Rank ID],
	rnk.RNK_Description [Rank],
	sd.sts_id [Status ID],
	sts.sts_desc as [Status],
	sd.SGT_ID [Sign Off Reason ID],
	sgt.sgt_desc [Sign Off Reason],
	sd.set_startdate [Start Date],
	sd.Set_enddate [End Date],
	sd.set_seadays [Sea Days],
	sd.set_monthsonboard [Months Onboard],
	sd.set_loadportID [Load Port ID],
	sd.SET_DisportID [Disport ID],
	sd.set_cancelled [Service Cancelled],
	sd.ves_id [Vessel ID],
	sd.set_activeStatus as [Active Status],
	sd.svl_id [Berth ID],
	sd.set_relieverID [Reliever Service Record ID],
	sd.set_previousexp [Previous Experience],
	sd.set_UTCUpdatedOn [Service Record UpdatedOn],
	sd.set_updatedby [Service Record UpdatedBy ID],
	ud.USR_DisplayName as [Service Record Updated By],
	sd.rnk_id_budgeted [Rank ID Budgeted],
	rnk2.RNK_Description [Rank Budgeted],
	sd.csa_id [Planning Status ID],
	pl.CSA_Description [Planning Status],
	sd.sas_id [Service Active Status ID],
	case 
		when cast(sd.SAS_ID as varchar) = '0' then 'Cancelled'
		when cast(sd.SAS_ID as varchar) = '1' then 'Active'
		when cast(sd.SAS_ID as varchar) = '2' then 'Historical'
		when cast(sd.SAS_ID as varchar) = '3' then 'Future'
	else cast(sd.SAS_ID as varchar) end as [Service Active Status],
	sd.lnp_id_joiner [Lineup ID Joiner],
	sd.lnp_id_leaver [Lineup ID Leaver],
	sd.set_contractlengthunit [Service Contract Length Unit],
	case 
		when sd.set_contractlengthunit = 'D' then 'Day'
		when sd.set_contractlengthunit = 'M' then 'Month'
		when sd.set_contractlengthunit = 'W' then 'Week'
	else sd.set_contractlengthunit end as [Service Contract Length Description],
	sd.VMD_ID [Service Vessel Management ID],
	sd.SET_IsRankChangedOnBoard [Rank Changed Onboard],
	ext.ext_mobilisationacceptedby [Mobilisation Accepted By ID],
	ud3.USR_DisplayName [Mobilisation Accepted By],
	ext.ext_mobilisationacceptedon [Mobilisation Accepted On],
	ext.ext_CrewReadyOn [Crew Estimated Readiness Date],
	ext.EXT_ExtensionReason [Crew Extension Reason ID],
	att.AttributeDesc [Crew Extension Reason],
	ext.ext_extendedby [Crew Extended By ID],
	ud2.USR_DisplayName [Crew Extended By],
	ext.ext_extendedon [Crew Extended On],
	ext.ext_agreedbyseafarer [Extension Agreed by Seafarer],
	ext.set_extensionvaliduntil [Extension Valid Until],
	ext.set_isextensionapproved [Extension Approved],
	sd.SET_LASTVESSEL as [Is Last Vessel],
	BINARY_CHECKSUM(
		sd.Set_id,
		sd.Crw_Id,
		sd.RNK_ID,
		rnk.RNK_Description,
		sd.sts_id,
		sts.sts_desc,
		sd.SGT_ID,
		sgt.sgt_desc,
		sd.set_startdate,
		sd.Set_enddate,
		sd.set_seadays,
		sd.set_monthsonboard,
		sd.set_loadportID,
		sd.SET_DisportID,
		sd.set_cancelled,
		sd.ves_id,
		sd.set_activeStatus,
		sd.svl_id,
		sd.set_relieverID,
		sd.set_previousexp,
		sd.set_UTCUpdatedOn,
		sd.set_updatedby,
		ud.USR_DisplayName,
		sd.rnk_id_budgeted,
		rnk2.RNK_Description,
		sd.csa_id,
		pl.CSA_Description,
		sd.sas_id,
		sd.lnp_id_joiner,
		sd.lnp_id_leaver,
		sd.set_contractlengthunit,
		sd.VMD_ID,
		sd.SET_IsRankChangedOnBoard,
		ext.ext_mobilisationacceptedby,
		ext.ext_mobilisationacceptedon,
		ext.ext_CrewReadyOn,
		ext.EXT_ExtensionReason,
		att.AttributeDesc,
		ext.ext_extendedby,
		ud2.USR_DisplayName,
		ext.ext_extendedon,
		ext.ext_agreedbyseafarer,
		ext.set_extensionvaliduntil,
		ext.set_isextensionapproved,
		sd.SET_LASTVESSEL
	) [ChangeIdentifier]

FROM shipsure.dbo.CRWSrvDetaiL (NOLOCK) SD
left join shipsure.[dbo].[crwmovementtypes] (NOLOCK) STS on sts.sts_id = sd.sts_id
left join shipsure.dbo.CRWSignOffType (NOLOCK) SGT on sgt.sgt_id = sd.sgt_id
left join shipsure..[CRWSrvDetailExtension] (NOLOCK) ext on ext.set_id = sd.set_id and ext.ext_cancelled = 0
left join shipsure..AttributeDef (NOLOCK) att on att.BitValue = ext.EXT_ExtensionReason
left join shipsure..CRWRanks (NOLOCK) rnk on rnk.rnk_id = sd.RNK_ID
left join shipsure..USERID (NOLOCK) UD on UD.USR_ID = sd.set_updatedby
left join shipsure..crwranks (NOLOCK) rnk2 on rnk2.RNK_ID = sd.RNK_ID_Budgeted
left join shipsure.dbo.CRWAssignedStatus (NOLOCK) PL on pl.CSA_ID = sd.csa_id
left join shipsure..USERID (NOLOCK) UD2 on UD2.USR_ID = ext.ext_extendedby
left join shipsure..USERID (NOLOCK) UD3 on UD2.USR_ID = ext.ext_mobilisationacceptedby
where cast(sd.set_startdate as date) >= '1950-01-01' and sd.set_startdate <= DATEADD(yyyy, 2, GETDATE())