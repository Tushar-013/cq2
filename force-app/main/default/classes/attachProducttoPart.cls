/**
 * This is an extension class for the part product attachment batch class BatchforAttachingProductstoPart
 */
public class attachProducttoPart {
    public static void attactProduct(List<compliancequest__SQX_Part__c> partList){
        //List<compliancequest__SQX_Part__c> partList = new List<compliancequest__SQX_Part__c>();
        Map<String,compliancequest__SQX_Part__c> partNumbertoPartMap = new Map<String,compliancequest__SQX_Part__c>();
        Map<String,Product2> partNumbertoProductMap = new Map<String,Product2>();
        List<Product2> existingProdList = new List<Product2>();
        List<Product2> tobeCreatedProdList = new List<Product2>();
        List<Product2> allProdList = new List<Product2>();
        Set<String> partNameSet = new Set<String>();
        Set<String> partNumberSet = new Set<String>();
        Set<String> existingpartNumberSet = new Set<String>();
        Set<String> partNumbertoCreate = new Set<String>();
        try{
            
            if(!partList.isEmpty() && partList.size()>0){
                for(compliancequest__SQX_Part__c part :partList){
                    partNumberSet.add(part.compliancequest__Part_Number__c);
                    partNumbertoPartMap.put(part.compliancequest__Part_Number__c, part);
                }
                //querying the existing products
                existingProdList = [Select Id,Name,ProductCode,IsActive from Product2 Where ProductCode IN :partNumberSet and IsActive=true];
                for(Product2 prod : existingProdList){
                    existingpartNumberSet.add(prod.ProductCode);
                }
                partNumbertoCreate = partNumberSet.clone();
                partNumbertoCreate.removeall(existingpartNumberSet);
                //to create the missing products
                for(String partNum : partNumbertoCreate){
                    Product2 prod = new Product2();
                    prod.Name = partNumbertoPartMap.get(partNum).Name;
                    prod.ProductCode = partNumbertoPartMap.get(partNum).compliancequest__Part_Number__c;
                    prod.IsActive = true;
                    tobeCreatedProdList.add(prod);
                }
                //inserting the products
                if(!tobeCreatedProdList.IsEmpty() && tobeCreatedProdList.size()>0){
                    insert tobeCreatedProdList;
                }
                //querying all the products after inserting
                allProdList = [Select Id,Name,ProductCode,IsActive from Product2 Where ProductCode IN :partNumberSet and IsActive=true];
                for(Product2 prod : allProdList){
                    partNumbertoProductMap.put(prod.ProductCode, prod);
                }
                //linking the parts with respective products
                for(compliancequest__SQX_Part__c part :partList){
                    if(partNumbertoProductMap.containsKey(part.compliancequest__Part_Number__c)){
                        part.compliancequest_SQX_Product__c = partNumbertoProductMap.get(part.compliancequest__Part_Number__c).Id;
                    }
                }
                update partList;
            }
            
        }
        catch(Exception e){
            System.debug('Exception occured while attaching Product to Part -'+ e.getMessage());
        }
    }
}