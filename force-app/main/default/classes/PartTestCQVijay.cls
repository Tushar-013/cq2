@isTest
public class PartTestCQVijay {
    static testmethod void PartTestMethod(){
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        User usr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id
        );
        insert usr;
        
        system.runAs(usr){
            
        compliancequest__SQX_Part_Family__c cqPartFamily = new compliancequest__SQX_Part_Family__c();
        cqPartFamily.Name = 'Test Part Family';
        insert cqPartFamily;
        
        compliancequest__SQX_Part__c cqPartInactive = new compliancequest__SQX_Part__c();
        cqPartInactive.compliancequest__Active__c = false;
        cqPartInactive.Name = 'Test Vijay Inactive';
        cqPartInactive.compliancequest__Part_Number__c = 'Test0001';
        cqPartInactive.compliancequest__Part_Risk_Level__c = 1;
        cqPartInactive.compliancequest__Part_Family__c = cqPartFamily.Id;
        insert cqPartInactive;
        
        compliancequest__SQX_Part__c cqPartActive = new compliancequest__SQX_Part__c();
        cqPartActive.compliancequest__Active__c = true;
        cqPartActive.Name = 'Test Vijay Active';
        cqPartActive.compliancequest__Part_Number__c = 'Test0002';
        cqPartActive.compliancequest__Part_Risk_Level__c = 1;
        cqPartActive.compliancequest__Part_Family__c = cqPartFamily.Id;
        insert cqPartActive;
        
        List<Task> taskList = new List<Task>([SELECT Id From Task WHERE WhatId =: cqPartInactive.Id]);
        system.assertEquals(1, taskList.Size());
        List<Task> taskListActive = new List<Task>([SELECT Id From Task WHERE WhatId =: cqPartActive.Id]);
        system.assertEquals(0, taskListActive.Size());
            
            cqPartInactive.compliancequest__Active__c = true;
            update cqPartInactive;
            List<Task> taskListCompleted = new List<Task>([SELECT Id From Task WHERE WhatId =: cqPartInactive.Id AND Status = 'Completed']);
            system.assertEquals(1, taskListCompleted.Size());
            List<Task> taskListNonCompleted = new List<Task>([SELECT Id From Task WHERE WhatId =: cqPartInactive.Id AND Status != 'Completed']);
            system.assertEquals(0, taskListNonCompleted.Size());
        }
    }
}