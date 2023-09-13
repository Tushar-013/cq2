/*
  ** Author Name : ----
  ** Description : Write a controller for create task when part is created
  ** Class name : PartTriggerController it is use in Trigger is PartTrigger and test class is PartTriggerControllerTest
*/

public class PartTriggerController 
{
    public static void CreateTaskRecord(List<compliancequest__SQX_Part__c> partList)
    {
        Date mydate = Date.today();
        List<Task> taskList = new List<Task>();
        for(compliancequest__SQX_Part__c pr:partList)
        {
            Task ts = new Task();
            ts.WhatId = pr.Id;
            ts.Subject = 'Review Part -' + pr.compliancequest__Part_Number__c;
            ts.OwnerId = pr.CreatedById;
            ts.Status = 'Not Started';
            ts.ActivityDate = mydate.addDays(7);
            taskList.add(ts);
        }
        if(!taskList.isEmpty())
        {
            insert taskList;
        }
    }
}