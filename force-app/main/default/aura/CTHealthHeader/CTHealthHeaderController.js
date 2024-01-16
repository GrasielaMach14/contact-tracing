({
    createRecord : function(component, event, helper) {
        const createRecordEvent = $A.get("e.force:createRecord");
        // Use a variável scope para pegar os valores tanto de person quanto de location
        const scope = component.get("v.scope");
    createRecordEvent.setParams({
        //Use o scope para verificar se o que foi chamado foi person ou location
        "entityApiName": scope === "person" ? "Person__c" : "Location__c"
    });
    createRecordEvent.fire();
    },
    // Chame a função help da contagem aqui
    getCountStatus : function(component, event, helper){
        helper.fetchStatusCount(component);

    }
})
