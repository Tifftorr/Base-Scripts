CREATE TABLE [ShipMgmt_Crewing].[tCrewComplianceTrends](

	[Row ID] [varchar] (20) NOT NULL,
	[Record Inserted On] [datetime] NULL,
	[Crew ID] [varchar](20) NULL,
	[PCN] [varchar](20) NULL,
	[Rank ID] [varchar](20) NULL,
	[Mobilisation Cell ID] [varchar](20) NULL,
	[Mobilisation Office ID] [varchar](20) NULL,
	[Planning Cell ID] [varchar](20) NULL,
	[Planning Office ID] [varchar](20) NULL,
	[Third Party Agency] [varchar](1000) NULL,
	[Crew Status] [varchar](100) NULL,
	[Service Record ID] [varchar](20) NULL,
	[Vessel Mgmt ID] [varchar](20) NULL,
	[Vessel ID] [varchar](20) NULL,
	[Vessel] [varchar](200) NULL,
	[Signed On Last 14 Days] [varchar](20) NULL,
	[Vessel In Scope CPI] [varchar](50) NULL,
	[Default Template] [varchar](20) NULL,
	[Training Type] [varchar](100) NULL,
	[Is Core] [varchar](20) NULL,
	[Template Requirement] [varchar](50) NULL,
	[Is Flag Document] [varchar](20) NULL,
	[Statutory Documents] [int] NULL,
	[Statutory Compliant Documents] [int] NULL,
	[Statutory Non Compliant Documents] [int] NULL,
	[Travel Documents] [int] NULL,
	[Travel Compliant Documents] [int] NULL,
	[Travel Non Compliant Documents] [int] NULL,
	[VMS Documents] [int] NULL,
	[VMS Compliant Documents] [int] NULL,
	[VMS Non Compliant Documents] [int] NULL,
	[Other Documents] [int] NULL,
	[Other Compliant Documents] [int] NULL,
	[Other Non Compliant Documents] [int] NULL,
	[Total Documents Count] [int] NULL,
	[Total Compliant Documents] [int] NULL,
	[Total Non Compliant Documents] [int] NULL,
	[CMP Cell ID] [varchar](20) NULL,
	[Course Color Category] [varchar](50) NULL,
	[ChangeIdentifier] [int] NOT NULL

CONSTRAINT [PK__CrewComplianceTrends__RowID] PRIMARY KEY CLUSTERED 
(
	[Row ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO