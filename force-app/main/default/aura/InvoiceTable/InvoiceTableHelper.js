({
    getInvoiceList: function(component, event, helper,accountId) {
        console.log('Account Id-' + accountId);

        var action = component.get('c.getInvoiceList');
        action.setParams({ "idVal" : accountId });
        var self = this;
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state === "SUCCESS") {
                console.log("state>>"+state);
                component.set('v.lstInvoice', actionResult.getReturnValue());
                //var a = actionResult.getReturnValue();
                console.log("invoice data returened>>"+component.get('v.lstInvoice'));
            }else{
            }
        });
        $A.enqueueAction(action);
    },
    
    
    helperMethod : function(component,callbackMethod) {
        var action = component.get("c.download");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var generatePdf = reponse.getReturnValue();
                component.set("v.sendData",generatePdf);
    
                alert('pdf generated successfully');
            }
            else{
    
                alert('unable to generate the pdf');
            }
        });
        $A.enqueueAction(action);
    }
    
})