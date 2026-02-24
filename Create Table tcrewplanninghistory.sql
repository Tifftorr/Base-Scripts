CREATE TABLE [ShipMgmt_Crewing].[tCrewPlanningHistory](

	[Crew Planning History ID] [varchar](20) NOT NULL,
	[Crew ID] [varchar](20) NULL,
	[Service Record ID] [varchar](20) NULL,
	[Planning Status ID Previous] [varchar](20) NULL,
	[Planning Status Previous] [varchar](60) NULL,
	[Planning Status ID New] [varchar](20) NULL,
	[Planning Status New] [varchar](60) NULL,
	[Planning History Created On] [DateTime] NULL,
	[Planning History Created By ID] [varchar](20) NULL,
	[Planning History Created By] [varchar](200) NULL,
	[Planning History Updated On] [DateTime] NULL,
	[Planning History Updated By ID] [varchar](20) NULL,
	[Planning History Updated By] [varchar](200) NULL,
	[Notes] [varchar](1000) NULL,
	[ChangeIdentifier] [int] NOT NULL,

CONSTRAINT [PK__CrewPlanningHistory__CrewPlanningHistoryID] PRIMARY KEY CLUSTERED 
(
	[Crew Planning History ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO