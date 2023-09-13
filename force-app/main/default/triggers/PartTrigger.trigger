trigger PartTrigger on compliancequest__SQX_Part__c (before insert,after Insert,after update) {
    if(trigger.isAfter && trigger.isInsert){
       TusharPartTriggerHandler.createTaskRelatedToPart(Trigger.new);
    }
    if(trigger.isAfter && trigger.isUpdate){
       TusharPartTriggerHandler.updatePartAndRelatedTask(Trigger.new,Trigger.oldmap);
    }

}