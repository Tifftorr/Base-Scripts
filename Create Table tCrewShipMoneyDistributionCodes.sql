USE [vgroup-onedata-preview]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ShipMgmt_Crewing].[tCrewShipMoneyDistributionCodes] (

	[CUSTOMERID] [varchar](50) NOT NULL,
	[LAST4] [varchar](20) NULL,
	[FIRSTNAME] [varchar](200) NULL,
	[LASTNAME] [varchar](200) NULL,
	[IDTYPE] [int] NULL,
	[IDVALUE] [varchar](200) NULL,
	[EID] [varchar](100) NULL,
	[SUBCOMPANY] [varchar](100) NULL,
	[REGISTRATIONDATE] [datetime] NULL,
	[STATUS] [varchar](50) NULL,
	[BALANCE] [int] NULL,
	[ACTIVATIONDATE] [datetime] NULL


CONSTRAINT [PK__CrewshipMoneyDistributionCodes] PRIMARY KEY CLUSTERED 
(
	[CUSTOMERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO