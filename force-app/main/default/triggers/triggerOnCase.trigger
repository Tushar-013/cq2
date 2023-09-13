/**
 * @description       : 
 * @author            : Jyoti Chahal
 * @group             : 
 * @last modified on  : 08-25-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger triggerOnCase on Case (after insert,after update) {
    if(caseTriggerController.isRecursion){
        caseTriggerController.createNonconformance(trigger.new);
        caseTriggerController.isRecursion = false;
    }
}