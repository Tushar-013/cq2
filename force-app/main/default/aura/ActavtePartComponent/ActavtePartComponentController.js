({
    handleButtonClick : function(component, event, helper) {
        try {
            console.log("recordId"+component.get("v.recordId"));
            let partData = component.get("v.partData");
            partData.Id = component.get("v.recordId");
            console.log("data>>"+JSON.stringify(partData));
            if($A.util.isEmpty(partData.compliancequest__Reason_For_Change__c)) {
                component.find("reasonChange").showHelpMessageIfInvalid();
            }
            else {
                helper.callApex(component, event, helper);
            }
        }
        catch(ex) {
            console.log(ex);
        }
    }
})