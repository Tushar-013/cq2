/*
*********************************************************
Apex Class Name    : PartProductBatchService
Created Date       : 10-05-2023
@description       : This class is a service class to associate parts with porduct.
@author            : Gaurav Gupta
Modification Log:
Ver   Date         Author                               Modification
1.0   10-05-2023   Gaurav Gupta                         Initial Version
*********************************************************
*/

public class PartProductBatchService implements Database.Batchable<sObject> {
    
    /**
     *  Description : used to query all the parts that doesn't have product look populated.
    */    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Name, compliancequest__Part_Number__c, compliancequest_SQX_Product__c FROM compliancequest__SQX_Part__c WHERE compliancequest_SQX_Product__c = null'
        );
    }

     /**
     *  Description : used to associate part with product.
    */  
    public void execute(Database.BatchableContext bc, List<compliancequest__SQX_Part__c> records) {
        System.debug('records: ' + records);
        List<compliancequest__SQX_Part__c> partListToUpdate = new List<compliancequest__SQX_Part__c>();
        List<Product2> productToInsert = new List<Product2>(); 
        // Map to hold part records with respective part Number
        Map<String, compliancequest__SQX_Part__c> partNumberVsPartMap = new Map<String, compliancequest__SQX_Part__c>();
        // Map to hold product records with respective product code
        Map<String, Product2> codeVsProductMap = new Map<String, Product2>();
        for (compliancequest__SQX_Part__c part : records) {
            partNumberVsPartMap.put(part.compliancequest__Part_Number__c, part);
        }
        // Query if product present for part numbers
        for(Product2 prodRec : [SELECT Id, Name, ProductCode, IsActive__c FROM Product2 WHERE ProductCode IN : partNumberVsPartMap.keySet()]) {
           codeVsProductMap.put(prodRec.ProductCode, prodRec);
        }

        // mapping of part with product
        for(String partNum : partNumberVsPartMap.keySet()) {
            compliancequest__SQX_Part__c part = partNumberVsPartMap.get(partNum);
            // if product already present
            if(codeVsProductMap.containsKey(partNum)) {
                part.compliancequest_SQX_Product__c = codeVsProductMap.get(partNum).Id;
                partListToUpdate.add(part);
            }
            // if product doesn't present in the system
            else {
                Product2 prod = new Product2();
                prod.Name = partNumberVsPartMap.get(partNum).Name;
                prod.ProductCode = partNum;
                prod.IsActive__c = true;
                productToInsert.add(prod);
            }

        }
        // insert products that aren't present in system
        if (!productToInsert.isEmpty()) {
            insert productToInsert;
        }

        // mapped newly created products with parts
        for (product2 crProd : productToInsert) {
              compliancequest__SQX_Part__c part =  partNumberVsPartMap.get(crProd.ProductCode);
              part.compliancequest_SQX_Product__c = crProd.Id;
              partListToUpdate.add(part);
        }

        // updating all parts including all mappings exisiting product and newly created products
        if (!partListToUpdate.isEmpty()) {
            update partListToUpdate;
        }
    }
    public void finish(Database.BatchableContext bc) {
        // execute any post-processing operations
    }
}