CREATE TABLE [ShipMgmt_Crewing].[tCrewAppDocuments](

	[Row ID] [varchar](20) NOT NULL,
	[Inserted On] [date] NULL,
	[Crew ID] [varchar](20) NULL,
	[Rank ID] [varchar](20) NULL,
	[Rank] [varchar](200) NULL,
	[Rank Category] [varchar](100) NULL,
	[Nationality] [varchar](100) NULL,
	[Mobilisation Office ID] [varchar](20) NULL,
	[Technical Office ID] [varchar](20) NULL,
	[Technical Office] [varchar](100) NULL,
	[Client ID] [varchar](20) NULL,
	[Client] [varchar](1000) NULL,
	[Planning Cell ID] [varchar](20) NULL,
	[Planning Cell] [varchar](100) NULL,
	[Mobilisation Cell ID] [varchar](20) NULL,
	[Mobilisation Cell] [varchar](100) NULL,
	[Current Status] [varchar](100) NULL,
	[Vessel ID Final] [varchar](20) NULL,
	[Vessel Name Final] [varchar](100) NULL,
	[Vessel Type Final] [varchar](200) NULL,
	[Sector Final] [varchar](20) NULL,
	[Management Type Final] [varchar](100) NULL,
	[Attachment ID] [varchar](20) NULL,
	[Uploaded By ID] [varchar](20) NULL,
	[Uploaded By] [varchar](200) NULL,
	[Uploaded On] [datetime] NULL,
	[Uploaded by Unit] [varchar](60) NULL,
	[Document Description] [varchar](500) NULL,
	[File Name] [varchar](50) NULL,
	[Document ID] [varchar](20) NULL,
	[Document Name] [varchar](500) NULL,
	[Comments] [varchar](1000) NULL,
	[Document Status] [varchar](50) NULL,
	[Crew Employment Type ID]  [varchar](20) NULL,
	[Crew Employment Type] [varchar](50) NULL,
	[Document Issued Country ID] [varchar](20) NULL,
	[Document Scope] [varchar](20) NULL,
	[ChangeIdentifier] [int] NOT NULL


CONSTRAINT [PK__CrewAppDocuments__RowID] PRIMARY KEY CLUSTERED 
(
	[Row ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO