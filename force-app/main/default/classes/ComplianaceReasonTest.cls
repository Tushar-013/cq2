@isTest
public class ComplianaceReasonTest {
	
    @testSetUp
    static void prepareData(){
        compliancequest__SQX_Part_Family__c comFamily= new compliancequest__SQX_Part_Family__c();
        comFamily.Name = 'Engery';
        insert comFamily;
        List<compliancequest__SQX_Part__c> comlList= new List<compliancequest__SQX_Part__c>();
        compliancequest__SQX_Part__c sqxPart = new compliancequest__SQX_Part__c();
        sqxPart.compliancequest__Part_Risk_Level__c=5;
        sqxPart.compliancequest__Part_Number__c='Test';
        sqxPart.compliancequest__Reason_For_Change__c='';
        sqxPart.compliancequest__Part_Family__c=comFamily.Id;
        comlList.add(sqxPart);
        compliancequest__SQX_Part__c sqxPart2 = new compliancequest__SQX_Part__c();
        sqxPart2.compliancequest__Part_Risk_Level__c=5;
        sqxPart2.compliancequest__Part_Number__c='Test2';
        sqxPart2.compliancequest__Reason_For_Change__c='';
        sqxPart2.compliancequest__Part_Family__c=comFamily.Id;
         comlList.add(sqxPart2);
        insert comlList;
        
    }
    
    static testMethod void activateAsCQAdmin(){
         compliancequest__SQX_Part__c sqxPart= [Select id,compliancequest__Active__c from compliancequest__SQX_Part__c order by CreatedDate desc limit 1];
        system.assertEquals(sqxPart.compliancequest__Active__c,false); 
        List<Task> taskList= [Select id from Task where whatId=:sqxPart.Id];
         system.assert(!tasKList.isEmpty());
        // User u = new User();
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        insert u;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Admin'];
insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
        system.runAs(u){
            sqxPart.compliancequest__Active__c=true;
            sqxPart.compliancequest__Reason_For_Change__c='Active';
            update sqxPart;
             List<Task> taskListUpdated= [Select id from Task where whatId=:sqxPart.Id and Status='Completed'];
            system.assert(!taskListUpdated.isEmpty());
        }
     }
    
     static testMethod void activateAsNonCQAdmin(){
         compliancequest__SQX_Part__c sqxPart= [Select id,compliancequest__Active__c from compliancequest__SQX_Part__c Order by CreatedDate asc limit 1];
         system.assertEquals(sqxPart.compliancequest__Active__c,false);
         List<Task> taskList= [Select id from Task where whatId=:sqxPart.Id];
         system.assert(!tasKList.isEmpty());
        // User u = new User();
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
         insert u;
        system.runAs(u){
            sqxPart.compliancequest__Active__c=true;
            sqxPart.compliancequest__Reason_For_Change__c='Active';
            update sqxPart;
             List<Task> taskListUpdated= [Select id from Task where whatId=:sqxPart.Id and Status='Completed'];
            system.assert(taskListUpdated.isEmpty());
        }
     }
}