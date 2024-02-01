({
    locationSearchHandler : function(component, event, helper) {
        helper.fetchLocationInformation(component);
    },
    doInit : function(component, event, helper) {
        const columns = [
            { label: "Token", fieldName: "token", type: "text" },
            { label: "Contact Status", fieldName: "status", type: "text" },
            { label: "Visit Date", fieldName: "statusDate", type: "date" }
        ];
        component.set("v.columns", columns);
    }
})
