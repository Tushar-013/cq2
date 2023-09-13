({
    callApex : function(component, event, helper) {
        try {
            console.log("helper");
            let partData = component.get("v.partData");
            let action = component.get("c.activatePart");
            action.setParams({"partData": JSON.stringify(partData)});
            action.setCallback(this, function(response){
                if(response.getState() === "SUCCESS") {
                    console.log("Part activated");
                }
                else if(response.getState() === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
        catch(ex) {
            console.log(ex);
        }
    }
})