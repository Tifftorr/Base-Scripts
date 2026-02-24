ALTER TABLE [ShipMgmt_Crewing].[tCrewRetentionEvents]
ADD 
	[Rank ID] [varchar] (20) NULL,
	[Service Record ID Last Onboard] [varchar] (20) NULL,
	[Leave Service Record ID] [varchar] (20) NULL,
	[Mobilisation Cell ID] [varchar] (20) NULL,
	[Planning Cell ID] [varchar] (20) NULL,
	[Last Sign Off Date] [datetime] NULL,
	[Event Created On] [datetime] NULL,
	[Event Cancelled] [int] NULL
;