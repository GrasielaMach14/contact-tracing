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
    }
})
