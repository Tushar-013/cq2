@IsTest
public class CreateNonconformanceTriggerTest {
    @IsTest
    public static void testCreateNonconformanceTrigger() {
        // Create test data
        Case testCase = new Case(
            Subject = 'Test Case',
            Type = 'Question'
        );
        insert testCase;
        // Set up the Trigger context
        Test.startTest();
        // Perform DML operation to invoke the trigger
        testCase.Type= 'Problem';
        update testCase;
        Test.stopTest();

        user usr = [SELECT Name, Id FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetLicenseAssign WHERE PermissionSetLicense.MasterLabel ='CQ Admin Extended Permissions') AND IsActive=true and Username = 'cqcandidate@cqassessment.com'];
        system.runAs(usr){
        
        // Verify the Nonconformance record was created
        compliancequest__SQX_Nonconformance__c createdNonconformance = [SELECT Id, Related_to_Case__c FROM compliancequest__SQX_Nonconformance__c WHERE Related_to_Case__c = :testCase.Id];
        System.assertEquals(testCase.Id, createdNonconformance.Related_to_Case__c);
        
        testCase.CQ_CAN_SQX_NC_Reference__c = createdNonconformance.Id;
        system.debug('Test##'+testCase.CQ_CAN_SQX_NC_Reference__c);
                
        
        // Verify the lookup field was populated on the Case
        Case updatedCase = [SELECT CQ_CAN_SQX_NC_Reference__c FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(createdNonconformance.Id, updatedCase.CQ_CAN_SQX_NC_Reference__c);
    }
    }
}