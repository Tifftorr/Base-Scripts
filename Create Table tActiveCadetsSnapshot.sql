USE [vgroup-onedata-preview]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ShipMgmt_Crewing].[tActiveCadetsSnapshot](

	[Date] [datetime] NOT NULL,
	[Crew ID] [varchar](20) NOT NULL,
	[Current Service Record ID] [varchar](20) NULL,
	[Rank ID] [varchar](20) NULL,
	[Berth ID] [varchar](20) NULL,
	[Planning Service Record ID] [varchar](20) NULL,
	[Supply Type] [varchar](100) NULL,
	[Third Party Agent] [varchar](200) NULL,
	[Pool Status] [varchar](100) NULL,
	[Mobilisation Cell ID] [varchar](20) NULL,
	[Recruitment Cell ID][varchar](20) NULL,
	[Planning Cell ID] [varchar](20) NULL,
	[CMP Cell ID] [varchar](20) NULL,
	[Is Ready For Promotion] [varchar](20) NULL,
	[Current Status] [varchar](100) NULL,
	[Current Status Start Date] [datetime] NULL,
	[Current Status End Date] [datetime] NULL,
	[Availability] [datetime] NULL,
	[Actual Service Days] [int] NULL,
	[Current Service Days] [int] NULL,
	[Contract Days] [int] NULL,
	[Contract Unit] [varchar](10) NULL,
	[Extension] [int] NULL,
	[Extension Unit] [varchar](10) NULL,
	[Contract End Date] [datetime] NULL,
	[Current Vessel ID] [varchar](20) NULL,
	[Planned Vessel ID] [varchar](20) NULL,
	[Plan To Join] [datetime] NULL,
	[Planning Status] [varchar](200) NULL,
	[Last Contact Date] [datetime] NULL,
	[Last Vessel ID] [varchar](20) NULL,
	[Last Vessel Sign On Date] [datetime] NULL,
	[Last Vessel Sign Off Date] [datetime] NULL,
	[V.Ships Contracts] [int] NULL,
	[Fleet] [varchar](200) NULL,
	[Vessel Mgmt ID] [varchar](20) NULL,
	[Vessel ID Final] [varchar](20) NULL,
	[Assessed Promotion Record ID] [varchar](20) NULL,
	[Approved Promotion Record ID] [varchar](20) NULL,
	[Crew Pool Status] [varchar](20) NULL,
	[Row Number] [int] NULL,
	[Recruiter Name] [varchar](200) NULL,
	[Recruiter Office] [varchar](200) NULL,
	[To Delete] [int] NULL
 CONSTRAINT [PK__ActiveCadetsSnapshot] PRIMARY KEY CLUSTERED 
(
	[Date] ASC,
	[Crew ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO