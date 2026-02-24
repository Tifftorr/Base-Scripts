CREATE TABLE [ShipMgmt_Crewing].[tCrewRecruitmentScorecard](

	[Record Inserted On] [datetime] NOT NULL,
	[Recruitment Cell ID] [varchar] (20) NOT NULL,
	[Recruitment Cell] [varchar] (100) NULL,
	[Endorsed Candidates] [int] NULL,
	[Approved Candidates] [int] NULL,
	[New Hired Officers Compliant with CRW16] [int] NULL,
	[New Hired Officers] [int] NULL,
	[New Hires Processed Via Recruitment Tracking] [int] NULL,
	[New Hired Seafarers] [int] NULL,
	[Urgent Approved Candidates Before Start Date] [int] NULL,
	[Urgent Recruitment Requests] [int] NULL,
	[Non Urgent Approved Candidates Before Start Date] [int] NULL,
	[Non Urgent Recruitment Request] [int] NULL,
	[New Hired Officers Who Passed Assessment] [int] NULL,
	[New Hired Officers Who Has Taken The Assessment] [int] NULL,
	[New Hired Officers Compliant with CRW16 TPA] [int] NULL,
	[New Hired Officers TPA] [int] NULL,
	[Approved Seafarers] [int] NULL,
	[Joined Seafarers] [int] NULL

CONSTRAINT [PK__CrewRecruitmentScorecard__RecruitmentCellID] PRIMARY KEY CLUSTERED 
(
	[Recruitment Cell ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO