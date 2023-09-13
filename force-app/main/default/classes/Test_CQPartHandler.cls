@isTest
public class Test_CQPartHandler { 
    @isTest
    static void testCreatedCQTask() {
        string permissionsetName='CQ_Admins';
        
        User userRec = TestDataFactory.createUser();
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =: permissionsetName];
        If(ps != Null){
            Insert new PermissionSetAssignment(AssigneeId = userRec.id, PermissionSetId = ps.Id);
        }
        System.runAs(userRec){
            compliancequest__SQX_Part__c cqPart = TestDataFactory.createParts('Test Part', '1234');
            Task ts = [SELECT Id,Subject,ActivityDate,status,OwnerId FROM Task WHERE Subject = :cqPart.compliancequest__Part_Number__c LIMIT 1];
            System.assertEquals(cqPart.compliancequest__Part_Number__c, ts.Subject);
        }
    
    }
    @isTest
    static void testCQPartUpdateActiveWithPermission(){
        string permissionsetName='CQ_Admins';
        
        User userRec = TestDataFactory.createUser();
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =: permissionsetName];
        If(ps != Null){
            Insert new PermissionSetAssignment(AssigneeId = userRec.id, PermissionSetId = ps.Id);
        }
        System.runAs(userRec){
            compliancequest__SQX_Part__c cqPart = TestDataFactory.createParts('Test Part', '1234');
            cqPart.compliancequest__Active__c = true;
            cqPart.compliancequest__Reason_For_Change__c = 'Test Reason';
            update cqPart;
            Task ts = [SELECT Id,Subject,ActivityDate,status,OwnerId FROM Task WHERE Subject = :cqPart.compliancequest__Part_Number__c LIMIT 1];
            compliancequest__SQX_Part__c updatedCqPart = [SELECT Id,compliancequest__Part_Number__c,compliancequest__Active__c,compliancequest__Part_Family__c FROM compliancequest__SQX_Part__c WHERE compliancequest__Part_Number__c = '1234'];
            System.assertEquals(updatedCqPart.compliancequest__Active__c, true);
            System.assertEquals('Completed', ts.Status);
        }
    }
    @isTest
    static void testCQPartUpdateActiveWithoutPermission(){
        User userRec = TestDataFactory.createUser();
        System.runAs(userRec){
            compliancequest__SQX_Part__c cqPart = TestDataFactory.createParts('Test Part', '1234');
            cqPart.compliancequest__Active__c = true;
            cqPart.compliancequest__Reason_For_Change__c = 'Test Reason';
            try{
                update cqPart;
            }
            catch(Exception e){
                System.debug('Message:'+e.getMessage());
            }
            Task ts = [SELECT Id,Subject,ActivityDate,status,OwnerId FROM Task WHERE Subject = :cqPart.compliancequest__Part_Number__c LIMIT 1];
            compliancequest__SQX_Part__c updatedCqPart = [SELECT Id,compliancequest__Part_Number__c,compliancequest__Active__c,compliancequest__Part_Family__c FROM compliancequest__SQX_Part__c WHERE compliancequest__Part_Number__c = '1234'];
            System.assertEquals(false,updatedCqPart.compliancequest__Active__c);
        }
    }
    
}