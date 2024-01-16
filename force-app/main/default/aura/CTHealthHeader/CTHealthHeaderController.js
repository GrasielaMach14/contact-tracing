({
    createRecord : function(component, event, helper) {
        const createRecordEvent = $A.get("e.force:createRecord");
        // Use a variável scope para pegar os valores tanto de person quanto de location
        const scope = component.get("v.scope");
    createRecordEvent.setParams({
        //Use o scope para verificar se o que foi chamado oi person ou location
        "entityApiName": scope === "person" ? "Person__c" : "Location__c"
    });
    createRecordEvent.fire();
    },

    getCountStatus : function(component, event, helper){
        const scope = component.get("v.scope");
        const count = component.get("v.count");

        if(scope === "person"){
            const statusPerson = component.get("c.getPersonHealthStatusCount");
        }else{
            const statusLocation = component.get("c.getLocationHealthStatusCount");
        }

    }
})
