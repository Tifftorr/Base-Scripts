CREATE TABLE [ShipMgmt_Crewing].[tCrewTravelDetails](
	
	[Travel Main ID] [varchar] (20) NOT NULL,
	[Crew ID] [varchar] (20) NULL,
	[Service Record ID] [varchar] (20) NULL,
	[Line Up ID] [varchar] (20) NULL,
	[Travel Type] [varchar] (50) NULL,
	[Booking Reference] [varchar] (50) NULL,
	[Booking Status] [varchar] (100) NULL,
	[Destination From] [varchar] (100) NULL,
	[Destination To] [varchar] (100) NULL,
	[Departure Date] [datetime] NULL,
	[Arrival Date] [datetime] NULL,
	[Travel Provider] [varchar] (100) NULL,
	[Updated On] [datetime] NOT NULL,
	[Updated By] [varchar] (200) NULL,
	[Flight Details] [varchar] (5000) NULL,


CONSTRAINT [PK__CrewTravelDetails__TravelMainID] PRIMARY KEY CLUSTERED 
(
	[Travel Main ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO