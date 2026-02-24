CREATE TABLE [ShipMgmt_Crewing].[tCrewDOCPolicy](
	[Crew ID] [varchar] (20) NOT NULL,
	[Crew Policy Assignment ID] [varchar] (20) NULL,
	[Service Record ID] [varchar] (20) NULL,
	[Policy Name] [varchar] (200) NULL,
	[Crew Policy Detail ID] [varchar] (20) NULL,
	[Crew Policy Assignment Created By ID] [varchar] (20) NULL,
	[Crew Policy Assignment Created By] [varchar] (200) NULL,
	[Crew Policy Assignment Created On] [datetime] NULL,
	[Crew Policy Agreed On] [datetime] NULL,
	[Crew Policy Agreed From IP] [varchar] (100) NULL,
	[Crew Policy Assigned On] [datetime] NULL,
	[Is Policy Agreed] [bit] NULL

CONSTRAINT [PK__CrewDOCPolicy__CrewPolicyDetailID] PRIMARY KEY CLUSTERED 
(
	[Crew Policy Detail ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO