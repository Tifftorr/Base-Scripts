USE [vgroup-onedata-preview]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ShipMgmt_Crewing].[tCrewClientRetention] (

	[Date Key] [int] NOT NULL,
	[Client ID] [varchar] (20) NULL,
	[Client] [varchar] (500) NULL,
	[Type] [int] NULL,
	[Average Employees 2] [int] NULL,
	[Average Employees] [int] NULL,
	[Total Terminations] [int] NULL,
	[Beneficial Terminations] [int] NULL,
	[Unavoidable Terminations] [int] NULL,
	[Left Client] [int] NULL,
	[Client Retention] [decimal](5, 2) NULL,
	[Group Retention] [decimal](5, 2) NULL,
	[Retention Month] [varchar](100) NULL,
	[Rank Category ID] [varchar](20) NULL,
	[Rank Category] [varchar](100) NULL,
	[Current Month]  [bit] NULL

CONSTRAINT [PK__tCrewClientRetention__DateKey_ClientID_Type_RankCategoryID] PRIMARY KEY CLUSTERED 
(
	[Date Key] ASC,
	[Client ID] ASC,
	[Type] ASC,
	[Rank Category ID] ASC
) WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO