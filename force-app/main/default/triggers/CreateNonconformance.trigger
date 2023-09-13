trigger CreateNonconformance on Case (after insert, after update) {
    
    // Check if the current user has the CQ Admin Extended Permissions set
    if(System.FeatureManagement.checkPermission('CQ Admin Extended Permissions')) return;
    
    // check if trigger context is After and Insert operation
    if(Trigger.isInsert && Trigger.isAfter){
        CreateNonconformanceHandler.onAfterInsert(trigger.oldMap, trigger.newMap);  // Calling Handler class method
    }
    
    // check if trigger context is After and Update operation
    if(Trigger.isUpdate && Trigger.isAfter){
        CreateNonconformanceHandler.onAfterInsert(trigger.oldMap, trigger.newMap);  // Calling Handler class method
    }
    
}