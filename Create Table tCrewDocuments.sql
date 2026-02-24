CREATE TABLE [ShipMgmt_Crewing].[tCrewDocuments](

	[Crw Doc ID] [varchar] (20) NOT NULL,
	[Crew ID] [varchar](20) NULL,
	[Doc ID] [varchar](20) NULL,
	[Document Name] [varchar](500) NULL,
	[Doc Status ID] [varchar](20) NULL,
	[Doc Status] [varchar](200) NULL,
	[Doc Number] [varchar](200) NULL,
	[Doc Country] [varchar](20) NULL,
	[Issued On] [datetime] NULL,
	[Expiry] [datetime] NULL,
	[Comments] [varchar](2000) NULL,
	[Approved By] [varchar](500) NULL,
	[Doc Place] [varchar](500) NULL,
	[Superseded By] [varchar](500) NULL,
	[Is Primary Document] [bit] NULL,
	[Updated By ID] [varchar](20) NULL,
	[Updated By] [varchar](200) NULL,
	[Updated On] [datetime] NULL,
	[Reviewed By ID] [varchar](20) NULL,
	[Reviewed By] [varchar](200) NULL,
	[Reviewed On] [datetime] NULL,
	[Created On] [datetime] NULL,
	[Created By ID] [varchar](20) NULL,
	[Created By] [varchar](200) NULL,
	[ChangeIdentifier] [int] NOT NULL

CONSTRAINT [PK__CrewDocuments__CrwDocID] PRIMARY KEY CLUSTERED 
(
	[Crw Doc ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO