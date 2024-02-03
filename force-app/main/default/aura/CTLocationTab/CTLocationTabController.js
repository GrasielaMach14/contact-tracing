/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-02-02 23:39:56
 * @modify date 2024-02-02 23:39:57
 * @desc [description]
 */
({
    locationSearchHandler : function(component, event, helper) {
        helper.fetchLocationInformation(component);
    },
    doInit : function(component, event, helper) {
        const columns = [
            { label: "Token", fieldName: "token", type: "text" },
            { label: "Contact Status", fieldName: "status", type: "text" },
            { label: "Visit Date", fieldName: "visitDate", type: "date" }
        ];
        component.set("v.columns", columns);
    }
})
