({
    updateStatusToRed: function (component) {
        const recordId = component.get("v.recordId");

        const action = component.get("c.changeToRedStatus");
        action.setParams({
            personId: recordId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Handle response here - response.getReturnValue();
                this.showToast("Success", "Person Health Status updated with success.", "success");
            }
        });
        $A.enqueueAction(action);
        console.log("Mudei para vermelho");
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
