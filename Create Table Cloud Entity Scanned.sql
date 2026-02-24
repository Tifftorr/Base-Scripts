USE [vgroup-onedata-preview]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ShipMgmt_Crewing].[tCrewCloudEntityScanned](
	[Cloud Entity Scanned ID] [varchar](20) NOT NULL,
	[FK Matched ID] [varchar](20) NULL,
	[Cloud Documents Extension ID] [varchar](20) NULL,
	[Sequence] [int] NULL,
	[File Name] [varchar](500) NULL,
	[Linked Description] [varchar](1000) NULL,
	[File Size] [int] NULL,
	[Reference 2 ID] [varchar](20) NULL,
	[Reference 2 Description] [varchar](100) NULL,
	[Cloud Status] [varchar](200) NULL,
	[Scanned Office ID] [varchar](20) NULL,
	[Updated By] [varchar](200) NULL,
	[Updated On] [datetime] NULL,
	[Created By] [varchar](20) NULL,
	[Created On] [datetime] NULL,
	[Vessel ID] [varchar](20) NULL,
	[Crew ID] [varchar](20) NULL,
	[CMP ID] [varchar](20) NULL,
	[Coy ID] [varchar](20) NULL,
	[Budget ID] [varchar](20) NULL

CONSTRAINT [PK__CrewCloudEntityScanned] PRIMARY KEY CLUSTERED 
(
	[Cloud Entity Scanned ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO