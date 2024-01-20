({
    personSelectHandler : function(component, event, helper) {
        const recordId = event.getParam("recordId");
        const status = event.getParam("status");
        component.set("v.recordId", recordId);
        component.set("v.status", status);
    },

    changeToRedStatus : function(component, event, helper){
        helper.updateStatusToRed(component);
    }
})
