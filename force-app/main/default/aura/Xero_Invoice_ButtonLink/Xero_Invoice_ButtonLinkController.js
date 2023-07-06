({
    // Initilization on load
    doInit: function (component, event, helper) {
        component.set("v.loaded", false);
        var idVal = component.get("v.recordId");
        // * Check if xero contact is created for this Account
        // * idval is a opportunit ID
        var action = component.get("c.checkXeroAccountId");
        action.setParams({
            "idVal": idVal
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.currentStep", "1");
                //check if xero contact Id is present if present go to step 2
                // if not fetch the details from 
                if (response.getReturnValue() == false) {
                    component.set("v.loaded", true);
                    component.set("v.isAccountIdPresent", true);
                    //get Details for creating new xero contact
                    helper.getAccountDetails(component, event, helper, idVal);
                }
                else {
                    //* xero contact already exist go to create invoice page
                    component.set("v.isModalOpen", true);
                    component.set("v.currentStep", "2");
                    component.set("v.idVal", idVal);
                    //get details from opportunty and opportunityLineItems for creating invoice
                    helper.getOppurtunityDetails(component, event, helper, idVal);
                }
            } else if (state === "ERROR") {
                //if failed to create
                component.set("v.toggleSpinner", false);
                var errors = response.getError();
                helper.showToast(component,event,helper,'error','Failed to fetch details sometime later/ Contact Admin');
            }
        });
        $A.enqueueAction(action);
    },

    //* redirect to opportunity item on clicking cancel button
    cancelButton: function (component, event, helper) {
        // on 
        component.set("v.isModalOpen", false);
        var idVal = component.get("v.recordId");
        var url = "/lightning/r/Opportunity/" + idVal + "/view";
        window.location.replace(url);


    },
    //* deleting individual products added for creating invoice
    DeleteIndividualRetailerRow: function (component, event, helper) {
        //confirm deletion of item
        component.set('v.showConfirmDialog', true);
        var childId = event.getSource().get("v.name");
        component.set("v.childId", childId);
    },

    //*on confirmation to delete individual item remove the products 
    oppLineItemDeleteYes: function (component, event, helper) {
        component.set('v.showConfirmDialog', false);
        component.set("v.loaded", false);
        var childId = component.get("v.childId");
        var action = component.get("c.deleteOppurtunityLineItemRecord");
        action.setParams({
            "idVal": childId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.loaded", true);
                var idVal = component.get("v.idVal");
                helper.getOppurtunityDetails(component, event, helper, idVal);
            } else if (state === "ERROR") {
                component.set("v.toggleSpinner", false);
                var errors = response.getError();
                helper.showToast(component,event,helper,'error','Failed to delete product items Try sometime later/ Contact Admin')
            }
        });
        $A.enqueueAction(action);
    },
    //*deny deletion of opportunity Line Item
    oppLineItemDeleteNo: function (component, event, helper) {
        component.set('v.showConfirmDialog', false);
    },
    //* Update values on qty change
    qtyChange: function (component, event, helper) {
        var recId = event.getSource().get("v.name");
        var qty = event.getSource().get("v.value");
        var discount = '';
        helper.updateOppLineItems(component, event, helper, recId, qty, discount);
    },

    // *update total value on discount change
    discountChange: function (component, event, helper) {
        var recId = event.getSource().get("v.name");
        var discount = event.getSource().get("v.value");
        var qty = '';
        helper.updateOppLineItems(component, event, helper, recId, qty, discount);
    },

    // * Create invoice on clicking submit button
    submitInvoiceDetails: function (component, event, helper) {
        var dateVal = component.get("v.dateEntered");
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        
        if (dateVal != null && dateVal >= today) {
            var recId = event.getSource().get("v.value");
            var jsonString = JSON.stringify(recId);
            var action = component.get("c.sendInvoice");
            
            action.setParams({
                "jsonString": jsonString,
                "dateVal": dateVal
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var idVal = component.get("v.recordId");
                    helper.showToast(component, event, helper, 'success', 'Invoice Created Succesfully');
                    var url = "/lightning/r/Opportunity/" + idVal + "/view";
                    window.location.replace(url);
                } else if (state === "ERROR") {
                    component.set("v.toggleSpinner", false);
                    var errors = response.getError();
                    helper.showToast(component,event,helper,'error','Failed to Create Invoice Try sometime later/ Contact Admin')
                }
            });
            $A.enqueueAction(action);
        }
        else {
            var message;
            if(dateVal < today){
                 message = 'Due Date Cannot be Less than Today Date';
            }else{
                 message = 'Please Select Due Date';
            }
            helper.showToast(component, event, helper, 'warning', message);
        }
    },
    // *Check if values are entered present and valid before createing contact in xero
    datacheck: function(component, Event, helper){
        helper.dataValidation(component,Event,helper);
    },
    // *Create xero contact in xero.com
    confirmCreateXeroContact: function (component, event, helper) {
        var idVal = event.getSource().get("v.value");
        var oppId = component.get("v.recordId");
        var dataok = helper.dataValidation(component,event,helper);
        var jsonString = JSON.stringify(idVal);
        var oppId = component.get("v.recordId");
    
        if (dataok == true) {
            var action = component.get("c.sendContact");
            action.setParams({
                "jsonString": jsonString,
                "oppId": oppId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var idVal = component.get("v.recordId");
                    component.set("v.currentStep", "2");
                    component.set("v.isAccountIdPresent", false);
                    component.set("v.isModalOpen", true);
                    helper.showToast(component, event, helper, 'success', 'Xero Contact Created ...!');
                    helper.getOppurtunityDetails(component, event, helper,oppId);
                } else if (state === "ERROR") {
                    component.set("v.toggleSpinner", false);
                    var errors = response.getError();
                    helper.showToast(component,event,helper,'error','Failed to Create Contact in Xero')
                }
            });
            $A.enqueueAction(action);
        }
    },
})