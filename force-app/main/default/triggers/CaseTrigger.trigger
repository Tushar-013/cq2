trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Trigger.isInsert && Trigger.isAfter){
        CaseTriggerHandler.createNCRecords(Trigger.newMap, null);
    }
    if(Trigger.isUpdate && Trigger.isAfter){
        CaseTriggerHandler.createNCRecords(Trigger.newMap, Trigger.oldMap);
    }
}