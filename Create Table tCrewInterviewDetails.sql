CREATE TABLE [ShipMgmt_Crewing].[tCrewInterviewDetails](

	[Interview ID] [varchar] (20) NOT NULL,
	[Crew ID] [varchar] (20) NULL,
	[Interviewer] [varchar] (200) NULL,
	[Interview Date] [datetime] NOT NULL,
	[Interview Outcome] [varchar] (50) NULL,
	[Reasons for Decision] [varchar] (5000) NULL,
	[Remarks] [varchar] (5000) NULL,
	[Interview Created On] [datetime] NULL,
	[Interview Created By ID] [varchar] (20) NULL,
	[Interview Created By] [varchar] (200) NULL,
	[Interview Updated On] [datetime] NULL,
	[Interview Updated By ID] [varchar] (20) NULL,
	[Interview Updated By] [varchar] (200) NULL,
	[Vessel Name] [varchar] (200) NULL,
	[Interview for Rank ID] [varchar] (20) NULL,
	[Interviewer Position] [varchar] (200) NULL,
	[Interview Type] [varchar] (50) NULL,
	[Interview Rejection Reason] [varchar] (200) NULL

CONSTRAINT [PK__CrewRecruitmentScorecard__InterviewID] PRIMARY KEY CLUSTERED 
(
	[Interview ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO