/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-02-02 23:41:06
 * @modify date 2024-02-02 23:41:07
 * @desc [description]
 */
({
    userSearchHandler : function(component, event, helper) {
        helper.fetchUserInformation(component);
    },
    // Carregar os dados no datatable
    doInit: function (component, event, helper) {
        component.set("v.columns", [
            { label: "Token", fieldName: "token", type: "text" },
            { label: "Contact Status", fieldName: "status", type: "text" },
            { label: "Contact Date", fieldName: "contactDate", type: "date" }
        ]);
    }
})
