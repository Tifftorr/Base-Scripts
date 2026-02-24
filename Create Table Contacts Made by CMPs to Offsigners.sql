USE [vgroup-onedata-preview]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE[ShipMgmt_Crewing].[tCrewContactsMadebyCMPsToOffsignersSnapshot] (
			[Date] DATE NOT NULL, 
			[Crew ID] [varchar](20) NOT NULL,
			[PCN] [varchar](20) NULL,
			[Service Record ID] [varchar](20) NOT NULL,
			[Crew Surname] [varchar](100) NULL,
			[Crew Forename] [varchar](100) NULL,
			[Crew Movement Status] [varchar](100) NULL,
			[Nationality] [varchar](100) NULL ,
			[Country Of Nationality] [varchar](100) NULL,
			[Activity Date] [datetime] NOT NULL,
			[Start Date] [datetime] NOT NULL,
			[End Date] [datetime] NOT NULL,
			[Crew Rank] [varchar](100) NULL,
			[Load Port] [varchar](100) NULL ,
			[Load Port Country] [varchar](100) NULL,
			[Vessel ID] [varchar](20) NULL,
			[Vessel Name] [varchar](100) NULL ,
			[Mobilisation Cell] [varchar](200) NULL,
			[Planning Cell] [varchar](200) NULL,
			[CMP Cell] [varchar](100) NULL,
			[SignOff Reason] [varchar](100) NULL,
			[Action] [varchar](50) NULL,
			[Rank] [varchar](100) NULL,
			[Rank Category] [varchar](100) NULL,
			[Rank Department] [varchar](50) NULL,
			[Vessel Mgmt Type] [varchar](100) NULL,
			[Technical Office] [varchar](200) NULL,
			[Sector] [varchar](50) NULL,
			[Client] [varchar](300) NULL,
			[Contract Type] [varchar](100) NULL,
			[# of Contacts Made by CMP] [int] NULL,
			[Row Number] [int] NULL,
			[To Delete] [bit] NULL

CONSTRAINT [PK__CrewContactsMadebyCMPsToOffsignersSnapshot_ServiceRecordID_Date] PRIMARY KEY CLUSTERED 
(
	[Date] ASC,
	[Service Record ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO