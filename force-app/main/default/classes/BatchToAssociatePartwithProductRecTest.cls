@IsTest
public class BatchToAssociatePartwithProductRecTest {
   //Creating testUp for Data
    @testSetUp
    public static void dataSetup(){
        compliancequest__SQX_Part_Family__c prtFamily = new  compliancequest__SQX_Part_Family__c();
        prtFamily.Name='test';
        insert prtFamily;
        compliancequest__SQX_Part__c prt1 = new compliancequest__SQX_Part__c();
        prt1.name = 'Test Part';
        prt1.compliancequest__Part_Number__c='12345';
        prt1.compliancequest__Part_Family__c = prtFamily.id;
        insert prt1;
        product2 prd= new Product2();
        prd.Name = 'Test';
        prd.ProductCode ='12345';
        prd.IsActive = true;
        insert prd;
        
        compliancequest__SQX_Part__c prt2 = new compliancequest__SQX_Part__c();
        prt2.name = 'Test Part1';
        prt2.compliancequest__Part_Number__c='56789';
        prt2.compliancequest__Part_Family__c = prtFamily.id;
        insert prt2;
        
    }
    //TestingwithPermission
    @istest
    public static void partWithoutProductLookupAndPermission(){
        
        
        
        User userRec = TestFactory.createSalesforceUserRecord('System Administrator');
        //Assigning the permission set to the newly created user
        PermissionSet ps = [SELECT Id  FROM PermissionSet WHERE Name =: 'CQ_Admin'];
        If(ps != Null) Insert new PermissionSetAssignment(AssigneeId = userRec.id, PermissionSetId = ps.Id);
        
        system.runAs(userRec){
            Test.startTest();
            BatchToAssociatePartwithProductRec sh1 = new BatchToAssociatePartwithProductRec();
            database.executeBatch(new BatchToAssociatePartwithProductRec());
             String sch = '0 0 6 ? * * *'; 
            system.schedule('BatchToAssociatePartwithProductRec', sch, sh1); 
            
            test.stopTest();
        }
        compliancequest__SQX_Part__c part1 = [SELECT Id,Name,compliancequest_SQX_Product__c FROM compliancequest__SQX_Part__c WHERE Name = 'Test Part' limit 1];
        compliancequest__SQX_Part__c part2 = [SELECT Id,Name,compliancequest_SQX_Product__c FROM compliancequest__SQX_Part__c WHERE Name = 'Test Part1' limit 1];
        Product2 prod1 = [SELECT Id,Name,ProductCode,isActive FROM Product2 WHERE ProductCode = '12345'];
        Product2 prod2 = [SELECT Id,Name,ProductCode,isActive FROM Product2 WHERE ProductCode = '56789'];
       
        System.assertEquals(part1.compliancequest_SQX_Product__c, prod1.Id);  
        System.assertEquals(part2.compliancequest_SQX_Product__c, prod2.Id);
        System.assertEquals(part2.Name, prod2.Name);
        System.assertEquals(true, prod2.isActive); 
        
        
        
    }
      //TestingwithoutPermission
    @istest
    public static void userWithoutPermission(){
        
        
        
        User userRec = TestFactory.createSalesforceUserRecord('System Administrator');
       
        system.runAs(userRec){
            Test.startTest();
            BatchToAssociatePartwithProductRec sh1 = new BatchToAssociatePartwithProductRec();
            database.executeBatch(new BatchToAssociatePartwithProductRec());
            String sch = '0 0 6 ? * * *'; 
            system.schedule('BatchToAssociatePartwithProductRec', sch, sh1); 
            
            test.stopTest();
        }
        compliancequest__SQX_Part__c part1 = [SELECT Id,Name,compliancequest_SQX_Product__c FROM compliancequest__SQX_Part__c WHERE Name = 'Test Part' limit 1];
        compliancequest__SQX_Part__c part2 = [SELECT Id,Name,compliancequest_SQX_Product__c FROM compliancequest__SQX_Part__c WHERE Name = 'Test Part1' limit 1];
   
       
        System.assertEquals(part1.compliancequest_SQX_Product__c, null); 
         System.assertEquals(part2.compliancequest_SQX_Product__c, null); 
      
         
        
        
        
    }  
    
}