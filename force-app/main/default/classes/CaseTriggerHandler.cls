public with sharing class CaseTriggerHandler {
    public static void createNCRecords(Map<Id, Case> newItems, Map<Id, Case> oldItems){
        try{
            List<compliancequest__SQX_Nonconformance__c> listOfNCRecordsToInsert = new List<compliancequest__SQX_Nonconformance__c>();
            Map<String, Id> mapOfCaseNoToId = new Map<String, Id>();

            Boolean hasAccess = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'CQ_Admin_Extended_Permissions'].size() > 0 ? true : false;
            // Boolean hasAccess = System.FeatureManagement.checkPermission('CQ Admin Extended Permissions');

            if(hasAccess){
                for(Id eachCaseId: newItems.keySet()){
                    if(newItems.get(eachCaseId).Type == 'Problem' && (oldItems == null || (oldItems != null && newItems.get(eachCaseId).Type != oldItems.get(eachCaseId).Type)) && newItems.get(eachCaseId).CQ_CAN_SQX_NC_Reference__c == null){
                        System.debug('CaseNumber 1 - '+newItems.get(eachCaseId).CaseNumber);
                        compliancequest__SQX_Nonconformance__c tempNCRecord = new compliancequest__SQX_Nonconformance__c();
                        tempNCRecord.compliancequest__NC_Title__c = newItems.get(eachCaseId).Subject;
                        tempNCRecord.compliancequest__Type__c = 'Internal';
                        tempNCRecord.compliancequest__Description__c = newItems.get(eachCaseId).Description;
                        tempNCRecord.compliancequest__QMS_Reference_Number__c = newItems.get(eachCaseId).CaseNumber;
                        listOfNCRecordsToInsert.add(tempNCRecord);
    
                        mapOfCaseNoToId.put(newItems.get(eachCaseId).CaseNumber, eachCaseId);
                    }
                }
            }

            if(listOfNCRecordsToInsert != null && !listOfNCRecordsToInsert.isEmpty() && mapOfCaseNoToId != null && !mapOfCaseNoToId.isEmpty()){
                insert listOfNCRecordsToInsert;
				System.debug('mapOfCaseNoToId - '+mapOfCaseNoToId);
                List<Case> listOfCasesToUpdate = new List<Case>();

                for(compliancequest__SQX_Nonconformance__c eachNCRecord: listOfNCRecordsToInsert){
                    if(String.isNotBlank(eachNCRecord.compliancequest__QMS_Reference_Number__c) && mapOfCaseNoToId.containsKey(eachNCRecord.compliancequest__QMS_Reference_Number__c)){
                        Case tempCaseRecord = new Case();
                        tempCaseRecord.Id = mapOfCaseNoToId.get(eachNCRecord.compliancequest__QMS_Reference_Number__c);
                        tempCaseRecord.CQ_CAN_SQX_NC_Reference__c = eachNCRecord.Id;
                        listOfCasesToUpdate.add(tempCaseRecord);
                    }
                }

                if(listOfCasesToUpdate != null && !listOfCasesToUpdate.isEmpty()){
                    System.debug('listOfCasesToUpdate - '+listOfCasesToUpdate);
                    update listOfCasesToUpdate;
                }
            }
        }
        catch(Exception e){ 
            System.debug('Exception On Insert/Update - '+ e.getMessage());
        }
    }
}