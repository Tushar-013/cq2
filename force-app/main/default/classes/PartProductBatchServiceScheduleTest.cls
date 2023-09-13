@isTest
public class PartProductBatchServiceScheduleTest {
    public static final String CQ_ADMIN_PERMISSION_SET_NAME = 'CQ_Admin';
    @TestSetup
    static void makeData(){
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'ggOrg@testsf.com',
            Username = 'ggOrg@testsf.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert u;

        System.runAs(u) {
            Id pSetId = [SELECT ID FROM PermissionSet WHERE Name = :CQ_ADMIN_PERMISSION_SET_NAME][0].Id;
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = pSetId, AssigneeId = u.Id);
            insert psa; 
            Product2 prod = new Product2();
            prod.Name = 'Test Part 10 May';
            prod.ProductCode = '777';
            prod.IsActive = true;
            insert prod;

            compliancequest__SQX_Part_Family__c partFam = new compliancequest__SQX_Part_Family__c();
            partFam.Name = 'test part fam';
            insert partFam;

            compliancequest__SQX_Part__c part = new compliancequest__SQX_Part__c();
            part.Name = 'Test Part 10 May';
            part.compliancequest__Part_Number__c = '777';
            part.compliancequest__Part_Risk_Level__c = 1;
            part.compliancequest__Part_Family__c = partFam.Id;
            insert part;
        }
        
    }

    @isTest
    static void testPartProductBatchServiceIfThereIsProductExist() {
        System.runAs([SELECT Id FROM User WHERE Email = 'ggOrg@testsf.com'][0]){
            System.Test.startTest();
            System.debug('List: ' + [SELECT Id, Name, compliancequest__Part_Number__c, compliancequest_SQX_Product__c FROM compliancequest__SQX_Part__c WHERE compliancequest_SQX_Product__c = null]);
            PartProductBatchServiceSchedule sa = new PartProductBatchServiceSchedule();
            string expression='0 0 6 * * ? *';
            system.schedule('PartProductBatchServiceSchedule', expression, sa);
            sa.execute(null);
                       
            System.Test.stopTest();
            List<compliancequest__SQX_Part__c> part = [SELECT Id, Name, compliancequest_SQX_Product__c FROM compliancequest__SQX_Part__c WHERE compliancequest_SQX_Product__c!= null];
            System.debug('part: ' + part);
            System.assert(part.size() > 0); 
        }
    }

    @isTest
    static void testPartProductBatchServiceIfThereIsNoProductExist() {
        System.runAs([SELECT Id FROM User WHERE Email = 'ggOrg@testsf.com'][0]){
            compliancequest__SQX_Part__c partOne = new compliancequest__SQX_Part__c();
            partOne.Name = 'Test Part 12 May';
            partOne.compliancequest__Part_Number__c = '888';
            partOne.compliancequest__Part_Risk_Level__c = 1;
            partOne.compliancequest__Part_Family__c = [SELECT ID FROM compliancequest__SQX_Part_Family__c][0].Id;
            insert partOne;
            System.Test.startTest();
            System.debug('List: ' + [SELECT Id, Name, compliancequest__Part_Number__c, compliancequest_SQX_Product__c FROM compliancequest__SQX_Part__c WHERE compliancequest_SQX_Product__c = null]);
            PartProductBatchServiceSchedule sa = new PartProductBatchServiceSchedule();
            string expression='0 0 6 * * ? *';
            system.schedule('PartProductBatchServiceSchedule', expression, sa);
            sa.execute(null);
                       
            System.Test.stopTest();
            compliancequest__SQX_Part__c part = [SELECT Id, Name, compliancequest_SQX_Product__c FROM compliancequest__SQX_Part__c WHERE Id =: partOne.Id ];
            System.debug('part: ' + part);
            System.assert(part.compliancequest_SQX_Product__c != null); 
        }
    }
   
}