select com.ves_id, 
v.VES_IMOnumber [IMO], v.VES_Name [Vessel Name],
comt.cty_name as [Type], com.COM_Number as [Number/Email], com.COM_PrimaryContact [Primary], com.com_desc [Comments], com.COM_Provider [Provider],
com.COM_StartDate [Start Date], com.COM_ExpiryDate [Expiry Date]


from [dbo].[VESCOMMUN] com
left join  [dbo].[COMMUNTYPE] comt on comt.cty_id = com.CTY_ID 
left join [dbo].[VESSEL] v on v.VES_ID = com.VES_ID



select * from [dbo].[COMMUNTYPE]

select * from [dbo].[VESSEL]