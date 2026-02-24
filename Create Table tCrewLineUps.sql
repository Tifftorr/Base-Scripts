CREATE TABLE [ShipMgmt_Crewing].[tCrewLineUps](

	[Line Up ID] [varchar] (20) NOT NULL,
	[Vessel ID] [varchar] (20) NULL,
	[Line Up Call Date] [datetime] NULL,
	[Line Up Description] [varchar] (1000) NULL,
	[Line Up Notes] [varchar] (2000) NULL,
	[Line Up Created On] [datetime] NULL,
	[Line Up Created By] [varchar] (100) NULL,
	[Line Up Updated On] [datetime] NULL,
	[Line Up Updated By] [varchar] (100) NULL,
	[Line Up is Active] [bit] NULL,
	[Line Up Departure] [datetime] NULL,
	[Line Up Completed On] [datetime] NULL

CONSTRAINT [PK__tCrewLineUps__LineUpID] PRIMARY KEY CLUSTERED 
(
	[Line Up ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO