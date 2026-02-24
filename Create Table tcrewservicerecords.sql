CREATE TABLE [ShipMgmt_Crewing].[tCrewServiceRecords](

	[Service Record ID] [varchar](12) NOT NULL,
	[Crew PID] [varchar](20) NULL,
	[Crew Rank] [varchar](255) NULL,
	[Crew Name] [varchar](60) NULL,
	[Crew Surname] [varchar](60) NULL,
	[DOB] [date] NULL,
	[Gender] [varchar](20) NULL,
	[Nationality] [varchar](50) NULL,
	[Country Of Nationality] [varchar](100) NULL,
	[Crew Contract Type] [varchar](50) NULL,
	[Mobilisation Office] [varchar](100) NULL,
	[Planning Office] [varchar](100) NULL,
	[Mobilisation Cell] [varchar](255) NULL,
	[Recruitment Cell] [varchar](255) NULL,
	[Planning Cell] [varchar](255) NULL,
	[ChangeIdentifier] [int] NOT NULL,
 CONSTRAINT [PK__CrewServiceRecords__ServiceRecordID] PRIMARY KEY CLUSTERED 
(
	[Service Record ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO