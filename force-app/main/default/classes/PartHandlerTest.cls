@IsTest
public class PartHandlerTest {
    @testSetup static void dataSetUp(){
        
        List<Product2> productsList = new List<Product2>();
        Map<String,Id> productsMapping = new Map<String,Id>();
        Set<String> productNames = new Set<String>();
        //Creation of products
        for(Integer i=0; i<5; i++) {
        	Product2 productObj = new Product2();
        	productObj.Name = 'Mobile Charger' + i;
            productObj.ProductCode = 'Code'+i;
            if(i<3) {
                productObj.IsActive = true;
            }
            productsList.add(productObj);
        }
        insert productsList;
        System.Assert(productsList.size() > 0);
        for(Product2 prod : productsList) {
        	productsMapping.put(prod.Name+':'+prod.ProductCode+':'+prod.IsActive,prod.Id);
            productNames.add(Prod.Name+prod.ProductCode);
        }
        
        
        //Creation of parts
        List<compliancequest__SQX_Part__c> partsList = new List<compliancequest__SQX_Part__c>();
        List<Product2> productToInsert = new List<Product2>(); 
        for(Integer i=0; i<6; i++) {
        	compliancequest__SQX_Part__c partObj = new compliancequest__SQX_Part__c();
            partObj.Name = 'Mobile Charger'+i;
            partObj.compliancequest__Part_Number__c = 'Code'+i;
            partObj.compliancequest__Active__c = true;
            String mapKey = partObj.Name +':'+partObj.compliancequest__Part_Number__c+':'+partObj.compliancequest__Active__c;
            if(productsMapping.get(mapKey) == null && !productNames.contains(partObj.Name +partObj.compliancequest__Part_Number__c)) {
            	Product2 productObj = new Product2();
        		productObj.Name = 'Mobile Charger' + i;
            	productObj.ProductCode = 'Code'+i;
            	productObj.IsActive = true;
            	productToInsert.add(productObj);  
            }
        }
        insert productToInsert;
        
        for(Integer i=0; i<5; i++) {
        	compliancequest__SQX_Part__c partObj = new compliancequest__SQX_Part__c();
            partObj.Name = 'Mobile Charger'+i;
            partObj.compliancequest__Part_Number__c = 'Code'+i;
            partObj.compliancequest__Active__c = true;
            String mapKey = partObj.Name +':'+partObj.compliancequest__Part_Number__c+':'+partObj.compliancequest__Active__c;
            partObj.compliancequest__SQX_SF_Product__c = productsMapping.get(mapKey);
            partsList.add(partObj);
        }
        
        insert partsList;
        
    }
    
    @IsTest
    private static void testParts(){
    	
        String userId = UserInfo.getUserId();
        User u = [Select Id,Email,Profile.Name from User where id=:userId];
        system.assertEquals(u.Profile.Name, 'System Administrator');
        
        PermissionSetAssignment passignment = [SELECT Id, PermissionSet.Name, Assignee.Email 
                                               FROM PermissionSetAssignment 
                                               WHERE Assignee.Email =:u.Email AND PermissionSet.Name='CQ Admin'];
        System.Assert(passignment != null);
        
        List<compliancequest__SQX_Part__c> partsList = [Select Id from compliancequest__SQX_Part__c where compliancequest__SQX_SF_Product__c != null];
        system.assertEquals(partsList.size(), 4);
        List<compliancequest__SQX_Part__c> partsList2 = [Select Id from compliancequest__SQX_Part__c where compliancequest__SQX_SF_Product__c = null];
        system.assertEquals(partsList2.size(), 2);
        
    }
    

}