CREATE TABLE [ShipMgmt_Crewing].[tCrewAppraisalItemDetail](
	[Appraisal Item ID] [varchar] (20) NOT NULL,
	[Appraisal ID] [varchar] (20) NULL,
	[Appraisal Item Detail ID] [varchar] (20) NULL,
	[Appraisal Item Comments] [varchar] (2000) NULL,
	[Appraisal Item Created By ID] [varchar] (20) NULL,
	[Appraisal Item Created By] [varchar] (200) NULL,
	[Appraisal Item Created On] [datetime] NULL,
	[Appraisal Item Updated By ID] [varchar] (20) NULL,
	[Appraisal Item Updated By] [varchar] (200) NULL,
	[Appraisal Item Updated On] [datetime] NULL,
	[Appraisal Item Header ID] [varchar] (20) NULL,
	[Appraisal Scale ID] [varchar] (20) NULL,
	[Appraisal Scale Description] [varchar] (2000) NULL,
	[Appraisal Item Detail Is Training Required] [bit] NULL,
	[Appraisal Item Header Parent ID] [varchar] (20) NULL,
	[Appraisal Item Title] [varchar] (200) NULL,
	[Appraisal Item Description] [varchar] (2000) NULL,
	[Appraisal Item Sort Order] [int] NULL,
	[Appraisal Scale Result] [varchar] (100) NULL,
	[Appraisal Scale Value] [int] NULL,
	[ChangeIdentifier] [int] NOT NULL

CONSTRAINT [PK__CrewAppraisalItemDetail__AppraisalItemID] PRIMARY KEY CLUSTERED 
(
	[Appraisal Item ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO