/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-01-19 18:40:46
 * @modify date 2024-01-19 18:40:47
 * @desc [description]
 */
({
    fetchData : function(component) {
        let action = component.get("v.scope") === "person" ? component.get("c.getRecentPersonHealthChanges") : component.get("c.getRecentLocationHealthChanges");
        
        action.setCallback(this, function (response) {
            const state = response.getState();
            if(state === "SUCCESS"){
                const data = response.getReturnValue();
                component.set("v.data", data);
                component.set("v.initialResponse", data);
            }
            
        });

        $A.enqueueAction(action);
    },

    searchRecord: function (component, queryTerm) {
        let action = component.get("v.scope") === "person" ? component.get("c.searchPeople") : component.get("c.searchLocations");
        action.setParams({
            searchTerm: queryTerm
        });

        action.setCallback(this, function (response) {
            const state = response.getState();

            if (state === "SUCCESS") {
                const data = response.getReturnValue();

                if (data && data.length > 0) {
                    component.set("v.data", data);
                }
                component.set("v.issearching", false);
            }
        });

        $A.enqueueAction(action);
    }
})
