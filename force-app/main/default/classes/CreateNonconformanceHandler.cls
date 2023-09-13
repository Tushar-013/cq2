public class CreateNonconformanceHandler {
    
    public static void onAfterInsert(Map<Id,Case>oldMap,Map<Id,Case>newMap){
        
        Map<Id,Case>oldRecordsMap = (Map<Id,Case>)oldMap;// processing Old Map Records
        Map<Id,Case>newRecordsMap = (Map<Id,Case>)newMap;// processing New Map Records
        
        // Collect the Case Ids that need to be processed
        Set<Id> caseIds = new Set<Id>();
        for (Case newCase : newRecordsMap.values()) {
            Case oldCase = oldRecordsMap.get(newCase.Id);
            if (newCase.Type == 'Problem' && newCase.Type != oldCase.Type) {
                caseIds.add(newCase.Id);
            }
        }
        
        // Query existing Nonconformance records for the selected Cases
        Map<Id, compliancequest__SQX_Nonconformance__c> existingNonconformances = new Map<Id, compliancequest__SQX_Nonconformance__c>(
            [SELECT Id, Related_to_Case__c FROM compliancequest__SQX_Nonconformance__c WHERE Related_to_Case__c	 IN :caseIds]);
        
        // Create new Nonconformance records for the selected Cases
        List<compliancequest__SQX_Nonconformance__c> newNonconformances = new List<compliancequest__SQX_Nonconformance__c>();
        for (Case newCase : newRecordsMap.values()) {
            if (newCase.Type == 'Problem' && !existingNonconformances.containsKey(newCase.Id)) {
                compliancequest__SQX_Nonconformance__c nc = new compliancequest__SQX_Nonconformance__c(
                    Related_to_Case__c = newCase.Id,
                    compliancequest__Type__c  = 'Internal',
                    compliancequest__NC_Title__c = newCase.Subject,
                    compliancequest__Description__c	= newCase.Description,
                    compliancequest__QMS_Reference_Number__c  = newCase.CaseNumber
                    
                );
                newNonconformances.add(nc);
                newCase.CQ_CAN_SQX_NC_Reference__c = nc.Id; // Populate the lookup field
                
            }
        }
        
        // Insert the new Nonconformance records
        
        insert newNonconformances;
        
        
    }
    
    
    
}