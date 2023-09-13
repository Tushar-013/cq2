public class partTrigger1Handler {

    public static void insertTasks(List<Id> parts){
        system.debug('parts'+parts);
        List<Task> tasksListToUpdate = new List<Task>();
        List<compliancequest__SQX_Part__c> partsList = [select id,OwnerId,compliancequest__Part_Number__c from compliancequest__SQX_Part__c where id IN : parts];
        system.debug('partsList'+partsList);
        for(compliancequest__SQX_Part__c inserTask:partsList){
            Task tasks = new Task();
            tasks.Subject='Review Part'+inserTask.compliancequest__Part_Number__c;
            tasks.Status='Not Started';
            tasks.ActivityDate= system.today()+7;
            tasks.OwnerId = inserTask.OwnerId;
            tasks.WhatId=inserTask.Id; 
            system.debug('tasks'+tasks);
            tasksListToUpdate.add(tasks);
        }
        
        if(tasksListToUpdate.size()>0){
            system.debug('tasksListToUpdate'+tasksListToUpdate);
            insert tasksListToUpdate;
        }
        
        
    }
    
    public static void updateTasks(List<Id> parts){
        
        List<Task> tasksListToUpdate = new List<Task>();
        List<Task> partsList = [select id,whatid,Status from Task where whatid IN : parts];
        
        for(Task updateTask:partsList){
            Task tasks = new Task();
            tasks.Status='Completed';
            tasks.id=updateTask.id;
            tasksListToUpdate.add(tasks);
        }
        
        if(tasksListToUpdate.size()>0){
            update tasksListToUpdate;
        }
        
        
    }
}