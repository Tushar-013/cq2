@isTest
private class productCreationBasedonPartTest {
    
    //Common test data
    @testSetup static void commonTestData() {
        
        //create product2
        Product2 prod = new Product2(Name = 'Laptop X200', 
                                     ProductCode = 'po890', 
                                     IsActive = true,
                                     Family = 'Hardware');
        insert prod;
        
       //Create part family to associatewith part record.
        compliancequest__SQX_Part_Family__c partFamily = new compliancequest__SQX_Part_Family__c();
        partFamily.compliancequest__PMA_510_Number__c = 'test';
        partFamily.Name = 'TestPart234';
        insert partFamily;
        
        List<compliancequest__SQX_Part__c> compPartList = new List<compliancequest__SQX_Part__c>();
        //part record with product2. 
        compliancequest__SQX_Part__c part = new compliancequest__SQX_Part__c();
        part.compliancequest__SQX_SF_Product__c = prod.Id;
        part.compliancequest__Part_Family__c =partFamily.Id;
        part.compliancequest__Part_Number__c = '6799';
        part.compliancequest__Part_Risk_Level__c = 1 ;
        part.Name = 'Testcomppart';
        
        
        compPartList.add(part);
        //part record without product association
        compliancequest__SQX_Part__c part1 = new compliancequest__SQX_Part__c();
        // part.compliancequest__SQX_SF_Product__c = prod.Id;
        part1.compliancequest__Part_Family__c =partFamily.Id;
        part1.compliancequest__Part_Number__c = '67991';
        part1.compliancequest__Part_Risk_Level__c = 1 ;
        part1.Name = 'Testcomppart45';
        compPartList.add(part1);
        
        insert compPartList;
        
        
        
    }
    @isTest static void TestPartWithProdRef() {
        List<compliancequest__SQX_Part__c> partList = [SELECT Id, Name,compliancequest__Part_Family__c, compliancequest__Part_Number__c, compliancequest__Part_Risk_Level__c,compliancequest__SQX_SF_Product__c FROM compliancequest__SQX_Part__c];
        
        //  productCreationBasedonPartValidation.CreateProduct(partList[0].id);
        system.assertEquals(null,partList[0].compliancequest__SQX_SF_Product__c);
    }
    @isTest static void TestPartWithoutProdRef() {
        
        List<compliancequest__SQX_Part__c> partList = [SELECT Id, Name,compliancequest__Part_Family__c, compliancequest__Part_Number__c, compliancequest__Part_Risk_Level__c,compliancequest__SQX_SF_Product__c FROM compliancequest__SQX_Part__c];
        delete [Select Id From Product2];
        system.assertEquals(null,partList[1].compliancequest__SQX_SF_Product__c);
        //   productCreationBasedonPartValidation.CreateProduct(partList[0].id);
    }
    @isTest static void TestPartWithSysAdminPermission() {
        //Create test user  
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        //create permission set
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Admin'];
        insert new PermissionSetAssignment(AssigneeId = uu.id, PermissionSetId = ps.Id);
        
        
        system.runAs(uu){
            
         
            List<compliancequest__SQX_Part__c> partList = [SELECT Id, Name,compliancequest__Part_Family__c, compliancequest__Part_Number__c, compliancequest__Part_Risk_Level__c,compliancequest__SQX_SF_Product__c FROM compliancequest__SQX_Part__c];
            system.assertEquals(null,partList[1].compliancequest__SQX_SF_Product__c);
            
            
        }
    }
}