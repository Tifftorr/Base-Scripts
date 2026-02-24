USE [vgroup-onedata-preview]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE[ShipMgmt_Crewing].[tCrewTrainingDeliveryMode] (

	[Document ID] [varchar](20) NOT NULL,
	[Document Name] [varchar](2000) NULL,
	[Document Type] [varchar](100) NULL,
	[Delivery] [varchar](100) NULL,
	[Training Hours] [int] NULL,
	[Average Cost (USD)] [int] NULL

CONSTRAINT [PK__CrewTrainingDeliveryMode] PRIMARY KEY CLUSTERED 
(
	[Document ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
