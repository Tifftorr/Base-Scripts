CREATE TABLE [ShipMgmt_Crewing].[tActiveCrewSnapshot](
	[Row ID] [varchar] (100) NOT NULL,
	[Record Inserted On] [datetime] NULL,
	[Service Record ID] [varchar] (20) NULL,
	[Crew ID] [varchar] (20) NULL,
	[Rank ID] [varchar] (20) NULL,
	[Berth Type] [varchar] (100) NULL,
	[Pool Status] [varchar] (100) NULL,
	[Mobilisation Cell ID] [varchar] (20) NULL,
	[Planning Cell ID] [varchar] (20) NULL,
	[CMP Cell ID] [varchar] (20) NULL,
	[Seafarer Status] [varchar] (100) NULL,
	[Service Start Date] [datetime] NULL,
	[Service End Date] [datetime] NULL,
	[Planning Status] [varchar] (100) NULL,
	[Current Vessel ID] [varchar] (20) NULL,
	[Planned Vessel ID] [varchar] (20) NULL,
	[Last Vessel ID] [varchar] (20) NULL,
	[Vessel Mgmt ID] [varchar] (20) NULL,
	[Vessel Client] [varchar] (200) NULL,
	[Mgmt Type] [varchar] (100) NULL,
	[Vessel Technical Office] [varchar] (200) NULL,
	[Vessel Fleet] [varchar] (200) NULL,
	[Reliever Required] [bit] NULL,
	[Is Berth Occupied] [bit] NULL,
	[V.Ships Services Onboard Count] [int] NULL,
	[Crew Employment Type] [varchar] (20) NULL,
	[Availability Date] [datetime] NULL,
	[NAN ID] [varchar] (20) NULL,
	[Promotion Plan] [varchar] (100) NULL,
	[Seafarer Technical Office ID] [varchar] (20) NULL,
	[Seafarer Fleet ID] [varchar] (20) NULL,
	[Seafarer Owner] [varchar] (200) NULL,
	[Actual Overdue Today] [bit] NULL,
	[Overdue Today Basis Original Contract] [bit] NULL

CONSTRAINT [PK__ActiveCrewSnapshot__RowID] PRIMARY KEY CLUSTERED 
(
	[Row ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO