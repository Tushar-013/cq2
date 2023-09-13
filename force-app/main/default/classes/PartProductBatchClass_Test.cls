@isTest
public class PartProductBatchClass_Test {
	@testSetup
    public static void testData(){
        compliancequest__SQX_Part_Family__c partFamilyRec = new compliancequest__SQX_Part_Family__c(name='Test Family');
        insert partFamilyRec;
            
        list<compliancequest__SQX_Part__c> partList = new list<compliancequest__SQX_Part__c>();
        for(integer i=1;i<=20;i++){
			compliancequest__SQX_Part__c partRec = new compliancequest__SQX_Part__c();
            partRec.Name = 'Part Name '+String.valueOf(i);
            partRec.compliancequest__Part_Number__c = 'PRT1125'+String.valueOf(i);
            partRec.compliancequest__Active__c = TRUE;
            partRec.compliancequest__Part_Risk_Level__c = 1;
            partRec.compliancequest__Part_Family__c = partFamilyRec.Id;
            partList.add(partRec);
        }
        
        insert partList;        
    }
    	
    public static testMethod void testPartProduct(){
        Profile adminProfileId = [Select Id from Profile where Name='System Administrator'];
        User adminUser = new User(FirstName='Test',Lastname='Admin',Alias='tsadm',Username='testadmin@test.com',email='testadmin@test.com',ProfileId=adminProfileId.Id);
        insert adminUser;
        System.runAs(adminUser){
            System.test.startTest();
                Database.executeBatch(new PartCheckBatch());
            System.test.stopTest();
            list<compliancequest__SQX_Part__c> partList = [Select Id,compliancequest__SQX_SF_Product__c from compliancequest__SQX_Part__c where compliancequest__Active__c=TRUE AND compliancequest__SQX_SF_Product__c = null];
            system.assert(partList.size() > 0,'List has values');
        }
        
    }
}