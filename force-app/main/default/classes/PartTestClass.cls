@isTest
public class PartTestClass {
    
    @testSetup static void setup() {
        
        compliancequest__SQX_Part_Family__c testPartFamily = new compliancequest__SQX_Part_Family__c();
        testPartFamily.Name = 'Test123';
        insert testPartFamily;
        
        
        compliancequest__SQX_Part__c testPart =  new compliancequest__SQX_Part__c();
        testPart.Name = 'TestNameTushar177';
        testPart.compliancequest__Part_Number__c = 'Tushar77';
        testPart.compliancequest__Part_Risk_Level__c = 2;
        testPart.compliancequest__Part_Family__c = testPartFamily.Id;
        
        insert testPart;   
        
        compliancequest__SQX_Part__c testPart1 =  new compliancequest__SQX_Part__c();
        testPart1.Name = 'TestNameTushar1774';
        testPart1.compliancequest__Part_Number__c = 'Tushar774';
        testPart1.compliancequest__Part_Risk_Level__c = 2;
        testPart1.compliancequest__Part_Family__c = testPartFamily.Id;
        
        insert testPart1;   
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Tusharlast',
            Email = 'test123@yopmail.com',
            Username = 'test123@yopmail.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        ); 
        insert u;
        
         User u2 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            LastName = 'Tusharlast144',
            Email = 'test1234@yopmail.com',
            Username = 'test1234@yopmail.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        ); 
        insert u2;
        
    }
    
    @isTest
    public static void testPartCreation(){
        List<compliancequest__SQX_Part__c> partCQ = [Select Id,compliancequest__Part_Number__c from  compliancequest__SQX_Part__c 
                                                     where compliancequest__Part_Number__c ='Tushar77' limit 1];
        
        List<Task> tsk = [Select id,WhatId,Status,Subject from task where whatId =: partCQ[0].Id ];
        system.assertEquals(1,tsk.size());
        system.assertEquals(partCQ[0].Id,tsk[0].WhatId);
        system.assertEquals('Not Started',tsk[0].Status);
        system.assertEquals('Review Part - ' + partCQ[0].compliancequest__Part_Number__c ,tsk[0].Subject);
        
    }
    
    @isTest
    public static void testPartUpdateUser(){
        List<compliancequest__SQX_Part__c> partCQ = [Select Id,compliancequest__Part_Number__c from  compliancequest__SQX_Part__c 
                                                     where compliancequest__Part_Number__c ='Tushar774' limit 1];
        
        List<compliancequest__SQX_Part__c> partCqList = new List<compliancequest__SQX_Part__c>();
        User u = [Select id from User where lastname = 'Tusharlast'];
        system.runAs(u){
            for(compliancequest__SQX_Part__c cqPart : partCQ){
                cqPart.compliancequest__Active__c = true;
                cqPart.compliancequest__Reason_For_Change__c = 'test';
                partCqList.add(cqPart);
                
            }
            
            if(!partCqList.isEmpty()){
                Update partCqList;
            }
            
            List<Task> tsk = [Select id,WhatId,Status,Subject from task where whatId =: partCqList[0].Id ];
            system.assertEquals(1,tsk.size());
            system.assertEquals(partCQ[0].Id,tsk[0].WhatId);
            system.assertEquals('Not Started',tsk[0].Status);
        }
        
    }
    
    @isTest
    public static void testPartUpdateWithPermissionUser(){
        List<compliancequest__SQX_Part__c> partCQ = [Select Id,compliancequest__Part_Number__c from  compliancequest__SQX_Part__c 
                                                     where compliancequest__Part_Number__c ='Tushar774' limit 1];
        
        List<compliancequest__SQX_Part__c> partCqList = new List<compliancequest__SQX_Part__c>();
        User u = [Select id from User where lastname = 'Tusharlast'];
        system.runAs(u){
            
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Admin_Tushar'];
            insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
           
            
            for(compliancequest__SQX_Part__c cqPart : partCQ){
                cqPart.compliancequest__Active__c = true;
                cqPart.compliancequest__Reason_For_Change__c = 'test';
                partCqList.add(cqPart);
                
            }
            
            if(!partCqList.isEmpty()){
                Update partCqList;
            }
            
            List<Task> tsk = [Select id,WhatId,Status,Subject from task where whatId =: partCqList[0].Id ];
            system.assertEquals(1,tsk.size());
            system.assertEquals(partCQ[0].Id,tsk[0].WhatId);
            system.assertEquals('Completed',tsk[0].Status);
        }
        
    }
    
    @isTest
    public static void testPartUpdateWithPermissionStandardUser(){
        List<compliancequest__SQX_Part_Family__c> partCQ = [Select Id,name from  compliancequest__SQX_Part_Family__c 
                                                     where name ='Test123' limit 1];
        
        List<compliancequest__SQX_Part__c> partCqList = new List<compliancequest__SQX_Part__c>();
        User u = [Select id from User where lastname = 'Tusharlast144'];
        system.runAs(u){
            
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Admin_Tushar'];
            insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
           
            compliancequest__SQX_Part__c testPart1 =  new compliancequest__SQX_Part__c();
            testPart1.Name = 'TestNameTushar177456';
            testPart1.compliancequest__Part_Number__c = 'Tushar7745';
            testPart1.compliancequest__Part_Risk_Level__c = 2;
            testPart1.compliancequest__Part_Family__c = partCQ[0].Id;
            insert testPart1;  
            
			compliancequest__SQX_Part__c cqPart = new compliancequest__SQX_Part__c();
            cqPart.id = testPart1.Id;
            cqPart.compliancequest__Active__c = true;
            cqPart.compliancequest__Reason_For_Change__c = 'test';
            Update cqPart;

            List<Task> tsk = [Select id,WhatId,Status,Subject from task where whatId =:cqPart.Id ];
            system.assertEquals(1,tsk.size());
            system.assertEquals(cqPart.Id,tsk[0].WhatId);
            system.assertEquals('Completed',tsk[0].Status);
        }
        
    }
    
    
    
}