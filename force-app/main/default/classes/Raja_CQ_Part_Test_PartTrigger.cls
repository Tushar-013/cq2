@isTest
public class Raja_CQ_Part_Test_PartTrigger {
    
    
    @TestSetup
    public static void createTestEntries(){
        
        //Get Profile 
        Profile sdProfile = [Select Id from Profile where name='Standard Platform User'];
        //creaate test User
        //
        User userExample = new User(Email = 'testUser@cq.com' , username = 'testUser@cq.com.dev', Alias='tucq'  ,
                                    FirstName ='test',LastName='User',
                                    ProfileId = sdProfile.Id) ;
        
        userExample.TimeZoneSidKey = 'America/New_York';
        userExample.LocaleSidKey = 'en_US';
        userExample.EmailEncodingKey = 'ISO-8859-1';
        userExample.LanguageLocaleKey = 'en_US';
        
        insert userExample;
    }
    
    @isTest
    public static void  WithPermissionSetReasonMandatory(){
        
        
        
        // Get user in test context
        // Get Permission
        
        
        //create part and add task to part using whatId
        
        User user = [Select id from user where username ='testUser@cq.com.dev' limit 1];
        
        //get Permission Set 
        //
        PermissionSet ps = [select Id From PermissionSet where Name ='CQ_Admin'];        //
        //Add user to Permissionset
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = user.id;
        psa.PermissionSetId = ps.id;
        insert psa;
        
        System.runAs(User){
            
            compliancequest__SQX_Part_Family__c cqpf = new compliancequest__SQX_Part_Family__c();
            cqpf.name= 'testPF';
            insert cqpf;
            // Update the  Part and make field active to true
            compliancequest__SQX_Part__c  cqsp = new compliancequest__SQX_Part__c();
            cqsp.name ='testPart1';
            cqsp.compliancequest__Part_Risk_Level__c=2;
            cqsp.compliancequest__Part_Number__c ='1234';
            cqsp.compliancequest__Part_Family__c =cqpf.id;
            cqsp.compliancequest__Active__c=false;
            
            insert cqsp;
            
            //get task
            //
            List<Task> tskList = [Select Id from Task where WhatId =:cqsp.ID ];
            
            //Check for task
            Assert.areEqual(tskList.size(), 1);
            
            
            cqsp.compliancequest__Active__c=true;
            cqsp.compliancequest__Reason_For_Change__c = ' Evry requirement has been completed we acan activate the part and closethe task';
            update cqsp;
            
            //check for status for Assert
            compliancequest__SQX_Part__c cqParttest = [Select Id ,compliancequest__SQX_Part__c.compliancequest__Active__c from compliancequest__SQX_Part__c where id =:cqsp.ID ];
            Assert.areEqual(cqParttest.compliancequest__Active__c, true); 
            
            //Now check task completed status also;            
            List<Task> tskNewList = [Select Id,Status from Task where WhatId =:cqsp.ID ];            
            //Check for task Completed
            Assert.areEqual(tskNewList[0].Status, 'Completed');
            
        }
        
        
    }
    
    
    @isTest
    public static void  WithPermissionSetReasonNotGiven(){
        
        // Get user in test context
        // Get Permission
        
        
        //create part and add task to part using whatId
        
        User user = [Select id from user where username ='testUser@cq.com.dev' limit 1];
        
        //get Permission Set 
        //
        PermissionSet ps = [select Id From PermissionSet where Name ='CQ_Admin'];        //
        //Add user to Permissionset
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = user.id;
        psa.PermissionSetId = ps.id;
        insert psa;
        
        System.runAs(User){
            
            compliancequest__SQX_Part_Family__c cqpf = new compliancequest__SQX_Part_Family__c();
            cqpf.name= 'testPF';
            insert cqpf;
            // Update the  Part and make field active to true
            compliancequest__SQX_Part__c  cqsp = new compliancequest__SQX_Part__c();
            cqsp.name ='testPart1';
            cqsp.compliancequest__Part_Risk_Level__c=2;
            cqsp.compliancequest__Part_Number__c ='1234';
            cqsp.compliancequest__Part_Family__c =cqpf.id; 
            cqsp.compliancequest__Active__c=false;
            insert cqsp;
            
            //get task
            List<Task> tskList = [Select Id from Task where WhatId =:cqsp.ID ];            
            //Check for task
            Assert.areEqual(tskList.size(), 1);
            
            try{
                compliancequest__SQX_Part__c cqParttest = [Select Id ,compliancequest__SQX_Part__c.compliancequest__Active__c,compliancequest__Reason_For_Change__c from compliancequest__SQX_Part__c where id =:cqsp.ID ];
               cqsp.compliancequest__Reason_For_Change__c ='';
                
                //cqsp.compliancequest__Reason_For_Change__c = ' Evry requirement has been completed we acan activate the part and closethe task';
                cqParttest.compliancequest__Active__c=true;
                update cqsp;               
                
            }catch(Exception e) {
                
                Assert.isTrue( e.getMessage().contains('FIELD_CUSTOM_VALIDATION'), e.getMessage());
            }
            
            
            
        }        
        
    }
    
    @isTest
    public static void  WithOutPermissionSet(){
        
        
        
        // Get user in test context
        // Get Permission
        
        
        //create part and add task to part using whatId
        
        User user = [Select id from user where username ='testUser@cq.com.dev' limit 1];
        
        System.runAs(User){
            
            compliancequest__SQX_Part_Family__c cqpf = new compliancequest__SQX_Part_Family__c();
            cqpf.name= 'testPF';
            insert cqpf;
            // Update the  Part and make field active to true
            compliancequest__SQX_Part__c  cqsp = new compliancequest__SQX_Part__c();
            cqsp.name ='testPart1';
            cqsp.compliancequest__Part_Risk_Level__c=2;
            cqsp.compliancequest__Part_Number__c ='1234';
            cqsp.compliancequest__Part_Family__c =cqpf.id; 
            cqsp.compliancequest__Active__c=false;
            
            insert cqsp;
            
            //get task
            List<Task> tskList = [Select Id from Task where WhatId =:cqsp.ID ];
            
            //Check for task
            Assert.areEqual(tskList.size(), 1);
            try{
                cqsp.compliancequest__Active__c=true;
                cqsp.compliancequest__Reason_For_Change__c = ' Evry requirement has been completed we acan activate the part and closethe task';
                update cqsp;
                
            }catch(Exception e) {                
                Assert.isTrue( e.getMessage().contains('FIELD_CUSTOM_VALIDATION'), e.getMessage());
            }            
            
            
        }
        
        
    }
    
    
}