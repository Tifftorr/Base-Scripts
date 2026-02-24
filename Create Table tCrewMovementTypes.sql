CREATE TABLE [ShipMgmt_Crewing].[tCrewMovementTypes](

	[Status ID] [varchar](20) NOT NULL,
	[Status] [varchar] (200) NULL,
	[Status Sequence] [int] NULL,
	[Status Short Code] [varchar] (200) NULL,
	[Status Valid Supernumerary] [bit] NULL,
	[Status Valid Crew] [bit] NULL,
	[Status Valid Applicant] [bit] NULL,
	[Status Ashore] [bit] NULL,
	[Status Onboard] [bit] NULL,
	[Status Valid Sick] [bit] NULL,
	[Status Valid Previous] [bit] NULL,
	[Status Valid Reemployment] [bit] NULL,
	[Status Valid Search] [bit] NULL,
	[Status Pay Rate] [bit] NULL,
	[Status Leave Accrued] [bit] NULL,
	[Status Pay Multiplier] [bit] NULL,
	[Status Leave Multiplier] [bit] NULL,
	[Status Is Taxable] [bit] NULL,
	[Status Subject Employers NI] [bit] NULL,
	[Status Subject Employees NI] [bit] NULL,
	[Status Subject Employers Pension] [bit] NULL,
	[Status Subject Employees Pension] [bit] NULL,
	[Status Subject Trade Union Deductions] [bit] NULL,
	[Status Client Recoverable] [bit] NULL,
	[Status Active] [bit] NULL,
	[Status Updated By] [varchar] (200) NULL,
	[Status Updated On] [datetime] NULL,
	[Status Restricted Status] [bit] NULL,
	[Status Service Event] [bit] NULL,
	[Status Friendly Name] [varchar] (200) NULL,
	[Status Planning Applicable] [bit] NULL

CONSTRAINT [PK__CrewBerths__StatusID] PRIMARY KEY CLUSTERED 
(
	[Status ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO