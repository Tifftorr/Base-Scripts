CREATE TABLE [ShipMgmt_Crewing].[tCrewDOCPolicyAttachments](

	[Attachment ID] [varchar] (20) NOT NULL,
	[FK Document ID] [varchar] (20) NULL,
	[Attachment File Name] [varchar] (200) NULL,
	[Attachment Description] [varchar] (1000) NULL,
	[Cloud Status] [bit] NULL,
	[Updated By ID] [varchar] (20) NULL,
	[Updated By] [varchar] (200) NULL,
	[Updated On] [datetime] NULL,
	[Attachment Created By ID] [varchar] (20) NULL,
	[Attachment Created By] [varchar] (200) NULL,
	[Linked Vessel ID] [varchar] (20) NULL,
	[Crew ID] [varchar] (20) NULL

CONSTRAINT [PK__CrewDOCPolicyAttachments__CrewPolicyAttachmentID] PRIMARY KEY CLUSTERED 
(
	[Attachment ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO