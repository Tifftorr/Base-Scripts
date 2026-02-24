CREATE TABLE [ShipMgmt_Crewing].[tCrewTrainingNeed](

	[Training Need ID] [varchar](20) NOT NULL,
	[Crew ID] [varchar](20) NULL,
	[Status ID] [varchar](20) NULL,
	[Status] [varchar](100) NULL,
	[Course Recommended] [varchar](1500) NULL,
	[Training Need Raised By] [varchar](1000) NULL,
	[Training Need Raised On] [datetime] NULL,
	[Training Need Schedule Training Date] [datetime] NULL,
	[Training Need Actual Training Date] [datetime] NULL,
	[Mobilisation Office ID] [varchar](20) NULL,
	[Service Record ID] [varchar](20) NULL,
	[Crew Manager User ID] [varchar](20) NULL,
	[Crew Manager] [varchar](1000) NULL,
	[Training Need Created By ID] [varchar](20) NULL,
	[Training Need Created By] [varchar](1000) NULL,
	[Training Need Created On] [datetime] NULL,
	[Training Need Updated By ID] [varchar](20) NULL,
	[Training Need Updated By] [varchar](1000) NULL,
	[Training Need Updated On] [datetime] NULL,
	[Course ID] [varchar](20) NULL,
	[Course Description] [varchar](1500) NULL,
	[Is Mandatory Requirement] [bit] NULL,
	[Training Need Name] [varchar](1500) NULL,
	[Training Need Comments] [varchar](5000) NULL,
	[Appraisal ID] [varchar](20) NULL,
	[Is Added by Vessel] [bit] NULL,
	[ChangeIdentifier] [int] NOT NULL

CONSTRAINT [PK__CrewTrainingNeed__TrainingNeedID] PRIMARY KEY CLUSTERED 
(
	[Training Need ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO