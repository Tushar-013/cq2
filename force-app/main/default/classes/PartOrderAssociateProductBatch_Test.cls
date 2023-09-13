@isTest
private class PartOrderAssociateProductBatch_Test{

@testSetup
private static void createTestData(){

Product2 prod = new Product2();
prod.Name='GearTest';
prod.IsActive = true;
prod.ProductCode='ProdTest12345';
Insert prod;

compliancequest__SQX_Part_Family__c partFamily = new compliancequest__SQX_Part_Family__c();
partFamily.compliancequest__PMA_510_Number__c = 'testNum';
partFamily.Name='TestMyPartFam123';
Insert partFamily;

compliancequest__SQX_Part__c partOrder = new compliancequest__SQX_Part__c();
partOrder.Name = 'TestPartOrder';
partOrder.compliancequest__Part_Number__c = 'ProdTest123456';
partOrder.compliancequest__Active__c= true;
partOrder.compliancequest__Part_Risk_Level__c = 3;
partOrder.compliancequest__Part_Family__c = partFamily.Id;
Insert partOrder;
}

@isTest
private static void existProdLinkUserCase(){
Test.startTest();
database.executeBatch(new PartOrderAssociateProductBatch(),200);
Test.stopTest();
}

@isTest
private static void notexistProdLinkUserCase(){
    Test.startTest();
    compliancequest__SQX_Part_Family__c sqxPartFm = [SELECT ID FROM compliancequest__SQX_Part_Family__c Limit 1];
    compliancequest__SQX_Part__c partOrder = new compliancequest__SQX_Part__c();
    partOrder.Name = 'TestPartOrder2';
    partOrder.compliancequest__Part_Number__c = 'ProdTest12345';
    partOrder.compliancequest__Active__c= true;
    partOrder.compliancequest__Part_Risk_Level__c = 2;
    partOrder.compliancequest__Part_Family__c = sqxPartFm.Id;
    Insert partOrder;
    database.executeBatch(new PartOrderAssociateProductBatch(),200);
    Test.stopTest();
    
    Product2 product = [select id,ProductCode from Product2 where Name = 'GearTest'];
    compliancequest__SQX_Part__c part = [select id,compliancequest__SQX_SF_Product__c from compliancequest__SQX_Part__c where Id=:partOrder.Id];
    
    //Assert : Sf product should update
    system.assertEquals(product.Id,part.compliancequest__SQX_SF_Product__c,'Sf product should Update');
}

@isTest
private static void scheduleBatchUseCase(){
  Test.startTest();
  String JobId =  System.schedule('PartOrderAssociateProductBatchJob', '0 0 6 * * ? *' , new PartOrderAssociateProductBatch());
  Test.stopTest();
}
}