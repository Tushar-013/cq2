public class BatchToAssociatePartwithProductRec implements Database.Batchable<sobject>,Schedulable {
  //Method to check whether the user has required Permission
    public boolean checkPermission(){
          Profile adminProfile = [SELECT Id FROM Profile WHERE Name =:'System Administrator' limit 1];
        string currentProfileId = adminProfile.id;
        //Getting current userId
        string userId =  userinfo.getUserId();
        //Getting current user Profile
        string profileId = userinfo.getProfileId();
        //Declaring a boolean
        boolean AuthorisedUser = false;
        //checking is it a admin profile 
        if(profileId==currentProfileId){
            //quering the permission set assigment from cq admin permissionSet  having System Admin Profile
            list<PermissionSetAssignment> listofPS = [SELECT Id,AssigneeId FROM PermissionSetAssignment where AssigneeId=:userId and PermissionSet.Name=:'CQ_Admin' limit 1];
            if(listofPS.size()>0){
                AuthorisedUser = true;
            }
            
        }
        return AuthorisedUser;
    }
    
    //Schedule this class every day at 6AM GMT
    public void execute(SchedulableContext sc)
    {
        boolean authurisedUser = checkPermission();
        //This class executes only when current user is system admin having CQ_Admin permission set
        if(authurisedUser){
            database.executeBatch(new BatchToAssociatePartwithProductRec());
        }
        
    }
    
    //Query Part Records 
    public database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id,Name,compliancequest__Part_Number__c,compliancequest_SQX_Product__c FROM compliancequest__SQX_Part__c where compliancequest_SQX_Product__c=null';
        return Database.getQueryLocator(query);
    }
    //Process the PartRecords
    public void execute(Database.BatchableContext bc,list<compliancequest__SQX_Part__c> partRecordsList){
        try{
            boolean authurisedUser = checkPermission();
            if(authuriseduser){
            if(partRecordsList.size()>0){
                //Creating a Map to store the existing Product Records
                map<string,Product2>  existingProductMap = new map<string,Product2>();
                Map<String,compliancequest__SQX_Part__c> partsMap = new Map<String,compliancequest__SQX_Part__c>();
                //Creating a set to store the partNumbers
                set<string> partNumberSet= new set<string>();
                for(compliancequest__SQX_Part__c partRec:partRecordsList){
                    if(partRec.compliancequest__Part_Number__c!=null){
                        partNumberSet.add(partRec.compliancequest__Part_Number__c);
                        partsMap.put(partRec.compliancequest__Part_Number__c,partRec);
                    }
                }
                //Querying Products and storing in the Map
                for(Product2 prodRecord:[select id,ProductCode ,IsActive from Product2 where ProductCode!=null and ProductCode IN :partNumberSet]){
                    existingProductMap.put(prodRecord.ProductCode,prodRecord);
                    
                }
                //List to Store the Product Records
                list<Product2>  listofProductstoInsert = new list<Product2>();
                list<compliancequest__SQX_Part__c>  listofPartstoInsert = new list<compliancequest__SQX_Part__c>();
                //Quering over Partrecords and linking the Product if exists or else creating a Product Record
                for(compliancequest__SQX_Part__c partRec:partRecordsList){
                    if(partRec.compliancequest__Part_Number__c!=null){
                        if(existingProductMap.containskey(partRec.compliancequest__Part_Number__c)){
                            partRec.compliancequest_SQX_Product__c = existingProductMap.get(partRec.compliancequest__Part_Number__c).id;
                            listofPartstoInsert.add(partRec);
                        }
                        else if(!existingProductMap.containskey(partRec.compliancequest__Part_Number__c)){
                            Product2 newProdRec = new Product2();
                            newProdRec.ProductCode = partRec.compliancequest__Part_Number__c;
                            newProdRec.Name =  partRec.Name;
                            newProdRec.IsActive = true;
                            listofProductstoInsert.add(newProdRec);
                            
                        }
                    }
                }
                //Inserting the Products and linking it to the part
                if(listofProductstoInsert.size()>0){
                    insert listofProductstoInsert;
                    for(Product2 prod:listofProductstoInsert){
                        if(partsMap.containsKey(prod.ProductCode)){
                            compliancequest__SQX_Part__c partRec = partsMap.get(prod.ProductCode);
                            partRec.compliancequest_SQX_Product__c = prod.Id;
                            listofPartstoInsert.add(partRec);
                        }
                    }
                }
                //Updating the Part Records
                if(listofPartstoInsert.size()>0){
                    update listofPartstoInsert;
                }
            }
        }
        }
        catch(exception e){
            system.debug('Exception occured'+e.getMessage() + 'at line number -->'+ e.getLineNumber());
        }
        
    }
    public void finish(Database.BatchableContext bc){
        
    }
    
}