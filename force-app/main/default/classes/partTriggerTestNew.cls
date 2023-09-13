@IsTest
public class partTriggerTestNew {
    @testSetUp
    Static void declareData()
    {
        compliancequest__SQX_Part_Family__c  partFamilyRec = new compliancequest__SQX_Part_Family__c ();
        partFamilyRec.Name = 'Part Family 1';
        Insert partFamilyRec;
        compliancequest__SQX_Part__c  partRecord = new compliancequest__SQX_Part__c();
        partRecord.Name = 'Test Part 2';
        partRecord.compliancequest__Part_Number__c = '1234567';
        partRecord.compliancequest__Part_Family__c = partFamilyRec.Id;
        partRecord.compliancequest__Part_Risk_Level__c = 3.0;
        Insert partRecord;
        Profile p = [select id from profile where name='System Administrator'];
        User u = new User(
            alias = 'abc', 
            email='test@email45434535.com',
            emailencodingkey='UTF-8',
            lastname='User', 
            languagelocalekey='en_US',
            localesidkey='en_GB',
            profileid = p.Id,
            timezonesidkey='Europe/London', 
            username='unit.test@email45434535.com'
        );
        insert u;
    }
    @IsTest
    public static void createPartRecord(){
       	compliancequest__SQX_Part_Family__c partFamilyRec = [SELECT Id from compliancequest__SQX_Part_Family__c WHERE Name = 'Part Family 1'][0];
        compliancequest__SQX_Part__c  partRecord = new compliancequest__SQX_Part__c();
        partRecord.Name = 'Test Part 1';
        partRecord.compliancequest__Part_Number__c = '123456';
        partRecord.compliancequest__Part_Family__c = partFamilyRec.Id;
        partRecord.compliancequest__Part_Risk_Level__c = 3.0;
        Test.startTest();
        insert partRecord;
        Task taskRecord = [SELECT Id,Subject,ActivityDate,Status,OwnerId from Task where Subject Like 'Review Part - %' AND WhatId=:partRecord.Id][0];
        System.assertEquals('Review Part - 123456', taskRecord.Subject, 'Subject Should Be Matched');
        System.assertEquals(Date.Today().addDays(7), taskRecord.ActivityDate, 'Due Date Should Be 7 Days From Today');
        System.assertEquals(UserInfo.getUserId(), taskRecord.OwnerId, 'Task Owner Should Be Part Owner');
        System.assertEquals('Not Started', taskRecord.Status, 'Task Status Should Be Equal To Not Started');
        Test.StopTest();
    }
    @IsTest
    public static void checkReasonForChangeValue()
    {
        compliancequest__SQX_Part__c  partRecord = [SELECT Id from compliancequest__SQX_Part__c WHERE Name = 'Test Part 2'][0];
        Test.startTest();
        partRecord.compliancequest__Active__c = true;
        partRecord.compliancequest__Reason_For_Change__c ='';
        update partRecord;
        System.assertEquals('', partRecord.compliancequest__Reason_For_Change__c, 'Reason For Change Can\'t Be Blank');
        Test.stopTest();
    }
    @IsTest
    public static void checkPermissionForUser()
    {
        User u = [SELECT id FROM User WHERE username = 'unit.test@email45434535.com'];
        System.runAs(u)
        {
            compliancequest__SQX_Part__c  partRecord = [SELECT Id from compliancequest__SQX_Part__c WHERE Name = 'Test Part 2'][0];
            Test.startTest();
            partRecord.compliancequest__Active__c = true;
            partRecord.compliancequest__Reason_For_Change__c = 'test';
            Database.SaveResult result = Database.update(partRecord, false);
            System.assertEquals(Label.ErrorMessage, result.getErrors()[0].getMessage(), 'Current User Don\'t Have Permission To Edit');
            Test.stopTest();
        }
    }
}