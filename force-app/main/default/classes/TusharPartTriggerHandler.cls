public class TusharPartTriggerHandler {
    public static void createTaskRelatedToPart(List<compliancequest__SQX_Part__c> newPartList){
        List<Task> updatedTaskList = new List<Task>();
        for(compliancequest__SQX_Part__c partRecord :newPartList ){
            Task tskRec = new Task();
            tskRec.WhatId = partRecord.Id;
            tskRec.Subject = 'Review Part - ' +  partRecord.compliancequest__Part_Number__c;
            tskRec.ActivityDate = System.Today().addDays(7);
            tskRec.OwnerId = partRecord.OwnerId;
            tskRec.Status = 'Not Started';
            updatedTaskList.add(tskRec);
        }
        
        if(!updatedTaskList.isEmpty()){
            Insert updatedTaskList;
        }
    }
    
    public static void updatePartAndRelatedTask(List<compliancequest__SQX_Part__c> newPartList, Map<Id,compliancequest__SQX_Part__c> oldmapOfPart){
        
        List<Task> updatedTaskList = new List<Task>();
        Set<Id> setOfActivePart =  new Set<Id>();
        Id userId =UserInfo.getUserId();
        if(checkPermissionSet(userId)){
            for(compliancequest__SQX_Part__c partRecord :newPartList ){
                if(oldmapOfPart != null && oldmapOfPart.get(partRecord.Id).compliancequest__Active__c != partRecord.compliancequest__Active__c 
                   && partRecord.compliancequest__Active__c ==true  && partRecord.compliancequest__Reason_For_Change__c!=null){
                    setOfActivePart.add(partRecord.Id);
                }
            }
            
            for(Task  tskRec :  [Select Id,WhatId FROM Task WHERE WhatId =:setOfActivePart ] ){
                tskRec.Status = 'Completed';
                updatedTaskList.add(tskRec);
            }
            
            if(!updatedTaskList.isEmpty()){
                Update updatedTaskList;
            }
        }}
    
    public static Boolean checkPermissionSet(Id userId){
        List<PermissionSetAssignment> perList  = [Select AssigneeId,PermissionSetId, PermissionSet.Name
                                                  FROM PermissionSetAssignment where AssigneeId  =: userId 
                                                  And
                                                  PermissionSet.Name = 'CQ_Admin_Tushar'];
        if(!perList.isEmpty()){
            return true;
        }else{
            return false;
        }
    }
    
    
    
    
}