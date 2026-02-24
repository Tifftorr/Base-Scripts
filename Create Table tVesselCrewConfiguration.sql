USE [vgroup-onedata-preview]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE[ShipMgmt_Crewing].[tVesselCrewConfiguration] (

	[Vessel Crew Configuration ID]  [varchar](20) NOT NULL,
	[Vessel ID]  [varchar](20) NULL,
	[Level 1 Planning Horizon Weeks From] [int] NULL,
	[Level 1 Planning Horizon Weeks To] [int] NULL,
	[Level 2 Planning Horizon Weeks From] [int] NULL,
	[Level 2 Planning Horizon Weeks To] [int] NULL,
	[Level 3 Planning Horizon Weeks From] [int] NULL,
	[Level 3 Planning Horizon Weeks To] [int] NULL,
	[NAN Berth Specific] [bit] NULL,
	[Using NAN Process] [bit] NULL,
	[NAN Expiry Days] [int] NULL,
	[NAN Warning Flag Days] [int] NULL,
	[Vessel Crew Configuration Created On] [datetime] NULL,
	[Vessel Crew Configuration Updated By ID] [varchar](20) NULL,
	[Vessel Crew Configuration Updated By] [varchar](1000) NULL,
	[NAN Restricted] [bit] NULL,
	[POP Description] [varchar](200) NULL,
	[Consider for Optimizer] [bit] NULL,
	[Is Forward Planning Applicable] [bit] NULL,
	[Payscale Requirement Type] [varchar](100) NULL,
	[MGT] [varchar](100) NULL,
	[Is POEA Printing Enabled] [bit] NULL,
	[Is Debriefing Enabled] [bit] NULL,
	[Travel Days] [int] NULL,
	[Is Vessel OSA Required] [bit] NULL,
	[Is Fly2C Enabled] [bit] NULL,
	[Fly2C Vessel Name] [varchar](200) NULL,
	[Show CBA] [bit] NULL,
	[Is LOC Highlight Enabled] [bit] NULL,
	[Is Temporary Rank Enabled] [bit] NULL,
	[Is Personalized Wages Enabled] [bit] NULL,
	[Exclude TPA Enabled] [bit] NULL,
	[Signed Contract Mandatory Enabled] [bit] NULL,
	[Change OB End Date in Gantt View] [bit] NULL,
	[Allow Same Day Planning for Reliever] [bit] NULL,
	[CBA Mandatory] [bit] NULL,
	[Contract Attachment Mandatory] [bit] NULL,
	[APS Validated Crew] [bit] NULL,
	[Reuse Personalized Wage Scale Enabled] [bit] NULL,
	[Personalized Wage Scale Threshold (Months)] [int] NULL,
	[Travel Cluster ID] [varchar] (20) NULL,
	[Travel Cluster] [varchar] (200) NULL,
	[Travel PIC ID] [varchar] (20) NULL,
	[Travel PIC] [varchar] (200) NULL,
	[Is Budgeted Berth Mob Cell Restricted] [bit] NULL,
	[Crew Change Skip Pre-Join Checks] [bit] NULL,
	[Crew Change Show Replan] [bit] NULL,
	[Crew Change Back to Back Crew] [bit] NULL,
	[Crew Change Add Travel Days] [bit] NULL,
	[Crew Change Auto Create Lineup] [bit] NULL,
	[Travel Target Cost (USD)] [int] NULL,
	[RN] [int] NOT NULL

CONSTRAINT [PK__VesselCrewConfiguration] PRIMARY KEY CLUSTERED 
(
	[Vessel Crew Configuration ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO