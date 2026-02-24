CREATE TABLE [ShipMgmt_Crewing].[tCrewExperienceSnapshot] (

[Row ID] [int] NOT NULL,
[Record Inserted On] [date] NOT NULL,
[Vessel ID] [varchar] (12) NULL,
[Department] [varchar] (100) NULL,
[Rank Category] [varchar] (60) NULL,
[Planning Status] [varchar] (20) NULL,
[Number of Crew] [int] NULL,
[Years in Chemical Tanker] [decimal] (5,2) NULL,
[Years in Dry Cargo] [decimal] (5,2) NULL,
[Years in Gas Tanker] [decimal] (5,2) NULL,
[Years in Oil Tanker] [decimal] (5,2) NULL,
[Years in Rank] [decimal] (5,2) NULL,
[Years in VMS] [decimal] (5,2) NULL,
[Experience Matrix Rockstar] [int] NOT NULL,
[Rank Compliance] [int] NOT NULL,
[Vessel Type Compliance] [int] NOT NULL,
[VMS Compliance] [int] NOT NULL,
[Requirement Type] [varchar] (100) NOT NULL,
[Oil Major Requirement in Rank] [decimal] (5,2) NULL,
[Oil Major Requirement in Operator] [decimal] (5,2) NULL,
[Oil Major Requirement in Vessel Type] [decimal] (5,2) NULL,
[Oil Major Requirement All Tankers] [decimal] (5,2) NULL,
[All Tankers Compliance] [int] NULL,
[Years in All Tankers] [decimal] (5,2) NULL

CONSTRAINT [PK__tCrewExperience__RecordInsertedOn_VesselID_Department_RankCategory_PlanningStatus_RequirementType] PRIMARY KEY CLUSTERED 
(
	[Record Inserted On] ASC,
	[Vessel ID] ASC,
	[Department] ASC,
	[Rank Category] ASC,
	[Planning Status] ASc,
	[Requirement Type] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO