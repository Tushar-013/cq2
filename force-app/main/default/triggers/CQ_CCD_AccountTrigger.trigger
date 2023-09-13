trigger CQ_CCD_AccountTrigger on Account (before update) {
    if(Trigger.isUpdate && Trigger.isBefore){
        CQ_CCD_AccountTriggerHandler.updatePhoneDescription();
    }
}