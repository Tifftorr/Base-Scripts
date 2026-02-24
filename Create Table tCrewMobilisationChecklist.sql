CREATE TABLE [ShipMgmt_Crewing].[tCrewMobilisationChecklist](

	[Checklist ID] [varchar](20) NOT NULL,
	[Crew ID] [varchar](20) NULL,
	[Service Record ID] [varchar](20) NULL,
	[Checklist Status ID] [varchar](20) NULL,
	[Checklist Status] [varchar](60) NULL,
	[Checklist Created By ID] [varchar](20) NULL,
	[Checklist Created By] [varchar](1000) NULL,
	[Checklist Created On] [datetime] NULL,
	[Checklist Updated By ID] [varchar](20) NULL,
	[Checklist Updated By] [varchar](1000) NULL,
	[Checklist Updated On] [datetime] NULL,
	[Checklist Signed By ID] [varchar](20) NULL,
	[Checklist Signed By] [varchar](1000) NULL,
	[Checklist Signed On] [datetime] NULL,
	[Checklist Completed By ID] [varchar](20) NULL,
	[Checklist Completed By] [varchar](1000) NULL,
	[Checklist Rejection Reason] [varchar](5000) NULL,
	[ChangeIdentifier] [int] NOT NULL

CONSTRAINT [PK__CrewmobilisationChecklist__ChecklistID] PRIMARY KEY CLUSTERED 
(
	[Checklist ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO