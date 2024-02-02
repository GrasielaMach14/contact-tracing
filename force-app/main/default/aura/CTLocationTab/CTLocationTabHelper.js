({
    fetchLocationInformation : function(component) {
        const recordId = component.get("v.recordId");
        const action = component.get("c.getLocationDetails");
        action.setParams({
            recordId
        });

        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const resp = response.getReturnValue();
                if(!resp || !resp.name){
                    component.set("v.locationFound", false);
                    this.showToast("ERROR", "Please, enter valid location id.", "error");
                    console.log("Entrei aqui BLOCO 1 ");
                }else{
                    // Encontrou Local
                    component.set("v.locationFound", true);
                    component.set("v.locationInfo", resp);
                    console.log("Entrei aqui BLOCO 2 ");
                }
            }
            else{
                component.set("v.locationFound", false);
                this.showToast("Error", "Please, enter valid location id.", "error"); 
                console.log("Entrei aqui BLOCO 3 ");
            }
            console.log("Response: ", state);
           
        });
        $A.enqueueAction(action);
    },
    showToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title,
            message,
            type
        });
        toastEvent.fire();
    }
})
