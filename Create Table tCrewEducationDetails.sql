USE [vgroup-onedata-preview]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ShipMgmt_Crewing].[tCrewEducationDetails](
	[Crew Education ID] [varchar](20) NOT NULL,
	[Crew ID] [varchar](20) NOT NULL,
	[Crew Education Level] [varchar](1000) NULL,
	[Institute Name] [varchar](1000) NULL,
	[City of College] [varchar](1000) NULL,
	[Country of College] [varchar](20) NULL,
	[Graduation Date] [datetime] NULL,
	[Start Date] [datetime] NULL,
	[Education Specialty] [varchar](1000) NULL,
	[Graduation Score] [varchar](200) NULL,
	[Partner Institute ID] [varchar](50) NULL

CONSTRAINT [PK__CrewEducationDetails] PRIMARY KEY CLUSTERED 
(
	[Crew Education ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO