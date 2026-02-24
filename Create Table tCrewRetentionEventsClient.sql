CREATE TABLE [ShipMgmt_Crewing].[tCrewRetentionEventsClient] (

[Service Record ID Event] [varchar] (20) NOT NULL,
[Crew ID] [varchar] (20) NULL,
[Client Impacted] [varchar] (20) NULL,
[Gap Between Client in Days] [int] NULL,
[End Date] [datetime] NULL,
[New Client] [varchar] (20) NULL,
[New Client Start Date] [datetime] NULL,
[DateKey] [int] NULL

CONSTRAINT [PK__tCrewRetentionEventsClient__ServiceRecordIDEvent_EndDate] PRIMARY KEY CLUSTERED 
(
	[Service Record ID Event] ASC,
	[End Date] ASC
) WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO