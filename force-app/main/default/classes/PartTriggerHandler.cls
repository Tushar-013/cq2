public class PartTriggerHandler {
    public void run() {
        if(Trigger.isBefore && Trigger.isInsert) {
            beforeInsert(Trigger.new);
        }
        else if(Trigger.isAfter && Trigger.isInsert) {
            afterInsert(Trigger.new);
        }
        else if(Trigger.isBefore && Trigger.isUpdate) {
            Map<Id, compliancequest__SQX_Part__c> oldPartMap = (Map<Id, compliancequest__SQX_Part__c>) Trigger.oldMap;
            beforeUpdate(Trigger.new, oldPartMap);
        }
        else if(Trigger.isAfter && Trigger.isUpdate) {
            Map<Id, compliancequest__SQX_Part__c> oldPartMap = (Map<Id, compliancequest__SQX_Part__c>) Trigger.oldMap;
            Map<Id, compliancequest__SQX_Part__c> newMap = (Map<Id, compliancequest__SQX_Part__c>) Trigger.newMap;
            afterUpdate(Trigger.new, newMap, oldPartMap);
        }
    }
    void beforeInsert(List<compliancequest__SQX_Part__c> newPartList) {
        for(compliancequest__SQX_Part__c eachPart : newPartList) {
            if(eachPart.compliancequest__Active__c) {
                eachPart.addError('Active part not be created');
            }
        }
    }
    void afterInsert(List<compliancequest__SQX_Part__c> newPartList) {
        try {
            List<Task> associateTaskList = new List<Task>();
            for(compliancequest__SQX_Part__c eachPart : newPartList) {
                associateTaskList.add(new Task(Subject = 'Review Part - '+eachPart.compliancequest__Part_Number__c, ActivityDate = Date.today().adddays(7), Status = 'Not Started', OwnerId = eachPart.OwnerId, WhatId = eachPart.Id));
            }
            if(!associateTaskList.isEmpty()) {
                insert associateTaskList;
            }
        }
        catch(Exception ex) {
            throw ex;
        }
    }
    void beforeUpdate(List<compliancequest__SQX_Part__c> newPartList, Map<Id, compliancequest__SQX_Part__c> oldMap) {
        List<PermissionSetAssignment> getAssignment = new List<PermissionSetAssignment>();
        getAssignment = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSet.Name = 'CQ_Admin' AND AssigneeId =:UserInfo.getUserId()];
        for(compliancequest__SQX_Part__c eachpart : newPartList) {
            if(eachpart.compliancequest__Active__c && eachpart.compliancequest__Active__c != oldMap.get(eachpart.Id).compliancequest__Active__c && getAssignment.isEmpty()) {
                eachpart.addError('Insufficient access to activate the part');
            }
        }
    }
    void afterUpdate(List<compliancequest__SQX_Part__c> newpartList, Map<Id, compliancequest__SQX_Part__c> newPartMap, Map<Id, compliancequest__SQX_Part__c> oldPartMap) {
        try {
            List<Task> completeTaskList = new List<Task>();
            Map<Id, List<Task>> partVsTaskMap = new Map<Id, List<Task>>();
            for(Task eachTask : [SELECT Id, WhatId, Status FROM Task WHERE Status != 'Completed' AND WhatId IN :newPartMap.keySet()]) {
                if(!partVsTaskMap.containsKey(eachTask.WhatId)) {
                    partVsTaskMap.put(eachTask.WhatId, new List<task>{eachTask});
                }
                else {
                    partVsTaskMap.get(eachTask.WhatId).add(eachTask);
                }
            }
            for(compliancequest__SQX_Part__c eachpart : newpartList) {
                if(eachpart.compliancequest__Active__c && eachpart.compliancequest__Active__c != oldPartMap.get(eachpart.Id).compliancequest__Active__c && partVsTaskMap.containsKey(eachpart.Id)) {
                    completeTaskList.addAll(partVsTaskMap.get(eachpart.Id));
                }
            }
            for(Task eachTask : completeTaskList) {
                eachTask.Status = 'Completed';
            }
            if(!completeTaskList.isEmpty()) {
                update completeTaskList;
            }
        }
        catch(Exception ex) {
            throw ex;
        }
    }
    @AuraEnabled
    public static void activatePart(String partData) {
        try {
            System.debug('partData>>'+partData);
            if(String.isNotBlank(partData) && String.isNotEmpty(partData)) {
                compliancequest__SQX_Part__c partObj = (compliancequest__SQX_Part__c) JSON.deserialize(partData, compliancequest__SQX_Part__c.Class);
                update partObj;
            }
        }
        catch(Exception ex) {
            throw ex;
        }
    }
}