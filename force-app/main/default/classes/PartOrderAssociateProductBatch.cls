global class PartOrderAssociateProductBatch implements database.batchable<sObject>,Schedulable{
Map<String,Id> prodCodeIdMap = new Map<String,Id>();
static Boolean IsGrantToRun= false; // Boolean Variable that decides whether BatchProcess to get execute or not

global PartOrderAssociateProductBatch (){
   User usr = [SELECT Id,Profile.Name from User where Id=: UserInfo.getUserId() Limit 1];
   PermissionSetAssignment  perSetAssigned = [select Id,PermissionSet.name,AssigneeId from PermissionSetAssignment where AssigneeId =: UserInfo.getUserId() and PermissionSet.name = 'CQ_Admin' LIMIT 1];
   if(perSetAssigned.Id != null && usr.Profile.Name == 'System Administrator'){
       IsGrantToRun = true;
   }
   for(Product2 prod : [SELECT id,name,ProductCode,IsActive from Product2 where IsActive = true]){
       prodCodeIdMap.put(prod.ProductCode,prod.Id);       
   }
}

// Start Method to retrieve all active part records
global Database.QueryLocator start(Database.BatchableContext BC){
    if(IsGrantToRun){
       String query = 'SELECT ID,Name,compliancequest__Part_Number__c,compliancequest__SQX_SF_Product__c from compliancequest__SQX_Part__c where compliancequest__Active__c=true';
        return Database.getQueryLocator(query);
     }else{
         return null;
     }
}

//Execute Method to associate all active part records with related Product Records Id's
global void execute(Database.BatchableContext BC, List<compliancequest__SQX_Part__c> scope){
    
    List<compliancequest__SQX_Part__c> partsToUpdLst = new List<compliancequest__SQX_Part__c>();
    for(compliancequest__SQX_Part__c part : scope){
        if(prodCodeIdMap.containsKey(part.compliancequest__Part_Number__c)){
            part.compliancequest__SQX_SF_Product__c = prodCodeIdMap.get(part.compliancequest__Part_Number__c);
            partsToUpdLst.add(part);
        }
        else{
            Product2 newProd = new Product2();
            newProd.name =part.Name;
            newProd.IsActive = true;
            newProd.ProductCode= part.compliancequest__Part_Number__c;
            Insert newProd;
            prodCodeIdMap.put(newProd.ProductCode,newProd.Id);
            part.compliancequest__SQX_SF_Product__c = newProd.Id;
            partsToUpdLst.add(part);
        }    
    }
    if(partsToUpdLst != null && partsToUpdLst.size()>0){
        UPDATE partsToUpdLst;    
    }
}

global void finish(Database.BatchableContext BC){

}

//Schedule Execute Method
global void execute(SchedulableContext sc){
    //String jobID = System.schedule('PartOrderAssociateProductBatchJob', '0 0 6 * * ? *' , new PartOrderAssociateProductBatch());
    database.executeBatch(new PartOrderAssociateProductBatch(),200);
}



}