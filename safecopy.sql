<--Step 2.1-->
SELECT ja.JobApply_ID AS ID
  ,ja.JobApply_Candidate_SFID AS Candidate_SFID
  ,ja.JobApply_Email_Address AS Email_Address
  ,ja.JobApply_First_Name AS First_Name
  ,ja.JobApply_Last_Name AS Last_Name
  ,ja.JobApply_Phone_Area_Code AS Phone_Area_Code
  ,ja.JobApply_Phone_Number AS Phone_Number
  ,ja.JobApply_Phone_Extension AS Phone_Extension
  ,ja.JobApply_Address_1 AS Address_1
  ,ja.JobApply_Address_2 AS Address_2
  ,ja.JobApply_City AS City
  ,ja.JobApply_State AS STATE
  ,ja.JobApply_Postal_Code AS Postal_Code
  ,ja.JobApply_Country_Short_Code AS Country_Short_Code
  ,ja.JobApply_Candidate_Resume_URL AS Candidate_Resume_URL
  ,ja.JobApply_Job_Order_SFID AS Job_Order_SFID
  ,ja.JobApply_Job_Order_Number AS Job_Order_Number
  ,ja.JobApply_Job_Detail_URL AS Job_Detail_URL
  ,ja.JobApply_Current_Job_Function_Name AS Current_Job_Function_Name
  ,ja.JobApply_Current_LOB_Name AS Current_LOB_Name
  ,ja.JobApply_Partner_Candidate_ID AS Partner_Candidate_ID
  ,ja.JobApply_Partner_Name AS Partner_Name
  ,ja.JobApply_Partner_Event_Type AS Partner_Event_Type
  ,ja.JobApply_Locale AS Locale
  ,ja.JobApply_Locator_Key AS Locator_Key
  ,ja.JobApply_Candidate_RHUID AS Candidate_RHUID
  ,ja.JobApply_Candidate_Archive_JSON_Key AS Candidate_Archive_JSON_Key
  ,ja.JobApply_Candidate_Last_Modified_Date AS Candidate_Last_Modified_Date
  ,ja.MC_Created_Date
  ,jo.SF_Job_Order_ID
  ,jo.Job_Posting
  ,jo.LOB AS SF_LOB_ID
  ,jo.Service_Type
  ,jo.Job_Title
  ,jo.Company_Name
  ,jo.SF_Account_ID
  ,jo.Job_Function AS Job_Function_ID
  ,jo.Job_Function_Name

,test,test
  ,jo.Start_Date
  ,jo.End_Date
  ,jo.Branch_ID AS SF_Branch_ID
  ,jo.Branch_No
  ,jo.Branch_Name
  ,jo.Job_Status
  ,jo.SF_ET_ID AS SF_Event_ID
  ,jo.ET_Type AS Type
  ,jo.ET_Completed_Date AS Completed_Date
  ,jo.ET_Created_Date AS SF_Created_Date
  ,DateAdd(day,4,getdate()) AS EmailWave2
  ,jo.LOB_Name
  
FROM [LU_JobApply_Test] ja
INNER JOIN (
                SELECT jo1.*, et.SF_ET_ID, et.ET_Type, et.ET_Completed_Date, et.ET_Created_Date,lob.LOB_Name
                FROM ent.[NA_Job_Order] jo1
                INNER JOIN [NA_JobFill_Notification_ET_JO_test] et on jo1.SF_Job_Order_ID = et.SF_Job_Order_ID
                LEFT JOIN ent.[Global_Country] gc on jo1.country = gc.SF_Country_ID
                LEFT JOIN ent.[Global_Line_of_Business] lob on jo1.LOB = lob.SF_LOB_ID
                WHERE jo1.Placed_Candidate_ID is not null 
                AND (
                       (
                              jo1.Service_Type = 'Temp'
                              AND jo1.Job_Status = 'Active'
                       )
                       OR
                       (
                              jo1.Service_Type = 'Perm'
                              AND jo1.Job_Status = 'Booked'
                       )
                    )
                AND gc.Country_Alpha2_Code IN ('US','CA')
                AND lob.LOB_Name IN ('AT','OT','RHL','RHT','RHFA','RHMR','TCG')
           ) jo ON ja.JobApply_Job_Order_Number = jo.Job_Order_Number
<--Step 2.1-->

<--Step 3.1-->
SELECT jajo.ID
  ,jajo.Candidate_SFID
  ,jajo.Email_Address
  ,jajo.First_Name
  ,jajo.Last_Name
  ,jajo.Phone_Area_Code
  ,jajo.Phone_Number
  ,jajo.Phone_Extension
  ,jajo.Address_1
  ,jajo.Address_2
  ,jajo.City
  ,jajo.STATE
  ,jajo.Postal_Code
  ,jajo.Country_Short_Code
  ,jajo.Candidate_Resume_URL
  ,jajo.Job_Order_SFID
  ,jajo.Job_Order_Number
  ,jajo.Job_Detail_URL
  ,jajo.Current_Job_Function_Name
  ,jajo.Current_LOB_Name
  ,jajo.Partner_Candidate_ID
  ,jajo.Partner_Name
  ,jajo.Partner_Event_Type
  ,jajo.Locale
  ,jajo.Locator_Key
  ,jajo.Candidate_RHUID
  ,jajo.Candidate_Archive_JSON_Key
  ,jajo.Candidate_Last_Modified_Date
  ,jajo.MC_Created_Date
  ,jajo.SF_Job_Order_ID
  ,jajo.Job_Posting
  ,jajo.SF_LOB_ID
  ,jajo.Service_Type
  ,jajo.Job_Title
  ,jajo.Company_Name
  ,jajo.SF_Account_ID
  ,jajo.Job_Function_Name
  ,jajo.Start_Date
  ,jajo.End_Date
  ,jajo.SF_Branch_ID
  ,jajo.Branch_No
  ,jajo.Branch_Name
  ,jajo.Job_Status
  ,jajo.SF_Event_ID
  ,jajo.Type
  ,jajo.Completed_Date
  ,jajo.SF_Created_Date
  ,jajo.EmailWave2
  ,jajo.LOB_Name
  ,caco.SF_Contact_ID
  ,caco.People_Number AS People_No
  ,caco.Personal_Email AS Personal_Email
  ,caco.Country_of_Record AS SF_Country_ID
  ,caco.SMS_Unsubscribe
  ,caco.Country_Alpha2_Code
  ,CASE 
		WHEN jajo.Candidate_SFID IS NULL
			AND jajo.Email_Address NOT IN (
				SELECT ca.Personal_Email
				FROM ent.[NA_Candidate] ca
				)
			THEN 'Prospect'
		WHEN jajo.Candidate_SFID IS NOT NULL
			THEN 'Candidate'
		WHEN jajo.Candidate_SFID IS NULL
			AND jajo.Email_Address IN (
				SELECT ca.Personal_Email
				FROM ent.[NA_Candidate] ca
				)
			THEN 'Candidate'
		END AS Contact_Type

FROM [NA_JobFill_Notification_JA_JO_Test] jajo
LEFT JOIN (
          Select ca.SF_Contact_ID
                 ,ca.People_Number
                 ,ca.Personal_Email
                 ,ca.Country_of_Record
                 ,co.Country_Name
                 ,ca.SMS_Unsubscribe
                 ,co.Country_Alpha2_Code

                 FROM ent.[NA_Candidate] ca 
           Left Join ent.[Global_Country] co ON ca.Country_of_Record = co.SF_Country_ID
           Where co.Country_Alpha2_Code IN ('US','CA')
           ) caco on jajo.Candidate_SFID = caco.SF_Contact_ID

WHERE jajo.Job_Order_SFID NOT IN (
                                  Select jo.SF_Job_Order_ID FROM ent.[NA_Job_Order] jo
                                     WHERE 
                                            ( jo.Service_Type = 'Temp'
                                             AND jo.Job_Status = 'Active'
                                             AND CAST(jo.End_Date as Date) > Dateadd(day,14,getDate())
                                            )
                                         OR jo.Conversion = 'True'
                                  )
AND jajo.Candidate_SFID NOT IN (Select SF_Contact_ID FROM ent.[NA_LU_Candidate_Gen_Suppression])
<--Step 3.1-->

<--Step 4.1-->
SELECT 
     NewID() AS ZE_ID
	,jf.ID AS Campaign_Primary_Key
	,'NA_JobFill_Hourly_Test' AS Campaign_Name
	,jf.Locator_Key
	,jf.Job_Title
	,jo.Job_Description AS Content_Description
	,jf.City
	,jf.State
	,jf.Postal_Code
	,jf.Country_Short_Code
	,'ZE_Subscriber_ID' AS ZE_Subscriber_Contact_ID
	,GetDate() AS MC_Created_Date
FROM [NA_JobFill_Notification_Target_Hourly_Test] jf
Inner Join ent.[NA_Job_Order] jo on jf.Job_Order_Number = jo.Job_Order_Number
<--Step 4.1-->
