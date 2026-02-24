ALTER TABLE [ShipMgmt_Crewing].[tCrewPositionsOnBoardListPerDay]
ADD 
	[Service Record ID] [varchar] (20) NULL,
	[Rank ID] [varchar] (20) NULL,
	[Mobilisation Cell ID] [varchar] (20) NULL,
	[Crew Contract Type]  [varchar] (100) NULL,
	[Third Party Agent ID]  [varchar] (20) NULL,
	[Berth Type] [varchar] (20) NULL
;