CREATE TABLE [ShipMgmt_Crewing].[tCrewMobilisationScorecard] (

	[Date] [datetime] NOT NULL,
	[Mobilisation Cell ID] [varchar] (20) NOT NULL,
	[Mobilisation Cell] [varchar] (200) NULL,
	[Training Needs Completed] [int] NULL,
	[Total Training Needs] [int] NULL,
	[Digital Checklist Signed Off] [int] NULL,
	[Digital Checklist Joiners] [int] NULL,
	[Documents Uploaded by Seafarer] [int] NULL,
	[Total Documents Uploaded] [int] NULL,
	[Ready Status Updated On Time] [int] NULL,
	[Mobilisation Reliability Joiners] [int] NULL,
	[Pre Joining Compliance Statutory Compliant Crew] [int] NULL,
	[Pre Joining Compliance Statutory Onboard Crew] [int] NULL,
	[Pre Joining Compliance VMS Compliant Crew] [int] NULL,
	[Pre Joining Compliance VMS Onboard Crew] [int] NULL,
	[Declaration of Compliance Signed Pre Joining] [int] NULL,
	[Crew Onboard Pre Joining Declaration of Compliance] [int] NULL,
	[Crew Approved To Join Accepted By Mobilisation On Time] [int] NULL,
	[Crew Approved To Join] [int] NULL,
	[Crew Debriefing Done On Time] [int] NULL,
	[Crew Debriefing Offsigners] [int] NULL,
	[Timely Relieved Ratings] [int] NULL,
	[Ratings Onboard] [int] NULL,
	[Crew With Appraisal Review Completion On Time] [int] NULL,
	[Crew Appraisal Offsigners] [int] NULL


CONSTRAINT [PK__tCrewLineUps__MobilisationCellID] PRIMARY KEY CLUSTERED 
(
	[Mobilisation Cell ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO