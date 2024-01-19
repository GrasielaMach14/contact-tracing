/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-01-19 18:39:22
 * @modify date 2024-01-19 18:39:23
 * @desc [description]
 */
({
    // Este método é para fazer a chamada das funções em CTHealthHeaderController
    fetchStatusCount : function(component) {
        const scope = component.get("v.scope");
        // Defina se o escopo for person então chame a função do controller
        let action = scope === "person" ? component.get("c.getPersonHealthStatusCount") : component.get("c.getLocationHealthStatusCount");
        //Defina um callback para saber a resposta do sistema, se for exato mude a contagem
        action.setCallback(this, function (response) {
            const state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.count", response.getReturnValue());
            }
            
        });

        $A.enqueueAction(action);
    }
})
