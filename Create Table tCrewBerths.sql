CREATE TABLE [ShipMgmt_Crewing].[tCrewBerths](

	[Berth ID] [varchar](20) NOT NULL,
	[Berth Sequence] [int] NULL,
	[Berth Nationality ID] [varchar](20) NULL,
	[Berth Nationality] [varchar](200) NULL,
	[Nationality Type ID] [varchar](20) NULL,
	[Nationality Type] [varchar](200) NULL,
	[Berth Rank ID] [varchar](20) NULL,
	[Berth Rank] [varchar](200) NULL,
	[Berth is Safe Manning] [bit] NULL,
	[Berth Valid From] [datetime] NULL,
	[Berth Valid To] [datetime] NULL,
	[Berth Type ID] [varchar](20) NULL,
	[Berth Type] [varchar](200) NULL,
	[Berth Updated On] [datetime] NULL,
	[Berth Updated By ID] [varchar](20) NULL,
	[Berth Updated By] [varchar](200) NULL,
	[Berth Reason] [varchar](2000) NULL,
	[Berth Use NAN Process] [bit] NULL,
	[Manning Factor] [decimal] (10,2) NULL,
	[Length Of Contract] [int] NULL,
	[Length Of Contract Unit] [varchar](20) NULL,
	[Leave Duration] [int] NULL,
	[Leave Duration Unit] [varchar](20) NULL,
	[Reliever Not Required] [bit] NULL,
	[ChangeIdentifier] [int] NOT NULL
	

CONSTRAINT [PK__CrewBerths__BerthID] PRIMARY KEY CLUSTERED 
(
	[Berth ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO