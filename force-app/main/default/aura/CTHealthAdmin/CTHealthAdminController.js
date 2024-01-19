/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-01-19 18:38:17
 * @modify date 2024-01-19 18:38:19
 * @desc [description]
 */
({
    // Pegar o id para efetuar a mudança no evento
    handleSelect : function(component, event, helper) {
        const selectedTabId = event.getParam("id");
        if(selectedTabId === "person"){
            component.set("v.title", "Person View");
        }else{
            component.set("v.title", "Location View");
        }
        // Armazene os atributos do id aqui no scope
        component.set("v.scope", selectedTabId);

        //Use o componente filho para chamar essa nova função em CTHealthHeader através da identificação do aura:id
        const healthHeaderComp = component.find("health-header");
        //Chame o novo método da contagem criado em CTHealthHeader 
        healthHeaderComp.fetchCount();
    }
})
