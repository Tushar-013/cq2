@IsTest
public class partTriggerTest {
    
    @testSetup
    static void makeData(){
        Profile prof = [SELECT Id FROM profile WHERE Name ='System Administrator'];
        User user = new User();
        user.firstName = 'Anchal';
        user.lastName = 'Jain';
        user.profileId = prof.id;
        user.email = 'test@test.com';
        user.Username = 'anchalJain@cq.com';
        user.Alias = 'CQTest';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        insert user;
        
        user accountManagerUser = new user();
        accountManagerUser.firstName = 'Account';
        accountManagerUser.lastName = 'Manager';
        accountManagerUser.profileId = prof.id;
        accountManagerUser.email = 'test@test.com';
        accountManagerUser.username = 'accountManager@cq.com';
        accountManagerUser.Alias = 'CQTest';
        accountManagerUser.TimeZoneSidKey = 'America/Los_Angeles';
        accountManagerUser.EmailEncodingKey = 'UTF-8';
        accountManagerUser.LanguageLocaleKey = 'en_US';
        accountManagerUser.LocaleSidKey = 'en_US';
        insert accountManagerUser;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Admin'];
        insert new PermissionSetAssignment(AssigneeId = accountManagerUser.id, PermissionSetId = ps.Id);
        
        
        
        
    }
    
    @isTest
    public static void testcreateTask(){
        System.runAs(getUser('Account Manager')){
            compliancequest__SQX_Part_Family__c cqfamily = new compliancequest__SQX_Part_Family__c();
        cqfamily.Name ='Test';
        insert cqfamily;
       Test.startTest();
        compliancequest__SQX_Part__c sqpart = new compliancequest__SQX_Part__c(Name ='test',compliancequest__Part_Number__c ='1234',compliancequest__Part_Risk_Level__c =1,compliancequest__Part_Family__c =cqfamily.id);
        insert sqpart;
        
        Test.stopTest();
        
        compliancequest__SQX_Part__c sq = [Select createdDate,compliancequest__Part_Number__c,CreatedById from compliancequest__SQX_Part__c where name ='test'];
        
        List<Task> taskList = [Select id,Status,Subject,OwnerId,ActivityDate from Task where CreatedBy.id =: userInfo.getUserId()];
        System.assertEquals(true, taskList.size()>0);
        System.assertEquals('Not Started', taskList[0].Status);
        System.assertEquals(sq.CreatedById, taskList[0].OwnerId);
         System.assertEquals('Review Part - ' + sq.compliancequest__Part_Number__c, taskList[0].Subject);
        }
        
    }
    
    @isTest
    public static void testupdateTaskStatus(){
        System.runAs(getUser('Account Manager')){
            compliancequest__SQX_Part_Family__c cqfamily = new compliancequest__SQX_Part_Family__c();
        cqfamily.Name ='Test';
        insert cqfamily;
       
        compliancequest__SQX_Part__c sqpart = new compliancequest__SQX_Part__c(Name ='test',compliancequest__Part_Number__c ='1234',compliancequest__Part_Risk_Level__c =1,compliancequest__Part_Family__c =cqfamily.id);
        insert sqpart;
        Test.startTest();
         	compliancequest__SQX_Part__c sq = [Select createdDate,compliancequest__Part_Number__c,CreatedById,compliancequest__Active__c,compliancequest__Reason_For_Change__c from compliancequest__SQX_Part__c where name ='test'];
            sq.compliancequest__Reason_For_Change__c='test';
            sq.compliancequest__Active__c = true;
            update sq;
        Test.stopTest();
       
        
        List<Task> taskList = [Select id,Status,Subject from Task where CreatedBy.id =: userInfo.getUserId()];
        System.assertEquals('Completed', taskList[0].Status);

        
    }
    }
    private static User getUser(String name){
        name = '%'+name+'%';
        return [SELECT Id,name,profile.name FROM User WHERE Name Like :name LIMIT 1];
    }

}