public class PartTriggerHandlerRunner {
    public static void afterInsert(List<compliancequest__SQX_Part__c> newParts){
        List<Task> newTaskList = new List<Task>();
        //creating task on parts insertion.
        for(compliancequest__SQX_Part__c newPart : newParts)
        {
            Task taskrecord = new Task();
            taskrecord.Subject = 'Review Part - '+newPart.compliancequest__Part_Number__c;
            taskrecord.OwnerId = newPart.OwnerId;
            taskrecord.WhatId = newPart.id;
            taskrecord.ActivityDate = Date.today().addDays(7);
            newTaskList.add(taskrecord);
        }
        if(!newTaskList.isEmpty())
        {
            insert newTaskList;
        }
    }
    public static void afterUpdate(List<compliancequest__SQX_Part__c> newParts,Map<Id,compliancequest__SQX_Part__c> oldMap){
        Boolean isPermission = FeatureManagement.checkPermission('partActivationPermission');
        Map<Id,compliancequest__SQX_Part__c> partIdvsPartRecord = new Map<Id,compliancequest__SQX_Part__c>();
        for(compliancequest__SQX_Part__c newPart : newParts)
        {
            if(isPermission == false) //check user permission
            {
                newPart.adderror(Label.ErrorMessage);
            }
            else{
                if(newPart.compliancequest__Active__c != oldMap.get(newPart.Id).compliancequest__Active__c && newPart.compliancequest__Active__c == true  && String.isBlank(newPart.compliancequest__Reason_For_Change__c)){
                    newPart.adderror(Label.ErrorMessage2);
                }
                //check for part is activated or not
                if(newPart.compliancequest__Active__c != oldMap.get(newPart.Id).compliancequest__Active__c && newPart.compliancequest__Active__c==true){
                    partIdvsPartRecord.put(newPart.Id,newPart);
                }
            }
        }
        if(!partIdvsPartRecord.isEmpty())
        {
            completeRelatedTask(partIdvsPartRecord);
        }
    }
    //updating task to completed on part activation
    public static void completeRelatedTask(Map<Id,compliancequest__SQX_Part__c> partIdvsPartRecord)
    {
        List<Task> taskListToUpdate = new List<Task>();
        List<task> relatedTasks = [SELECT Id from Task where Subject Like 'Review Part - %' AND whatId IN: partIdvsPartRecord.KeySet()];
        for(Task taskRec : relatedTasks)
        {
            Task taskrecord = new task();
            taskrecord.Id = taskRec.Id;
            taskrecord.Status = 'Completed';
            taskListToUpdate.add(taskrecord);
        }
        if(!taskListToUpdate.isEMpty())
        {
            update taskListToUpdate;
        }
    }
}