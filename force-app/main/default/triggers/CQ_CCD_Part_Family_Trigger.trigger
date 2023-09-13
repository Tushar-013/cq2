trigger CQ_CCD_Part_Family_Trigger on compliancequest__SQX_Part_Family__c (after insert) {
    
    /*if(Trigger.isAfter){
        if(Trigger.isInsert){
            new CQ_CCD_Part_Family(Trigger.New, Trigger.oldMap)
                .createPartRecord();
        }
        
        if(Trigger.isUpdate){
            new CQ_CCD_Part_Family(Trigger.New, Trigger.oldMap)
                .createAccountRecord();
        }
    }*/
}