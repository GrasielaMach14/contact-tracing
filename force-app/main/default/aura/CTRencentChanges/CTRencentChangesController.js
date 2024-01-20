/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-01-19 18:40:36
 * @modify date 2024-01-19 20:24:03
 * @desc [description]
 */
({
    init: function (component, event, helper) {
        const scope = component.get("v.scope");

        if(scope === "location"){
            component.set('v.columns', [
                {label: 'Name', fieldName: 'Name', type: 'text'},
                {label: 'Status', fieldName: 'Status__c', type: 'text'},
                {label: 'Pincode', fieldName: 'Pincode__c', type: 'text'},
                {label: 'Address', fieldName: 'Address__c', type: 'text'},
                {label: 'Red Score', fieldName: 'Red_Score__c', type: 'number'},
                {label: 'Status Update Date', fieldName: 'Status_Update_Date__c', type: 'date'},
                {label: 'View', type: 'button', initialWidth: 135, typeAttributes: { label: 'View/Update', name: 'view_details', title: 'Click to View Details'}}
            ]);
        }else{ 
            component.set('v.columns', [
                {label: 'Name', fieldName: 'Name', type: 'text'},
                {label: 'Phone', fieldName: 'Mobile__c', type: 'phone'},
                {label: 'Token', fieldName: 'Token__c', type: 'text'},
                {label: 'Health Status', fieldName: 'Health_Status__c', type: 'text'},
                {label: 'Status Update Date', fieldName: 'Status_Update_Date__c', type: 'date'},
                {label: 'View', type: 'button', initialWidth: 135, typeAttributes: { label: 'View/Update', name: 'view_details', title: 'Click to View Details'}}
            ]);
        }
        helper.fetchData(component);
    },
    //Buscar dados no campo de pesquisa da página
    handleKeyUp: function (component, event, helper) {
        const isEnterKey = event.keyCode === 13;
        var queryTerm = component.find("enter-search").get("v.value");
        // Check se o queryTerm está em branco pq é nele que fara a pesquisa referenciando o dado existente no banco
        if (!queryTerm) {
            // Use o initialResponse para fazer referência ao dado da função fetchData()
            component.set("v.data", component.get("v.initialResponse"));
        }
        if (isEnterKey) {
            // Defina o campo isLoading para true
            component.set("v.issearching", true);
            helper.searchRecord(component, queryTerm);
        }
    },
    // Chama o evento para ativar o botão View/Update
    handleRowAction: function (component, event, helper) {
        const action = event.getParam('action');
        const row = event.getParam('row');
        const scope = component.get("v.scope");
        switch (action.name) {
            case 'view_details':
                const evtApp = scope === "person" ? $A.get("e.c:CTPersonSelectEvent") : $A.get("e.c:CTLocationSelectEvent");
                //Use os parâmetros definidos nas duas classes para acionar o evento ao clicar no botão
                evtApp.setParams({
                    recordId : row.Id,
                    status : scope === "person" ? row.Health_Status__c : row.Status__c 
                });
                evtApp.fire();
                break;
        }
    }
});
