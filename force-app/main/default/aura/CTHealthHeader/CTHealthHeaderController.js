/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-01-19 18:39:13
 * @modify date 2024-01-19 18:39:15
 * @desc [description]
 */
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
    // Chame a função help da contagem aqui, mas só aciona o evento em Person View
    getCountStatus : function(component, event, helper){
        helper.fetchStatusCount(component);

    },
    // Chame a função para acionar o evento para Location View também, chame essa função em handleSelect em CTHealthAdmin
    fetchCount: function (component, event, helper) {
        helper.fetchStatusCount(component);
    }
})
