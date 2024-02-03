/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-02-02 23:40:43
 * @modify date 2024-02-02 23:40:44
 * @desc [description]
 */
({
    fetchUserInformation : function(component) {
        const recordId = component.get("v.recordId");
        const action = component.get("c.getPersonDetails");
        action.setParams({
            recordId
        });

        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const resp = response.getReturnValue();
                if(!resp || !resp.name){
                    component.set("v.userFound", false);
                    this.showToast("ERROR", "Please, enter valid user id.", "error");
                }else{
                    // Encontrou usuário
                    component.set("v.userFound", true);
                    component.set("v.userInfo", resp);
                }
            }
            else{
                component.set("v.userFound", false);
                this.showToast("Error", "Please, enter valid user id.", "error");                
            }
        });
        $A.enqueueAction(action);
    },
    showToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title,
            message,
            type
        });
        toastEvent.fire();
    
    }
})
