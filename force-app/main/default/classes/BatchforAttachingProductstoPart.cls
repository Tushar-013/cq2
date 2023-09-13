global class BatchforAttachingProductstoPart implements Database.Batchable<sObject> {
    /**
        Batch Class to process the part records and link them with respective product records
    */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        String query = 'Select Id,Name,compliancequest__Part_Number__c,compliancequest_SQX_Product__c from compliancequest__SQX_Part__c where compliancequest_SQX_Product__c =NULL';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<compliancequest__SQX_Part__c> partList) {
       
        // process each batch of records
        try {
            // Call the extension class
            attachProducttoPart.attactProduct(partList);
        
        } catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
  }
}