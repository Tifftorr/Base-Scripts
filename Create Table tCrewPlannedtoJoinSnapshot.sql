USE [vgroup-onedata-preview]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ShipMgmt_Crewing].[tCrewPlannedtoJoinSnapshot] (
	[Date] [date] NOT NULL,
	[Crew ID] [varchar] (20) NOT NULL,
	[Service Record ID] [varchar] (20) NOT NULL,
	[Planning Status] [varchar] (100) NULL,
	[Rank ID] [varchar] (20) NOT NULL,
	[Start Date] [datetime] NULL,
	[End Date] [datetime] NULL,
	[Rank] [varchar] (200) NULL,
	[Rank Sequence] [varchar] (200) NULL,
	[Rank Category] [varchar] (200) NULL,
	[Rank Department] [varchar] (200) NULL,
	[Is the service done outside of V.Ships] [varchar] (20) NULL,
	[Planned Vessel ID] [varchar] (20) NULL,
	[Planned Vessel] [varchar] (200) NULL,
	[Planned Vessel Mgmt ID] [varchar] (20) NULL,
	[Planned Vessel Fleet] [varchar] (100) NULL,
	[Planned Vessel Client] [varchar] (500) NULL,
	[Planned Vessel Mgmt Type] [varchar] (100) NULL,
	[Planned Vessel Segment] [varchar] (50) NULL,
	[Planned Vessel Type] [varchar] (100) NULL,
	[Planned Vessel General Type Group] [varchar] (100) NULL,
	[Planned Vessel Technical Office] [varchar] (100) NULL,
	[Sea Days] [int],
	[Order of future services] [int],
	[Lineup ID Joiner] [varchar] (20) NULL,
	[Line Up Description] [varchar] (1000) NULL,
	[Line Up Created On] [datetime]

CONSTRAINT [PK__CrewPlannedtoJoinSnapshot__Date_ServiceRecordID] PRIMARY KEY CLUSTERED 
(
	[Date] ASC,
	[Service Record ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

