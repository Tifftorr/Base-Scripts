Use shipsure
go

-----
  IF object_id('tempdb..#FINAL') IS NOT NULL  
  BEGIN  
   DROP TABLE #FINAL  
  END

   IF object_id('tempdb..#ALL') IS NOT NULL  
  BEGIN  
   DROP TABLE #ALL  
  END

   IF object_id('tempdb..#udfSSFTP_BUD_GetOperationalChartHierarchy') IS NOT NULL  
  BEGIN  
   DROP TABLE #udfSSFTP_BUD_GetOperationalChartHierarchy  
  END

     IF object_id('tempdb..#tblTemplate') IS NOT NULL  
  BEGIN  
   DROP TABLE #tblTemplate  
  END

     IF object_id('tempdb..#cte_tblTemplateRowNo') IS NOT NULL  
  BEGIN  
   DROP TABLE #cte_tblTemplateRowNo  
  END

       IF object_id('tempdb..#udfBUDGET_CrewCompelementForBudgetOption') IS NOT NULL  
  BEGIN  
   DROP TABLE #udfBUDGET_CrewCompelementForBudgetOption  
  END

IF object_id('tempdb..#tblCrewComplement') IS NOT NULL  
  BEGIN  
   DROP TABLE #tblCrewComplement  
  END

  IF object_id('tempdb..#tblTemplateAsPerCrewComplement') IS NOT NULL  
  BEGIN  
   DROP TABLE #tblTemplateAsPerCrewComplement  
  END

   IF object_id('tempdb..#tblOvertime') IS NOT NULL  
  BEGIN  
   DROP TABLE #tblOvertime  
  END

     IF object_id('tempdb..#tblFinal') IS NOT NULL  
  BEGIN  
   DROP TABLE #tblFinal  
  END

       IF object_id('tempdb..#ALL_WAGES') IS NOT NULL  
  BEGIN  
   DROP TABLE #ALL_WAGES  
  END

  
     IF object_id('tempdb..#FINALCRWTOTALPAY') IS NOT NULL  
  BEGIN  
   DROP TABLE #FINALCRWTOTALPAY  
  END

       IF object_id('tempdb..#ALL_WAGES_FINAL') IS NOT NULL  
  BEGIN  
   DROP TABLE #ALL_WAGES_FINAL  
  END

  
       IF object_id('tempdb..#GROUPED_WAGES') IS NOT NULL  
  BEGIN  
   DROP TABLE #GROUPED_WAGES  
  END

         IF object_id('tempdb..#PORTAGE') IS NOT NULL  
  BEGIN  
   DROP TABLE #PORTAGE  
  END

-----
DECLARE  @ViewId VARCHAR(12) = '501' 
DECLARE @AccountCode VARCHAR(12)  
DECLARE @Description VARCHAR(100) 
DECLARE @CTD_Seq INT
DECLARE @OverTimeHrsCtsCode VARCHAR(20) = 'OVERTIME_HOURS' -- do not change, used in PF  
DECLARE @OverLapCtsCode VARCHAR(20) = 'OVERLAP_PERCENTAGE' -- do not change, used in PF  
DECLARE @OvertimeRateCtsCode VARCHAR(20) = 'OVERTIME_RATE' -- do not change, used in PF  
DECLARE @AdditionalBonusCode VARCHAR(20) = 'ADDITIONAL_BONUS'  
DECLARE @ISRate_ExcludeFromAdditionalBonusCalculation BIT
DECLARE @OverLapCtsDesc VARCHAR(10) = 'OVERLAP'  
DECLARE @OvertimeDescription VARCHAR(20)='Overtime Hours'  
DECLARE @OverlapPercentageDesc VARCHAR(20)='Overlap (%)'  
DECLARE @OverTimeNBonusViewId VARCHAR(12)='5010200'  
DECLARE @OverTimeHrsCatingDept VARCHAR(6) = 'CATGAL'
-----
CREATE TABLE #FINAL
(
PeriodStartDate datetime,
PeriodEndDate datetime,
PCN VARCHAR(20),
Seafarer_Surname VARCHAR(180),
Seafarer_Forename VARCHAR(180),
NAT_ID VARCHAR(12),
START_DATE DATETIME,
END_DATE DATETIME,
SET_ID VARCHAR(12),
SVL_ID VARCHAR(12),
OB_Days_IN_PERIOD INT,
OB_Days INT,
TotalPay FLOAT,
VES_ID VARCHAR (12),
VESSEL VARCHAR(60),
rnk_id VARCHAR(60),
Rank VARCHAR(150),
Rank_SN1 VARCHAR(12),
RANK_CATEGORY VARCHAR(120),
Department VARCHAR(60),
BerthType VARCHAR(120),
Status VARCHAR(60),
LV INT,
OverlapDays int,
ContractLength VARCHAR(8)
)

Declare @Vessel VARCHAR(60)
SELECT  @Vessel = 'ALPINE MYSTERY'

Declare @Rank VARCHAR(60)
SELECT  @Rank = 'A/B'

Declare @StartDate datetime
SELECT  @StartDate = GETDATE()-360

Declare @EndDate datetime
--SELECT  @EndDate =GETDATE() 

print @startdate
print @enddate

Declare @MonthStartDate datetime
SELECT  @MonthStartDate = DATEADD(m, DATEDIFF(m, 0, @StartDate), 0)

WHILE @@FETCH_STATUS = 0 AND @MonthStartDate<=GETDATE()+360
BEGIN

INSERT INTO #FINAL
select distinct 
@MonthStartDate AS StartDate,
@EndDate As EndDate,
pds.crw_pid AS PCN,
PDs.CRW_SURNAME AS SEAFARER_SURNAME,
PDs.CRW_FORENAME AS SEAFARER_FORENAME,
PDS.NAT_ID,
sdr.SET_StartDate as START_DATE,
sdr.SET_EndDate as END_DATE,
SDR.SET_ID,
SDR.SVL_ID,
DATEDIFF(DAY, CASE WHEN sdr.SET_StartDate>@MonthStartDate then  sdr.SET_StartDate else @MonthStartDate  end, Case when sdr.SET_EndDate>@EndDate then @EndDate else sdr.SET_EndDate end ) +1 as OB_Days_IN_PERIOD,
DATEDIFF(DAY, sdr.SET_StartDate, sdr.SET_EndDate ) +1 as OB_Days,
CCD.CCD_TotaContractedlPay as TotalPay
,sdr.VES_ID,
v.ves_name as Vessel,
sdr.RNK_ID, --test
RNK.RNK_Description AS RANK,
Rank_SN1 = case  
when CCA_IsOfficer = 1 then '0' + cast(rnk.RNK_SequenceNumber as varchar(20))
when CCA_IsOfficer = 0 then '1' + cast(rnk.RNK_SequenceNumber as varchar(20))
end ,
CASE WHEN CCA.CCA_DESCRIPTION  = 'Petty Officers' THEN 'Non-Marine Ranks'
WHEN CCA.CCA_DESCRIPTION = 'OFFICERS' THEN 'Junior Officers'
WHEN CCA.CCA_DESCRIPTION = 'OTHER' THEN 'Non-Marine Ranks'
ELSE CCA.CCA_DESCRIPTION END AS RANK_CATEGORY,
dep.DEP_SHORTCODE as Department,
css.CSS_Description as BerthType
,case when sdr.SET_ActiveStatus=1 then 'Onboard' when SDR.SAS_ID=2 then 'Signed Off' else CSA.CSA_Description end  as Status
,DENSE_RANK() OVER (
						PARTITION BY @MonthStartDate, SDR.SVL_ID
						ORDER BY SDR.SET_STARTDATE desc, SDR.SET_UpdatedOn DESC) LV
,NULL as OverlapDays
,CONVERT(VARCHAR(8),sdr.SET_ContDays ) as ContractLength

--into #FINAL
from shipsure.dbo.crwsrvdetail sdr (NOLOCK)
inner join shipsure.dbo.crwpersonaldetails pds (NOLOCK) on pds.crw_id=sdr.crw_id
inner JOIN  shipsure.dbo.CRWRANKS RNK (NOLOCK) ON (RNK.RNK_ID = SDr.RNK_ID) --or rnk.rnk_equivalentrank = SDr.RNK_ID) --test
inner JOIN	 shipsure.dbo.CRWRANKCATEGORY CCA (NOLOCK) ON RNK.CCA_ID = CCA.CCA_ID
left join shipsure.dbo.department dep (NOLOCK) on dep.dep_id=rnk.dep_id
INNER JOIN Shipsure..CRWAssignedStatus CSA (NOLOCK) ON CSA.CSA_ID=sdr.CSA_ID
	outer apply ( Select top (1) CCD_TotaContractedlPay
					from Shipsure..CRWContractDetails (NOLOCK) CNT
					where cnt.SET_ID = sdr.SET_ID
					and cnt.CCD_Cancelled = 0
					order by cnt.CCD_UpdatedOn desc
	) CCD

--INNER JOIN Shipsure..CRWContractDetails CCD (NOLOCK) ON CCD.SET_ID=SDR.SET_ID AND CCD.CCD_CANCELLED=0
INNER JOIN SHIPSURE.dbo.vessel v (NOLOCK) on v.ves_id=sdr.VES_ID
LEFT JOIN   shipsure.dbo.CRWCLVESCREWLIST BGL (NOLOCK) ON SDR.SVL_ID = BGL.SVL_ID
LEFT JOIN   shipsure.dbo.CRWServiceStatus CSS (NOLOCK) ON BGL.CSS_ID = CSS.CSS_ID
where sdr.SET_Cancelled = 0
AND		sdr.SET_PreviousExp = 0
AND		pds.CRW_Cancelled=0
AND		RNK.RNK_VALIDSUPN = 0
--AND		(sdr.SAS_ID not in (3,0)  or sdr.sas_id = NULL)
AND (SDR.SAS_ID IN (1,2) OR (sdr.SAS_ID =3 AND SDR.CSA_ID IN ('VSHP00000002','VSHP00000004')))
AND		sdr.STS_ID in ('OB','OV')
AND (
(CAST(SDR.SET_StartDate AS date)<=@EndDate and CAST(SDR.SET_EndDate AS date)>=@MonthStartDate) ---Joined not later than period end and signed off not earlier than period start
OR 			(CAST(SDR.SET_StartDate AS date)<=@EndDate AND sdr.SET_ActiveStatus=1 and DATEADD(day,15,sdr.SET_EndDate)>=@MonthStartDate) --Joined before period end are still onboard or overdue)
)
--AND sdr.set_activestatus = 1
--AND @EndDate>=@MonthStartDate
AND		SDr.SET_StartDate < SDr.SET_EndDate
and ves_name=@Vessel and rnk_description=@Rank --test to be removed
	--and crw_pid='OSGX00001115'
--drop table #tmpcrw


		
	SET @MonthStartDate=DATEADD(MONTH,1,@MonthStartDate)
	SET @EndDate= EOMONTH(@MonthStartDate)
	END

	--final select for crew removing all overlaps
	select * 
	into #FINALCRWTOTALPAY
	from #FINAL
	where LV = 1

	--select * from #FINALCRWTOTALPAY 


---start

 SELECT    
   bo.BUD_ID, 
   bo.BUD_OverlapOfficers,   
   bo.BUD_OverlapRatings,   
   bo.BUD_AdditionalCateringHrs,   
   bo.BUD_AdditionalRatingHrs,   
   bo.WAT_ID,  
   bo.BUD_BudgetSpecification,  
  bo.CHH_ID 
  INTO #ALL
 FROM BUDGET_BidRequests br    
 INNER JOIN BUDGET_BudgetOptions bo   ON br.BID_ID = bo.BID_ID 
 INNER JOIN BUDGETHDR BGH ON BGH.BGH_ID=bo.BGH_ID
 WHERE BGH_YEAR = 2024--Datepart(year,getdate()) 

---start
BEGIN
Select xx.Template_ID, xx.Chd_Description, xx.AccountCode, xx.Chd_Level, xx.IsPosting, xx.Tree, xx.ParentAccountCode, xx.SortOrder, xx.BudgetViewName , xx.CHH_ID
into #udfSSFTP_BUD_GetOperationalChartHierarchy 
	from( 

 SELECT chd.CHH_ID as HeaderID, chd.CHD_ID as Template_ID, chd.ACC_ID as AccountCode, chd.CHD_Parent as ParentAccountCode, UPPER(chd.CHD_Desc) as Chd_Description, 
 CAST((CASE WHEN chd.CHD_Posting = 'p' THEN '1' ELSE '0'END) AS BIT) as IsPosting,   
 chd.CHD_Seq as SortOrder, chd.CHD_Level as Chd_Level, '' as Tree, NULL as CTD_InvType, 
 ~ISNULL(chd.CHD_Inactive, 0) IsActive, CHD_BudgetViewName as  BudgetViewName,chd.CHH_ID as CHH_ID

 
  FROM CHARTDET chd  
  WHERE chd.CHH_ID in (SELECT CHH_ID FROM #ALL)  
  AND chd.CHD_Posting = 'P'   
  AND chd.CHD_Budget = 1  
  AND chd.CHD_Inactive = 0

  UNION ALL

   SELECT child.CHH_ID, child.CHD_ID, child.ACC_ID, child.CHD_Parent, UPPER(child.CHD_Desc),   
    CAST((CASE WHEN child.CHD_Posting ='p' THEN '1' ELSE '0'END) AS BIT), child.CHD_Seq, child.CHD_Level,  
    '',  
    NULL, ~ISNULL(child.CHD_Inactive, 0), CHD_BudgetViewName  ,child.CHH_ID
  
  FROM CHARTDET AS child  
  INNER JOIN ( 
		  SELECT chd.CHH_ID as HeaderID, chd.CHD_ID as Template_ID, chd.ACC_ID as AccountCode, chd.CHD_Parent as ParentAccountCode, UPPER(chd.CHD_Desc) as Chd_Description, 
		 CAST((CASE WHEN chd.CHD_Posting = 'p' THEN '1' ELSE '0'END) AS BIT) as IsPosting,   
		 chd.CHD_Seq as SortOrder, chd.CHD_Level as Chd_Level, '' as Tree, NULL as CTD_InvType, 
		 ~ISNULL(chd.CHD_Inactive, 0) IsActive, CHD_BudgetViewName as  BudgetViewName,chd.CHH_ID as CHH_ID

 
		  FROM CHARTDET chd  
		  WHERE chd.CHH_ID in (SELECT CHH_ID FROM #ALL)  
		  AND chd.CHD_Posting = 'P'   
		  AND chd.CHD_Budget = 1  
		  AND chd.CHD_Inactive = 0 ) AS parent ON parent.ParentAccountCode = child.ACC_ID  
  WHERE child.CHH_ID  IN (SELECT CHH_ID FROM #ALL)
    AND child.CHD_Posting <> 'P' ) xx

WHERE xx.ParentAccountCode <> '0' ORDER BY SortOrder  
  
END 

CREATE TABLE #tblTemplate  
  (  
   AutoID INT IDENTITY(1,1),  
   RowNo INT,  
   CTD_ID VARCHAR(12),  
   CTS_ID VARCHAR(14),  
   AccountCode VARCHAR(12),  
   CTD_ViewID VARCHAR(12),  
   CTD_Description VARCHAR(100),  
   CTS_Description VARCHAR(500),  
   CTD_Seq INT,  
   CTS_SequenceNo DECIMAL(18,2),  
   IsTemplateIncluded BIT,  
   BCB_Id VARCHAR(12),  
   CTS_ExcludeInAdditionalBonusCalculation BIT,  
   CTS_Code varchar(50),  
   CTS_IsAfterOverlapPercentage BIT ,
   BUD_ID VARCHAR(12),
   CHH_ID VARCHAR(12)
  )   

   INSERT INTO #tblTemplate 
   (CTD_Description, AccountCode, CTS_ID, CTS_Description, CTS_SequenceNo, CTS_IsAfterOverlapPercentage, CTS_Code,BUD_ID, CHH_ID)  
   (SELECT DISTINCT hie.Chd_Description, hie.AccountCode, t.CTS_ID, t.CTS_Name, t.CTS_SequenceNo, t.CCO_IsAfterOverlapPercentage, t.CTS_Code  ,t.BUD_ID,t.CHH_ID
  FROM #udfSSFTP_BUD_GetOperationalChartHierarchy hie    
  LEFT JOIN   
	  (  
	   SELECT distinct cc.ACC_ID, cts.CTS_Name, cc.CTS_ID, COALESCE(cc.CCO_SortOrder, cts.CTS_SequenceNo) AS CTS_SequenceNo, cc.CCO_IsAfterOverlapPercentage, cts.CTS_Code  ,cc.BUD_ID, cc.CHH_ID
	   FROM BUDGET_Crew_Cost cc   
	   INNER JOIN BUDGET_ChartTemplate_CostSplitUp cts ON cc.CTS_ID = cts.CTS_ID  
	   INNER JOIN #ALL AA ON AA.BUD_ID=cc.BUD_ID AND cc.CHH_ID=AA.CHH_ID
	   WHERE  
		ISNULL(cts.CTS_IsActive,1) = 1   
	   AND ISNULL(cc.ISActive,1) = 1  
	  ) t ON t.ACC_ID = hie.AccountCode   AND t.CHH_ID=hie.CHH_ID
  WHERE hie.ParentAccountCode = @ViewId  
 )
  SELECT @AccountCode = AccountCode FROM #tblTemplate WHERE Cts_Code = @OverTimeRateCtsCode 
;

--WITH cte_tblTemplateRowNo AS   
 --(  
  
  SELECT AutoID, ROW_NUMBER() OVER (ORDER BY CTS_IsAfterOverlapPercentage) AS RowNo
  into #cte_tblTemplateRowNo
  FROM #tblTemplate  
 --) 

 UPDATE tmp   
 SET RowNo = cte.RowNo  
 FROM #tblTemplate tmp  
 INNER JOIN #cte_tblTemplateRowNo cte ON cte.AutoID = tmp.AutoID  
 /*
  SELECT @MaxSequenceNo = MAX(ISNULL(CTS_SequenceNo, 0)) FROM #tblTemplate WHERE ISNULL(CTS_IsAfterOverlapPercentage,0) = 0  
   
 IF (@MaxSequenceNo = 0)  
 BEGIN  
  UPDATE #tblTemplate SET CTS_SequenceNo = RowNo + 100  
 END  */
 --select * from #tblTemplate order by CTS_IsAfterOverlapPercentage  

       SELECT BUD_ID, bcc.BCC_ID, 
	   -- to align those ranks where equivalent
	   case 
			when bcc.RNK_ID = 'VSHP00000072' then 'VSHP00000073'
			when bcc.RNK_ID = 'VSHP00000077' then 'VSHP00000076'
			when bcc.RNK_ID = 'VSHP00000079' then 'VSHP00000078'
			when bcc.rnk_id = 'VSHP00000087' then 'VSHP00000053'
		else bcc.RNK_ID end as rnk_id

	   , rnk.RNK_Description, rnk.RNK_ShortCode, bcc.NAT_ID, nat.NAT_Description, bcc.BCC_ContractLength, bcc.PSY_ID, psy.PSY_Year, 
               cca.CCA_ID, cca.CCA_IsOfficer, cca.CCA_IsSenOfficer, rnk.DEP_ID, cca.CCA_SequenceNumber, rnk.RNK_SequenceNumber
        INTO #udfBUDGET_CrewCompelementForBudgetOption
        FROM BUDGET_CRWComplement bcc
        INNER JOIN CRWRanks rnk ON (bcc.RNK_ID = rnk.RNK_ID) --or bcc.rnk_id = rnk.rnk_equivalentrank) --test
        INNER JOIN CRWRankCategory cca ON rnk.CCA_ID = cca.CCA_ID
        INNER JOIN NATIONALITY nat ON  bcc.NAT_ID = nat.NAT_ID
        INNER JOIN CRWPayScaleYear psy ON  bcc.PSY_ID = psy.PSY_ID

CREATE TABLE #tblCrewComplement  
  (  
   BUD_ID VARCHAR(12),
   BCC_ID VARCHAR(12),  
   RNK_ID VARCHAR(12),  
   RNK_Description VARCHAR(255),  
   RNK_ShortCode VARCHAR(15),  
   RNK_ShortName VARCHAR(50),  
   NAT_ID VARCHAR(6),  
   NAT_Description VARCHAR(50),  
   BCC_ContractLength INT,  
   PSY_ID VARCHAR(12),  
   PSY_Year VARCHAR(25),  
   CCA_IsOfficer BIT,  
   IsCateringCrew BIT,  
   RNK_SequenceNumber BIGINT,  
   ActualAssumptionCost DECIMAL(18, 2),  
   WageScaleAssumptionCost DECIMAL(18, 2)  
  )  

  INSERT INTO #tblCrewComplement (BUD_ID,BCC_ID, RNK_ID, RNK_Description, NAT_ID, NAT_Description, BCC_ContractLength, PSY_ID, PSY_Year, CCA_IsOfficer, IsCateringCrew, RNK_SequenceNumber, RNK_ShortCode, RNK_ShortName)  
 (  
  SELECT cc.BUD_ID,cc.BCC_ID, cc.RNK_ID, cc.RNK_Description, cc.NAT_ID, cc.NAT_Description, cc.BCC_ContractLength, cc.PSY_ID, cc.PSY_Year, cc.CCA_IsOfficer, 
  CASE WHEN cc.DEP_ID = @OverTimeHrsCatingDept THEN 1 ELSE 0 END, cc.RNK_SequenceNumber, cr.RNK_ShortCode, cr.RNK_ShortName  
  FROM #udfBUDGET_CrewCompelementForBudgetOption cc  
  INNER JOIN CRWRanks cr ON cr.RNK_ID = cc.RNK_ID  
  INNER JOIN #ALL AA ON AA.BUD_ID=cc.BUD_ID
 )
 
  CREATE TABLE #tblTemplateAsPerCrewComplement  
  (  
   BUD_ID VARCHAR(12),
   BCC_ID VARCHAR(12),  
   RNK_ID VARCHAR(12),  
   RNK_Description VARCHAR(255),  
   RNK_ShortCode VARCHAR(15),  
   RNK_ShortName VARCHAR(50),  
   NAT_ID VARCHAR(6),  
   NAT_Description VARCHAR(50),  
   BCC_ContractLength INT,  
   PSY_ID VARCHAR(12),  
   PSY_Year VARCHAR(25),  
   CCA_IsOfficer BIT,  
   CTD_ID VARCHAR(12),  
   CTS_ID VARCHAR(14),  
   AccountCode VARCHAR(12),  
   CTD_ViewID VARCHAR(12),  
   CTD_Description VARCHAR(100),  
   CTS_Description VARCHAR(100),  
   CTD_Seq INT,  
   CTS_SequenceNo DECIMAL(18,2),  
   IsCateringCrew BIT,  
   RNK_SequenceNumber BIGINT,  
   IsTemplateIncluded BIT,  
   BCB_Id varchar(12),  
   CTS_ExcludeInAdditionalBonusCalculation BIT,  
   CTS_Code varchar(50),  
   CTS_IsAfterOverlapPercentage BIT  
  ) 

  INSERT INTO #tblTemplateAsPerCrewComplement (BUD_ID,BCC_ID, RNK_ID, RNK_Description, RNK_ShortCode, RNK_ShortName, NAT_ID, NAT_Description, BCC_ContractLength
 , PSY_ID, PSY_Year, CCA_IsOfficer, CTD_ID, CTD_Description, AccountCode, CTD_ViewID, CTS_ID, CTS_Description, CTD_Seq
 , CTS_SequenceNo,IsCateringCrew, RNK_SequenceNumber, IsTemplateIncluded, BCB_Id, CTS_ExcludeInAdditionalBonusCalculation, CTS_Code, CTS_IsAfterOverlapPercentage)  
 (  
  SELECT 
	cc.BUD_ID,cc.BCC_ID, cc.RNK_ID, cc.RNK_Description, cc.RNK_ShortCode, cc.RNK_ShortName, cc.NAT_ID, cc.NAT_Description, cc.BCC_ContractLength
	, cc.PSY_ID, cc.PSY_Year, cc.CCA_IsOfficer, tmp.CTD_ID, tmp.CTD_Description, tmp.AccountCode, tmp.CTD_ViewID, tmp.CTS_ID
	, tmp.CTS_Description, tmp.CTD_Seq, tmp.CTS_SequenceNo, cc.IsCateringCrew, cc.RNK_SequenceNumber, tmp.IsTemplateIncluded,tmp.BCB_Id
	, tmp.CTS_ExcludeInAdditionalBonusCalculation,tmp.CTS_Code,tmp.CTS_IsAfterOverlapPercentage  
  FROM #tblCrewComplement cc  
  CROSS JOIN #tblTemplate tmp  
 ) 

  CREATE TABLE #tblOvertime  
  (  
   AutoID INT IDENTITY(1,1),  
   CWO_ID VARCHAR(12),  
   BCC_ID VARCHAR(12),  
   CTS_ID VARCHAR(14),  
   CtsDescription VARCHAR(50),  
   Cost DECIMAL(18, 2),  
   CtsCode VARCHAR(20),  
   IsTemplateIncluded BIT DEFAULT(1)  
  )

 INSERT INTO #tblOvertime (CWO_ID, BCC_ID, CTS_ID, CtsDescription, Cost, CtsCode)  
 (  
  SELECT ac.CWO_ID, cc.BCC_ID, @OverTimeHrsCtsCode AS CTS_ID, @OvertimeDescription, 
  CASE WHEN ac.BCC_ID IS NOT NULL THEN ac.CWO_OvertimeHours ELSE (CASE WHEN rnk.RNK_ID IS NOT NULL THEN BUD_AdditionalCateringHrs WHEN ISNULL(cc.CCA_IsOfficer,0) <> 1 THEN 
BUD_AdditionalRatingHrs ELSE NULL END) END, @OverTimeHrsCtsCode  
  FROM #tblCrewComplement cc  
  INNER JOIN Budget_CrewWages_AdditionalCost ac ON cc.BCC_ID = ac.BCC_ID  
  INNER JOIN #ALL AA ON AA.BUD_ID=cc.BUD_ID
  LEFT OUTER JOIN CRWRanks rnk ON cc.RNK_ID = rnk.RNK_ID AND rnk.DEP_ID = @OverTimeHrsCatingDept   
  WHERE EXISTS (SELECT 1 FROM #tblTemplate WHERE CTS_Code = 'OVERTIME_RATE')
  UNION   
  SELECT ac.cwo_id, cc.bcc_id, @OverLapCtsDesc, @OverlapPercentageDesc, 
  CASE WHEN ac.BCC_ID IS NOT NULL THEN ac.CWO_OverlapPercentage ELSE (CASE WHEN cc.CCA_IsOfficer = 1 THEN BUD_OverlapOfficers ELSE BUD_OverlapRatings END) END,   
      @OverLapCtsCode  
  FROM #tblCrewComplement cc  
  INNER JOIN #ALL AA ON AA.BUD_ID=cc.BUD_ID
  LEFT OUTER JOIN Budget_CrewWages_AdditionalCost ac ON cc.BCC_ID = ac.BCC_ID  
 )  

 CREATE TABLE #tblFinal  
  (  
   BUD_ID VARCHAR(12),
   BCC_Id VARCHAR(12),  
   Rnk_Id VARCHAR(12),  
   RNK_Description VARCHAR(255),  
   NAT_ID VARCHAR(12),  
   NAT_Description VARCHAR(50),  
   BCC_ContractLength INT,  
   PSY_ID VARCHAR(12),  
   PSY_Year VARCHAR(25),  
   AccountCode VARCHAR(12),  
   CTS_ID VARCHAR(14),  
   CTD_Description VARCHAR(100),  
   CTS_Description VARCHAR(100),  
   CCO_ID VARCHAR(12),  
   CCO_Cost DECIMAL(18, 2),  
   CTS_SequenceNo DECIMAL(18,2),  
   CTD_Seq INT,  
   IsOfficer BIT,  
   IsCateringCrew BIT,  
   RNK_SequenceNumber BIGINT,  
   IsTemplateIncluded BIT,  
   IsSplitUpApplicableForCBA BIT,  
   IsNationalityApplicable BIT,  
   IsAlreadyExsistsInDatabase BIT,  
   CTS_ExcludeInAdditionalBonusCalculation BIT,  
   CTS_Code varchar(50),  
   CTS_IsAfterOverlapPercentage BIT,  
   CCO_Remarks varchar(500),  
   RNK_ShortCode VARCHAR(15),  
   RNK_ShortName VARCHAR(50)  
  )  
 
 INSERT INTO #tblFinal (BUD_ID, BCC_Id, Rnk_Id, RNK_Description,RNK_ShortCode, RNK_ShortName , RNK_SequenceNumber, NAT_ID, NAT_Description, BCC_ContractLength
 , PSY_ID, PSY_Year, AccountCode, CTS_ID, CTD_Description, CTS_Description, CCO_ID, CCO_Cost, CTD_Seq, CTS_SequenceNo, IsOfficer, IsCateringCrew
 , IsTemplateIncluded, IsSplitUpApplicableForCBA, IsNationalityApplicable, IsAlreadyExsistsInDatabase, CTS_ExcludeInAdditionalBonusCalculation,CTS_Code
 ,CTS_IsAfterOverlapPercentage, CCO_Remarks)
 (  
	SELECT  
	cc.BUD_ID,	cc.BCC_ID, cc.RNK_ID, cc.RNK_Description, cc.RNK_ShortCode, cc.RNK_ShortName, cc.RNK_SequenceNumber
		, cc.NAT_ID, cc.NAT_Description, cc.BCC_ContractLength, cc.PSY_ID, cc.PSY_Year, cc.AccountCode
		, cc.CTS_ID, cc.CTD_Description, cc.CTS_Description, bco.CCO_ID, bco.CCO_Cost, cc.CTD_Seq
		, cc.CTS_SequenceNo, cc.CCA_IsOfficer, cc.IsCateringCrew, cc.IsTemplateIncluded
		, CASE WHEN 
				ISNULL(cc.BCB_ID,'') <> '' 
				THEN 1 
				ELSE 0 
			END IsSplitUpApplicableForCBA
		, CASE WHEN  
				ISNULL(bcn.BCN_ID,'') <> '' 
			THEN 1 
			ELSE 0 
		END IsNationalityApplicable
		, CASE WHEN 
				bco.CCO_ID IS NOT NULL 
			THEN 1 
			ELSE 0 
		END AS IsAlreadyExsistsInDatabase
		, cc.CTS_ExcludeInAdditionalBonusCalculation,cc.CTS_Code
		, cc.CTS_IsAfterOverlapPercentage
		,bco.CCO_Remarks  
	FROM 
		#tblTemplateAsPerCrewComplement cc 
	--	LEFT JOIN #ALL AA ON AA.BUD_ID=cc.BUD_ID
		LEFT OUTER JOIN BUDGET_Crew_Cost bco ON bco.BCC_ID = cc.BCC_ID 
												AND bco.BUD_ID = cc.BUD_ID 
												AND bco.CTS_ID = cc.CTS_ID 
												AND ISNULL(bco.ISActive,1) = 1  
		LEFT OUTER JOIN BUDGET_CBA_CostSplitUp_Nationality_Mapping bcn on cc.BCB_ID = bcn.BCB_ID and cc.NAT_ID = bcn.NAT_ID  
 )  

 SELECT TOP 1 @ISRate_ExcludeFromAdditionalBonusCalculation = CTS_ExcludeInAdditionalBonusCalculation
 FROM BUDGET_ChartTemplate_CostSplitUp WHERE CTS_Code = @OvertimeRateCtsCode AND ISNULL(CTS_IsActive,1)=1  
 


  INSERT INTO #tblFinal (BCC_Id, Rnk_Id, RNK_Description, RNK_ShortCode, RNK_ShortName, RNK_SequenceNumber, NAT_ID, NAT_Description, BCC_ContractLength, PSY_ID, PSY_Year, AccountCode, CTS_ID, CTD_Description, CTS_Description, CCO_ID, CCO_Cost, CTD_Seq, CTS_SequenceNo,  
   IsOfficer, IsCateringCrew, IsTemplateIncluded, IsSplitUpApplicableForCBA, IsNationalityApplicable, IsAlreadyExsistsInDatabase,  
         CTS_ExcludeInAdditionalBonusCalculation, CTS_Code)  
 (  
  SELECT tf.BCC_Id, tf.Rnk_Id, tf.RNK_Description, tf.RNK_ShortCode, tf.RNK_ShortName, tf.RNK_SequenceNumber, tf.NAT_ID, tf.NAT_Description, tf.BCC_ContractLength, tf.PSY_ID, tf.PSY_Year,
  @AccountCode, ot.CTS_ID,
  @Description, ot.CtsDescription, ot.CWO_ID
, ot.Cost, @CTD_Seq,   
  --(CASE WHEN ot.CtsCode = @OverTimeHrsCtsCode THEN ISNULL(@MaxSequenceNo,0) - 0.02     WHEN ot.CtsCode = @OverLapCtsCode THEN ISNULL(@MaxSequenceNo,0) + 0.04 END)
  1 AS CTS_SequenceNo,   
  tf.CCA_IsOfficer, tf.IsCateringCrew, ot.IsTemplateIncluded, 1, 1, 1, @ISRate_ExcludeFromAdditionalBonusCalculation, ot.CtsCode  
  FROM #tblCrewComplement tf  
  INNER JOIN #tblOvertime ot ON tf.BCC_Id = ot.BCC_ID  
 )  
 --Remove extra splitups which are not required  
 DELETE FROM #tblFinal WHERE CTS_ID NOT IN (SELECT CTS_ID FROM #tblFinal WHERE IsAlreadyExsistsInDatabase = 1 OR IsNationalityApplicable = 1)  
  
 ---- Update cost for   
 UPDATE #tblFinal   
  SET CCO_Cost = 0  
 WHERE IsAlreadyExsistsInDatabase = 0 AND IsNationalityApplicable = 0   

 Update FA  
 SET
 BUD_ID=FF.BUD_ID
 FROM #tblFinal FA
 INNER JOIN #tblFinal FF ON FF.BCC_Id=FA.BCC_Id
 where FA.BUD_ID IS NULL

  SELECT distinct
  'Wages' as Wages,
 --Case  WHEN CTS_ID='OVERLAP' THEN 'Overlap' else 'Other Wages' end as WageType,
  BGH.VES_ID,
  VES_Name AS VESSEL,
  COY_ID,
  2023 BGH_YEAR,
  FF.BUD_ID, BCC_ID, FF.Rnk_Id,FF.RNK_Description, 
  NAT_ID, NAT_Description, BCC_ContractLength, PSY_ID, PSY_Year, 
 CCO_Cost, CTS_Code, CTS_IsAfterOverlapPercentage, CCO_Remarks  
 INTO #ALL_WAGES
  FROM #tblFinal  FF
  LEFT JOIN BUDGET_BudgetOptions BR ON BR.BUD_ID= FF.BUD_ID
  LEFT JOIN BUDGETHDR BGH ON BGH.BGH_ID=BR.BGH_ID  
  LEFT JOIN VESSEL V ON V.VES_ID=BGH.VES_ID
WHERE (( BGH_YEAR = Datepart(year,getdate())   OR BGH_Year is null OR BGH_Year=2024) and CTS_ID!='OVERLAP')
--and bgh.ves_id = 'MUMB00013311'

  SELECT distinct
  'BUDGETED' as Wages,
 --Case  WHEN CTS_ID='OVERLAP' THEN 'Overlap' else 'Other Wages' end as WageType,
  VES_ID,
  VESSEL,
  COY_ID,
  BGH_YEAR,
  BUD_ID, BCC_ID, Rnk_Id,
  NAT_ID, NAT_Description, BCC_ContractLength, PSY_ID, PSY_Year, 
 SUM( ISNULL(CCO_Cost,0) )AS CCO_Cost--, CTS_Code, CTS_IsAfterOverlapPercentage, CCO_Remarks  
  INTO #ALL_WAGES_FINAL 
  FROM #ALL_WAGES AA
  --where ves_id = 'MUMB00013311'
  GROUP BY 
  VES_ID,
  VESSEL ,
  COY_ID,
  BGH_YEAR,
  BUD_ID, BCC_ID, Rnk_Id, NAT_ID, NAT_Description, BCC_ContractLength, PSY_ID, PSY_Year
 -- CCA_IsOfficer

CREATE TABLE #GROUPED_WAGES (
 WAGES VARCHAR(20),
 VES_ID VARCHAR(12),
 VESSEL VARCHAR(70),
 COY_ID VARCHAR(20),
 BGH_YEAR VARCHAR(8),
 BUD_ID VARCHAR(12),
 BCC_ID VARCHAR(12),
 RNK_ID VARCHAR(12),
 NAT_ID VARCHAR(12),
 NAT_DESCRIPTION VARCHAR(80),
 BCC_ContractLength INT,
 PSY_ID VARCHAR(12),
 PSY_YEAR VARCHAR(8),
 CCO_COST FLOAT,
 PeriodStartDate Datetime,
 PeriodEndDate Datetime,
 Overlap_Percentage Float,
 Overlap FLOAT,
 RNK_DESCRIPTION VARCHAR(60),
 Rank_SN1 VARCHAR(20),
 RANK_CATEGORY VARCHAR(120),
 LV INT
 )


Declare @StartDateWages datetime
SELECT  @StartDateWages =  GETDATE()-360

Declare @EndDateWages datetime
--SELECT  @EndDate =GETDATE() 


Declare @MonthStartDateWages datetime
SELECT  @MonthStartDateWages = DATEADD(m, DATEDIFF(m, 0, @StartDateWages), 0)

WHILE @@FETCH_STATUS = 0 AND @MonthStartDateWages<=GETDATE()+720
BEGIN

 INSERT INTO #GROUPED_WAGES
 SELECT AW.*,
@MonthStartDateWages AS PeriodStartDate,
@EndDateWages As PeriodEndDate,
 FF.CCO_Cost as Overlap_Percentage,
CAST( (AW.CCO_Cost *FF.CCO_Cost) as float)/100 as Overlap,
 RNK.RNK_Description, 
  Rank_SN1 = case  
  when CCA_IsOfficer = 1 then '0' + cast(ff.RNK_SequenceNumber as varchar(20))
  when CCA_IsOfficer = 0 then '1' + cast(ff.RNK_SequenceNumber as varchar(20)) end ,
  CASE WHEN CCA.CCA_DESCRIPTION  = 'Petty Officers' THEN 'Non-Marine Ranks'
  WHEN CCA.CCA_DESCRIPTION = 'OFFICERS' THEN 'Junior Officers'
  WHEN CCA.CCA_DESCRIPTION = 'OTHER' THEN 'Non-Marine Ranks'
  ELSE CCA.CCA_DESCRIPTION END AS RANK_CATEGORY 
  ,DENSE_RANK() OVER (
									PARTITION BY AW.BGH_YEAR,AW.VES_ID,AW.BUD_ID, AW.RNK_ID
									ORDER BY AW.cco_cost desc) LV 
								--	SELECT * FROM  #GROUPED_WAGES
									
  FROM #ALL_WAGES_FINAL AW
 LEFT JOIN #tblFinal FF ON FF.BCC_Id= AW.BCC_Id and FF.CTS_ID='OVERLAP'
 inner JOIN  shipsure.dbo.CRWRANKS RNK (NOLOCK) ON RNK.RNK_ID = AW.RNK_ID -- or rnk.rnk_equivalentrank = aw.rnk_id)
  inner JOIN	 shipsure.dbo.CRWRANKCATEGORY CCA (NOLOCK) ON RNK.CCA_ID = CCA.CCA_ID
 where VESSEL=@Vessel and  RNK.RNK_Description=@Rank --test to be removed


	
	SET @MonthStartDateWages=DATEADD(MONTH,1,@MonthStartDateWages)
	SET @EndDateWages= EOMONTH(@MonthStartDateWages)
	END

--portage
SELECT DISTINCT TH.SET_ID, CAST(PAY_PeriodStartDate as date) as PAY_PeriodStartDate , CAST(PAY_PeriodEndDate as date) as  PAY_PeriodEndDate,SUM(PT.PPO_Value) AS WAGES_1 
INTO #PORTAGE
FROM PRLPeriodTranHeader TH (NOLOCK) 
INNER JOIN PRLPeriod PP ON PP.PAY_ID = TH.PAY_ID --and CAST(PAY_PeriodStartDate as date)=cast(PeriodStartDate as date) AND cast(PAY_PeriodEndDate as date)=cast(PeriodEndDate as date)
INNER JOIN PRLPeriodTran2 PT (NOLOCK) ON PT.PPC_ID = TH.PPC_ID  AND PPO_Cancelled = 0 
INNER JOIN CRWPayScaleItemNames PS ON PS.PSN_ID = PT.PSN_ID AND PSN_Deduction = 0
where PPC_Cancelled = 0 --and PAY_CurrentMonth=1
and PAY_PeriodStartDate >= GETDATE()-360
GROUP BY TH.SET_ID, PAY_PeriodStartDate, PAY_PeriodEndDate

	--Select * from #GROUPED_WAGES

-- final select
	Select  distinct GW.Wages, COALESCE(GW.VES_ID,CE.VES_ID) AS VES_ID, COALESCE(GW.VESSEL, CE.vESSEL) AS VESSEL, GW.COY_ID, GW.BGH_Year,GW.BUD_ID, coalesce(ce.rnk_id, gw.rnk_id) as rnk_id, /*GW.BCC_Id,*/ --coalesce(gw.rnk_id, ce.rnk_id) as rnk_id, 
	GW.NAT_ID, GW.NAT_Description,GW.BCC_ContractLength,GW.CCO_Cost, GW.Overlap_Percentage, GW.Overlap,
	coalesce(CE.Rank, gw.RNK_DESCRIPTION) AS [Rank], COALESCE(CE.Rank_SN1,GW.Rank_SN1) as Rank_SN1, COALESCE(CE.RANK_CATEGORY,GW.RANK_CATEGORY) AS RANK_CATEGORY,
	COALESCE(CE.PeriodStartDate,GW.PeriodStartDate) AS PeriodStartDate, COALESCE(CE.PeriodEndDate,GW.PeriodEndDate) AS PeriodEndDate, 
	CE.SVL_ID, CE.Department, ISNULL(CE.BerthType,'Budgeted') as BerthType, CE.OVERLAPDAYS as OVERLAPDAYS, GW.Overlap as OverlapPay, CE.TotalPay as PayRate, PP.WAGES_1 as PORTAGE_WAGES
		
		--into #finalcombined
		from #GROUPED_WAGES GW
		FULL JOIN #FINALCRWTOTALPAY CE ON CE.VES_ID=GW.VES_ID AND CE.RNK_ID = GW.RNK_ID and GW.LV=CE.LV AND GW.Wages=CE.BerthType AND GW.PeriodStartDate=CE.PeriodStartDate
		LEFT JOIN #PORTAGE PP ON PP.SET_ID=CE.SET_ID AND PP.PAY_PeriodStartDate=CE.PeriodStartDate and PP.PAY_PeriodEndDate=CE.PeriodEndDate
		
