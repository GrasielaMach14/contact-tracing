/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-01-19 18:40:10
 * @modify date 2024-01-19 18:40:12
 * @desc [description]
 */
({
    // Adicione esta função do evento manipulador para definir os parâmetros  
    locationSelectHandler: function (component, event, helper) {
        const recordId = event.getParam("recordId");
        const status = event.getParam("status");
        component.set("v.recordId", recordId);
        component.set("v.status", status);
    }
});
