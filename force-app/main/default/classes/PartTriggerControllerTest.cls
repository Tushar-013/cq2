/*
  ** Author Name : ----
  ** Description : Write a Test class for PartTriggerController this controller.
  ** Class name : PartTriggerControllerTest it is use in Trigger is PartTrigger and Controller class is PartTriggerController.
*/

@isTest
public class PartTriggerControllerTest 
{
    @isTest
    public static void TestData()
    {
        compliancequest__SQX_Part_Family__c prfamily = new compliancequest__SQX_Part_Family__c();
        prfamily.Name = 'test data';
        insert prfamily;
        
        compliancequest__SQX_Part__c pr = new compliancequest__SQX_Part__c();
        pr.Name = 'test data';
        pr.compliancequest__Part_Number__c = '123';
        pr.compliancequest__Part_Risk_Level__c = 1;
        pr.compliancequest__Part_Family__c = prfamily.id;
        insert pr;
        
        Task tsk = new Task();
        tsk.WhatId = pr.Id;
        tsk.Subject = 'Review Part -' + pr.compliancequest__Part_Number__c;
        tsk.OwnerId = pr.CreatedById;
        tsk.Status = 'Not Started';
        insert tsk;
    }

}