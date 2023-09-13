/* Developer Name : Sowndarya
 * Date : 06-12-2022
 * Description : Unit tests to implement Part Activation process for the object :compliancequest__SQX_Part__c	
 * 
 * */


@isTest
public class PartActivationTest {
	
    @testSetup static void setup(){                
        
        insertUsers();
        
        //CREATING PART FAMILY
        compliancequest__SQX_Part_Family__c partFamily = new compliancequest__SQX_Part_Family__c();
        partFamily.Name = 'Nut';
        insert partFamily;
        
        //CREATING PART    
        compliancequest__SQX_Part__c part = new compliancequest__SQX_Part__c();
        part.Name = 'Part1';
        part.compliancequest__Part_Risk_Level__c = 2;
        part.compliancequest__Part_Family__c = partFamily.Id;
        part.compliancequest__Part_Number__c = '12345';
        insert part;
        
        
        //CREATE TASK
        Task task = new Task();
        task.Subject = 'Review Part - '+part.Name;
        Datetime oneweekdate = system.now().addDays(7); 
        task.ActivityDate = Date.valueOf(oneweekdate);
        task.WhatId = part.Id;
        task.Status = 'Not Started';
        insert task;

    }
   
    @future
    public static void insertUsers() {
                //CREATE CQ ADMIN MEMBER
        Profile standardprofile = [select id from profile where name ='Standard User'];        
        User user = new User();
        user.firstName = 'parttest1';
        user.lastName = 'parttest2';
        user.profileId = standardprofile.id;
        user.username = 'parttest@test.com';
        user.email = 'parttest@test.com';
        user.Alias = 'unitTest'; 
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        user.LocaleSidKey='en_GB';
        user.TimeZoneSidKey='Europe/London';
        insert user;
        PermissionSet CQAdminPermissionSet = [SELECT Id,Name FROM PermissionSet WHERE Name = 'CQ_Admin'];
        insert new PermissionSetAssignment(AssigneeId = user.id, PermissionSetId = CQAdminPermissionSet.Id);
        
        //CREATE CQ ADMIN USER MEMBER
        Profile sysAdminprofile = [select id from profile where name ='System Administrator'];
        User adminuser = new User();
        adminuser.firstName = 'parttest11';
        adminuser.lastName = 'parttest22';
        adminuser.profileId = sysAdminprofile.id;
        adminuser.username = 'parttest11@test1.com';
        adminuser.email = 'parttest11@test1.com';
        adminuser.Alias = 'unitTest'; 
        adminuser.EmailEncodingKey='UTF-8';
        adminuser.LanguageLocaleKey='en_US';
        adminuser.LocaleSidKey='en_GB';
        adminuser.TimeZoneSidKey='Europe/London';
        insert adminuser;
        PermissionSet CQAdminUserPermissionSet = [SELECT Id,Name FROM PermissionSet WHERE Name = 'CQ_System_Administrator'];
        insert new PermissionSetAssignment(AssigneeId = adminuser.id, PermissionSetId = CQAdminUserPermissionSet.Id);
    }
    
    
    // returns CQ Member 
    public static User getCQMember(){
        
        
        /*PermissionSet CQAdminUserPermissionSet = [SELECT Id,Name FROM PermissionSet WHERE Name = 'CQ_Admin'];
        PermissionSetAssignment permAssignment = [SELECT Id, AssigneeId FROM PermissionSetAssignment 
                                                  WHERE PermissionSetId =:CQAdminUserPermissionSet.Id];
        //User cqmemberuser = [Select Id,Name From User Where Id =:permAssignment.AssigneeId ];*/
        User cqmemberuser = [Select Id,Name From User Where Profile.Name ='System Administrator' limit 1];
        
        return cqmemberuser; 
    }
    
     // returns CQ Member 
    public static User getCQAdminUserMember(){
        PermissionSet CQAdminUserPermissionSet = [SELECT Id,Name FROM PermissionSet WHERE Name = 'CQ_System_Administrator'];
        PermissionSetAssignment permAssignment = [SELECT Id, AssigneeId FROM PermissionSetAssignment 
                                                  WHERE PermissionSetId =:CQAdminUserPermissionSet.Id limit 1];
        //User cqmemberuser = [Select Id,Name From User Where Id =:permAssignment.AssigneeId ];
        User cqmemberuser = [Select Id,Name From User Where Profile.Name ='Standard User' limit 1];
        return cqmemberuser; 
    }
    
    // returns part
    public static compliancequest__SQX_Part__c getPart(){
        compliancequest__SQX_Part__c part = [Select Id,Name,compliancequest__Active__c,compliancequest__Reason_For_Change__c 
                                             From compliancequest__SQX_Part__c limit 1];
        return part; 
    } 
    
    // returns task
    public static Task getTask(){
        Task task = [Select Id,Status From Task limit 1];
        return task; 
    }
    
    // use case 2 : part activation success
    @isTest static void partActivationSuccessTest(){
         
        compliancequest__SQX_Part__c part = getPart();
        system.debug(getCQMember());
        
        //run as cq member
        system.runAs(getCQMember()){
            part.compliancequest__Active__c = true;
            part.compliancequest__Reason_For_Change__c = 'Defected part.';
            update part;
            //THEN
            Assert.areEqual('Defected part.', part.compliancequest__Reason_For_Change__c);            
        }   
        compliancequest__SQX_Part__c partafterupdate = getPart();
        Assert.areEqual(part.compliancequest__Active__c, partafterupdate.compliancequest__Active__c);            

    }
    
    // use case 3 : part activation fail
    @isTest static void partActivationFailTest(){   
                
        compliancequest__SQX_Part__c part = getPart();
		User CQAdminUser = getCQAdminUserMember();
        system.debug(CQAdminUser);
        //run as not a cq member
        system.runAs(CQAdminUser){
            part.compliancequest__Active__c = true;
            part.compliancequest__Reason_For_Change__c = 'Defected part.';
            update part;                      
        }
        compliancequest__SQX_Part__c partafterupdate = getPart();
        Assert.areNotEqual(part.compliancequest__Active__c, partafterupdate.compliancequest__Active__c);            
    }
    


	// use case 4 : make tast completed
    @isTest static void taskCompletedTest(){
        compliancequest__SQX_Part__c part = getPart();
		Task task = getTask();
        
        //run as cq member
        system.runAs(getCQMember()){
            part.compliancequest__Reason_For_Change__c = 'Defected part.';
            update part;
            
            //THEN
            task.Status = 'Completed';
            update task;
        }               
    }

    
}