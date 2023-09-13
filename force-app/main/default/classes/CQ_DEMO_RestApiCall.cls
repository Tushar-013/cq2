global with sharing class CQ_DEMO_RestApiCall {
    
   private static final Map<Integer, String> PART_FAMILY_CODE = new Map<Integer, String>{
        1 => 'High Volume', 
        0 => 'Low Volume'
        };
        
    @InvocableMethod()
        public static FlowOutput[] callExternalSource(){
        return getDataFromSource();
    }

     
    public static FlowOutput[] getDataFromSource() {
        HttpResponse responseData = sendPartsRequest();        
        string json = responseData.getBody();
        List<object> objects = (List<object>)System.JSON.deserializeUntyped(json);
        
        List<compliancequest__SQX_Part__c> partsList = new List<compliancequest__SQX_Part__c>();
        for (Object obj : objects) {
            Map<String, Object> mapResponseObjects = (Map<String, Object>)obj;
            
            compliancequest__SQX_Part__c part = new compliancequest__SQX_Part__c();
            part.Name = (string) mapResponseObjects.get('Part Name');
            part.compliancequest__Active__c = true;            
            part.compliancequest__Part_Family__c = ((integer) mapResponseObjects.get('Total Quantity Shipped') < 99) ? resolvePartFamily(PART_FAMILY_CODE.get(1)) : resolvePartFamily(PART_FAMILY_CODE.get(0));
            part.compliancequest__Part_Risk_Level__c=1;
            part.compliancequest__Part_Number__c = (string) mapResponseObjects.get('_id');
            
            
            partsList.add(part);
        }  
        Schema.SObjectField externalIdField = compliancequest__SQX_Part__c.Fields.compliancequest__Part_Number__c;
        List<Database.upsertResult> uResults = Database.upsert(partsList, externalIdField, false); 
        integer createCount = 0;
        integer updateCount = 0;
        for(Database.upsertResult result:uResults) {
            if (result.isSuccess() && result.isCreated()) {
                createCount++;
            }else if (result.isSuccess() && !result.isCreated()) {
                updateCount++;
            }
        }
        
        FlowOutput[] results = new List<FlowOutput>();
        results.add(new FlowOutput(createCount, updateCount));   
        if(!results.isEmpty()){
         	return results;   
        }
        
		return null;        
    }
    
    public class FlowInput{
        @InvocableVariable public Id recordId;
    }
    public class FlowOutput{
        @InvocableVariable public Integer recordsCreated;
        @InvocableVariable public Integer recordsUpdated;
        
        public FlowOutput(Integer recordsCreated, Integer recordsUpdated) {this.recordsCreated = recordsCreated; this.recordsUpdated = recordsUpdated;}
      
    }
    
    public static id resolvePartFamily(string familyName){
        
        return [SELECT id FROM compliancequest__SQX_Part_Family__c WHERE Name =: familyName][0].Id;
    }
    
     public static HttpResponse sendPartsRequest (){
        HttpRequest request = new HttpRequest();
        Http httpData = new Http();
        request.setMethod('GET');
        request.setEndpoint('https://cqparts-3d06.restdb.io/rest/cqpart');
        request.setHeader('Content-type', 'application/json');
        request.setHeader('x-api-key', 'b96d75ce0f9f342d10af6710ef8ea7ed0ad06');
        return httpData.send(request);
    } 
    
}