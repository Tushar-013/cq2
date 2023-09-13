@isTest
public class DemoTestCls {
    @testSetup
    static void testData(){
        compliancequest__SQX_Part_Family__c partFamily = new compliancequest__SQX_Part_Family__c();
        partFamily.Name = 'test part family';
        insert partFamily;
        
        List<compliancequest__SQX_Part__c> partsList = new List<compliancequest__SQX_Part__c>();
        compliancequest__SQX_Part__c cqPart = new compliancequest__SQX_Part__c();
        cqPart.Name = 'Test part';
        cqPart.compliancequest__Active__c = false;
        cqPart.compliancequest__Part_Number__c = '1234';
        cqPart.compliancequest__Part_Risk_Level__c = 2;
        cqPart.compliancequest__Part_Family__c = partFamily.Id;
        partsList.add(cqPart);
        
        compliancequest__SQX_Part__c cqPart1 = new compliancequest__SQX_Part__c();
        cqPart1.Name = 'Test part1';
        cqPart1.compliancequest__Active__c = true;
        cqPart1.compliancequest__Part_Number__c = '12345';
        cqPart1.compliancequest__Part_Risk_Level__c = 3;
        cqPart1.compliancequest__Part_Family__c = partFamily.Id;
        
        partsList.add(cqPart1);
        
        insert partsList;
        System.debug('partsList:::'+partsList);
        Task task1 = [SELECT Id, Subject, WhatId, Status FROM Task WHERE WhatId = :partsList[0].Id];
    }
    static testMethod void testTaskCreation(){
        List<compliancequest__SQX_Part__c> cqParts = [SELECT Id, Name, compliancequest__Active__c, compliancequest__Part_Number__c 
                                                      FROM compliancequest__SQX_Part__c];
        Task task1 = [SELECT Id, Subject, WhatId, Status FROM Task];
        System.assertNotEquals(null, task1);
        System.assertNotEquals(null, [SELECT Id FROM Task WHERE WhatId =:cqParts[1].Id]);
    }
    static testMethod void testApproval(){
        /*
         *  Part Approval
            The Part record detail screen must have UI component (Quick Action or any convenient component) to approve the part. 
			The UI must allow approver to enter Reason for change (compliancequest__Reason_For_Change__c).
            Upon approval, the corresponding SF Task gets completed and the part is Active (compliancequest__Active__c =true).
            Only the members with CQ Admin Permission Set can complete the task.
         * */
        List<compliancequest__SQX_Part__c> cqParts = [SELECT Id, Name, compliancequest__Active__c, compliancequest__Part_Number__c 
                                                      FROM compliancequest__SQX_Part__c];
        //Get system admin profile for logged in user
        Profile sysAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User nonAdminUsr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator Temp'].Id,
            //ProfileId = sysAdmin.Id,
            LastName = 'Teja',
            Email = 'raviteja.gudepu111@gmail.com',
            Username = 'raviteja.gudepu111@gmail.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert nonAdminUsr;
        System.runAs(nonAdminUsr){
            cqParts[0].compliancequest__Reason_For_Change__c = 'Approved as it\'s active';
            cqParts[0].compliancequest__Active__c = true;
            List<Database.SaveResult> updateResults = Database.update(cqParts, true);
            //System.assertEquals(true, nonAdminUsr);
        }
        System.assertEquals(true, cqParts[0].compliancequest__Active__c);
        System.assertEquals('Approved as it\'s active', cqParts[0].compliancequest__Reason_For_Change__c);
    }
}