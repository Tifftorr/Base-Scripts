SELECT
	Datekey as [Date Key],
	[ClientID] as [Client ID],
	Client as [Client],
	[TYPE] as [Type],
	AE_2 as [Average Employees 2],
	AverageEmployees as [Average Employees],
	[TotalTerminations] as [Total Terminations],
	[BeneficialTerminations] as [Beneficial Terminations],
	[UnavoidableTerminations] as [Unavoidable Terminations],
	[Left_client] as [Left Client],
	RetentionClient as [Client Retention],
	RetentionGroup as [Group Retention],
	[RetentionMonth] as [Retention Month],
	[CCA_ID] as [Rank Category ID],
	[RankCategory] as [Rank Category],
	[CurrentMonth] as [Current Month]

FROM 
	aggregates.[dbo].[CREW_ClientRetention]