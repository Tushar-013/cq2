public class PartCheckBatch implements Database.batchable<sObject>, Schedulable {
    public void execute(SchedulableContext sc){
    	Database.executeBatch(new PartCheckBatch(),200);
    }
    public Database.QueryLocator start(Database.Batchablecontext bc){
    	return Database.getQueryLocator('Select Id,Name,compliancequest__Part_Number__c,compliancequest__SQX_SF_Product__c from compliancequest__SQX_Part__c where compliancequest__SQX_SF_Product__c = null AND compliancequest__Active__c=TRUE');
    }
    public void execute(Database.Batchablecontext bc,list<compliancequest__SQX_Part__c> partList){
        map<string,Product2> productMap = new map<string,Product2>();
        for(compliancequest__SQX_Part__c partRec: partList){
            Product2 prod = new Product2(IsActive=TRUE,Name=partRec.Name,ProductCode=partRec.compliancequest__Part_Number__c);
            productMap.put(partRec.compliancequest__Part_Number__c,prod);
        }
        if(productMap != null && !productMap.isEmpty()){
            insert productMap.values();
        }
        for(compliancequest__SQX_Part__c partRec: partList){
            partRec.compliancequest__SQX_SF_Product__c = productMap.get(partRec.compliancequest__Part_Number__c).Id;
        }
        update partList;
    }
    public void finish(Database.Batchablecontext bc){
    
    }
}