@isTest
public class PartTriggerHandlerTest {
    @testSetup static void testSetupMethod() {
        compliancequest__SQX_Part_Family__c partFamily = new compliancequest__SQX_Part_Family__c();
        partFamily.Name = 'Test part family';
        insert partFamily;
        compliancequest__SQX_Part__c eachpart = new compliancequest__SQX_Part__c();
        eachpart.compliancequest__Part_Number__c = 'PARTTest12344';
        eachpart.compliancequest__Part_Risk_Level__c = 2;
        eachpart.compliancequest__Reason_For_Change__c = 'Test Reason';
        eachpart.compliancequest__Part_Family__c = partFamily.Id;
        eachpart.Name = 'Test part for part trigger';
        insert eachpart;
    }
    @isTest
    static void testpartTriggermethod() {
        PermissionSet getPerm = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Admin' LIMIT 1];
        Profile pr = [SELECT id FROM Profile WHERE Name = 'System Administrator'];
        User user1 = new User();
        user1.Alias = 'tPart';
        user1.Email = 'tpart@gmail.com';
        user1.Username = 'tpart12313@gmail.com';
        user1.EmailEncodingKey = 'UTF-8';
        user1.LanguageLocaleKey = 'en_US';
        user1.LastName = 'Process';
        user1.FirstName = 'Test';
        user1.LocaleSidKey = 'en_US';
        user1.ProfileId = pr.Id;
        user1.TimeZoneSidKey = 'America/Los_Angeles';
        insert user1;
        System.runAs(user1) {
            List<compliancequest__SQX_Part__c> getPart = [SELECT id, compliancequest__Part_Number__c, compliancequest__Active__c FROM compliancequest__SQX_Part__c LIMIT 1];
            Assert.isFalse(getPart.isEmpty(), 'No Part found');
            compliancequest__SQX_Part__c eachPart = new compliancequest__SQX_Part__c();
            eachPart = getPart.get(0);
            List<Task> getTask = [SELECT WhatId FROM Task WHERE WhatId =:eachPart.Id];
            Assert.isFalse(getTask.isEmpty(), 'No Task found');
            PermissionSetAssignment assignPerm = new PermissionSetAssignment();
            assignPerm.AssigneeId = user1.Id;
            assignPerm.PermissionSetId = getPerm.Id;
            insert assignPerm;
            
            eachPart.compliancequest__Active__c = true;
            update eachPart;
            List<Task> getCompletedTask = [SELECT WhatId FROM Task WHERE WhatId =:eachPart.Id AND Status = 'Completed'];
            Assert.isFalse(getCompletedTask.isEmpty(), 'Task not completed');
        }
    }
}