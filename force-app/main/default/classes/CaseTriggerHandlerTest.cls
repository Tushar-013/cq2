@IsTest
public class CaseTriggerHandlerTest {
    @TestSetup
    static void setupData(){
        Case testCase = new Case();
        testCase.Subject = 'Test Subject';
        testCase.Priority = 'Medium';
        testCase.Description = 'Test Description';
        testCase.Type = 'Electrical';
        insert testCase;
    }

    @IsTest
    static void testCaseUpdate(){
        Case testCase = [SELECT Id, Subject, Priority, Description, CaseNumber, Type FROM Case];
        
        User testUser = TestDataFactory.createUser();

        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Admin_Extended_Permissions'];
        insert new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id);

        Test.startTest();
        System.runAs(testUser){
            testCase.Type = 'Problem';
            update testCase;
            List<compliancequest__SQX_Nonconformance__c> listOfNC = [SELECT Id, compliancequest__QMS_Reference_Number__c, compliancequest__NC_Title__c, compliancequest__Type__c, compliancequest__Description__c FROM compliancequest__SQX_Nonconformance__c];
            System.assertEquals(testCase.Subject, listOfNC[0].compliancequest__NC_Title__c, 'Comparing Subject Field');
            System.assertEquals('Internal', listOfNC[0].compliancequest__Type__c, 'Comparing Priority Field');
            System.assertEquals(testCase.Description, listOfNC[0].compliancequest__Description__c, 'Comparing Description Field');
            System.assertEquals(testCase.CaseNumber, listOfNC[0].compliancequest__QMS_Reference_Number__c, 'Comparing CaseNumber Field');
        }
        Test.stopTest();
    }

    @IsTest
    static void testCaseInsert(){
        User testUser = TestDataFactory.createUser();

        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Admin_Extended_Permissions'];
        insert new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id);

        Test.startTest();
        System.runAs(testUser){
            Case testCase = new Case();
            testCase.Subject = 'Test Subject';
            testCase.Description = 'Test Description';
            testCase.Type = 'Problem';
            insert testCase;
            
            List<compliancequest__SQX_Nonconformance__c> listOfNC = [SELECT Id, compliancequest__QMS_Reference_Number__c, compliancequest__NC_Title__c, compliancequest__Type__c, compliancequest__Description__c FROM compliancequest__SQX_Nonconformance__c];
            System.assertEquals(testCase.Subject, listOfNC[0].compliancequest__NC_Title__c, 'Comparing Subject Field');
            System.assertEquals('Internal', listOfNC[0].compliancequest__Type__c, 'Comparing Priority Field');
            System.assertEquals(testCase.Description, listOfNC[0].compliancequest__Description__c, 'Comparing Description Field');
        }
        Test.stopTest();
        
    }
}