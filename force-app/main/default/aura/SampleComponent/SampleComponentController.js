({
    doInit : function(component, event, helper) {
        
        var idPassed = window.location.search;
        var opId = idPassed.split('=')[1];
        component.set("v.accountId",opId);
        //alert(opId);
        if(component.get("v.accountId")){
            component.set("v.isVisionPopup",true);
        }
    }
})