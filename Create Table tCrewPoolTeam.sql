USE [vgroup-onedata-preview]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ShipMgmt_Crewing].[tCrewPoolTeam] (
	
	[Crew Pool Team ID] [varchar] (20) NOT NULL,
	[Crew Pool ID] [varchar] (20) NULL,
	[Crew Pool Description] [varchar] (200) NULL,
	[Crew Pool Type ID] [int] NULL,
	[Crew Pool Type] [varchar] (70) NULL,
	[Crew Pool Team User ID] [varchar] (20) NULL,
	[User Display Name] [varchar] (200) NULL,
	[User Email Address] [varchar] (300) NULL,
	[Cell Manager] [int] NULL,
	[Member Role ID] [int] NULL,
	[Member Role] [varchar] (200) NULL,
	[Default Cell] [int] NULL,
	[Display as Contact] [int] NULL

CONSTRAINT [PK__CrewPoolTeam__CrewPoolTeamID] PRIMARY KEY CLUSTERED 
(
	[Crew Pool Team ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO