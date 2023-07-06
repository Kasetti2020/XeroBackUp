({
    doInit : function(component, event, helper) {
        var accountId = component.get("v.accountId");
        
        console.log('accountId>>'+accountId)
        helper.getInvoiceList(component, event, helper,accountId);
    },
    
    
    downloadDocument : function(component, event, helper){
        var id = event.target.id;
        var winObjct = window.open('/apex/PDFgenVF?Id=' + id);
    }
    
    
})