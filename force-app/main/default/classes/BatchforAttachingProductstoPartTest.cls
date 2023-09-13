/**
 * This is a test class for the BatchforAttachingProductstoPart class
 */
@isTest
public class BatchforAttachingProductstoPartTest {
    @testSetup
    static void setup() {
        //creating part records
        List<compliancequest__SQX_Part__c> partList = new List<compliancequest__SQX_Part__c>();
        compliancequest__SQX_Part_Family__c partFamily = new compliancequest__SQX_Part_Family__c();
        partFamily.compliancequest__PMA_510_Number__c = 'testNum';
        partFamily.Name='TestMyPartFam123';
        Insert partFamily;

        compliancequest__SQX_Part__c part1 = new compliancequest__SQX_Part__c();
        part1.Name = 'TestPart1';
        part1.compliancequest__Part_Number__c = '12456788';
        part1.compliancequest__Active__c= true;
        part1.compliancequest__Part_Risk_Level__c = 3;
        part1.compliancequest__Part_Family__c = partFamily.Id;
        partList.add(part1);
        compliancequest__SQX_Part__c part2 = new compliancequest__SQX_Part__c();
        part2.Name = 'TestPart2';
        part2.compliancequest__Part_Number__c = '12456789';
        part2.compliancequest__Active__c= true;
        part2.compliancequest__Part_Risk_Level__c = 3;
        part2.compliancequest__Part_Family__c = partFamily.Id;
        partList.add(part2);
        insert partList;
        //creating product records
        Product2 prod = new Product2();
        prod.Name = 'Test Part1';
        prod.ProductCode = '12456788';
        prod.IsActive = true;
        insert prod;
    }

    //Check if the part is linked to product and update accodingly.
    static testMethod void UpdatePartRecords(){
        
        List<Profile> profiles = [SELECT ID FROM Profile WHERE Name = 'System Administrator'];
        
        
        User user = new User();
        user.Username =  'testcustomuser1@user.com';
        user.Email = 'testcustomuser1@gmail.com';
        user.FirstName =  'atest';
        user.LastName = 'user1';
        user.CommunityNickname = 'tuser';
        user.ProfileId = profiles[0].Id;
        
        user.Alias =  'tuser';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        
        insert user;
        
        List<PermissionSet> permissionSets = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Admin'];
        if(permissionSets.size() > 0){
            PermissionSetAssignment  assignPermission=   new PermissionSetAssignment(AssigneeId=user.Id, PermissionSetId=permissionSets[0].Id);
            insert assignPermission;
            
        }
        user customUser = [select Id from User where UserName = 'testcustomuser1@user.com'];
        system.runAs(customUser){
            
            Test.startTest();
            
            BatchforAttachingProductstoPart batchJob = new BatchforAttachingProductstoPart();
            DataBase.executeBatch(batchJob); 
            
            Test.stopTest();
            compliancequest__SQX_Part__c Part1 = [Select Id,Name,compliancequest__Part_Number__c,compliancequest_SQX_Product__c from compliancequest__SQX_Part__c where Name ='TestPart1'];
            compliancequest__SQX_Part__c Part2 = [Select Id,Name,compliancequest__Part_Number__c,compliancequest_SQX_Product__c from compliancequest__SQX_Part__c where Name ='TestPart2'];
            Product2 prod1 = [Select Id,Name,ProductCode,IsActive from Product2 Where ProductCode ='12456788'];
            Product2 prod2 = [Select Id,Name,ProductCode,IsActive from Product2 Where ProductCode ='12456789'];
            system.assertequals(Part1.compliancequest_SQX_Product__c,prod1.Id,'Product 1 is linked to Part 1.');
            system.assertequals(Part2.compliancequest_SQX_Product__c,prod2.Id,'Product 2 is created and linked.');
        }
        
    }
    
    //Check if the schedule is executed.
    static testMethod void scheduleClassTest(){
		test.startTest();
        SchedulerforPartProductBatch sch = new SchedulerforPartProductBatch();
        String cronExp = '0 0 6 ? * * *';
        system.schedule('Job - SchedulerforPartProductBatch', cronExp, sch);
        test.stopTest();
            
    }
}