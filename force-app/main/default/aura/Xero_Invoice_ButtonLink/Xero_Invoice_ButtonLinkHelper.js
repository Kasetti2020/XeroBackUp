({
    getOppurtunityDetails: function (component, event, helper, idVal) {
        var action = component.get("c.getOppurtunityDetails");
        var idVal = component.get("v.recordId");
        action.setParams({
            "idVal": idVal
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.loaded", true);
                component.set("v.data", response.getReturnValue());
        
        
            } else if (state === "ERROR") {
                component.set("v.toggleSpinner", false);
                var errors = response.getError();
                helper.showToast(component,event,helper,'error','Failed to get details Try sometime later/ Contact Admin');
                
            }
        });
        $A.enqueueAction(action);

    },

    updateOppLineItems: function (component, event, helper, recId, qty, discount) {
        var action=component.get("c.updateOppLineItems");
        action.setParams({
            "recId": recId,
            "qty": qty,
            "discount": discount
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var idVal = component.get("v.recordId");
                helper.getOppurtunityDetails(component,event, helper,idVal);
            } else if (state === "ERROR") {
                component.set("v.toggleSpinner", false);
                var errors = response.getError();
                helper.showToast(component,event,helper,'error','Failed to Update product details Try sometime later/ Contact Admin');
            }
        });
        $A.enqueueAction(action);

    },
    getAccountDetails: function (component, event, helper, idVal) {
        var action = component.get("c.getAccountDetails");
        action.setParams({
            "idVal": idVal,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.oppDetails", response.getReturnValue());
            } else if (state === "ERROR") {
                component.set("v.toggleSpinner", false);
                var errors = response.getError();
                helper.showToast(component,event,helper,'error','Failed to get details Try sometime later/ Contact Admin');
    
            }
        });
        $A.enqueueAction(action);
    },
        showToast: function(component, Event,helper, type, message){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : type,
                message: message,
                duration:' 5000',
                key: 'info_alt',
                type: type,
                mode: 'dismissible'
            });
            toastEvent.fire();
        },

        dataValidation: function(component, Event, helper){
            var validation = [false, false, false, false, false,false];
            var street = component.find("street");
            var city = component.find("city");
            var state = component.find("state");
            var country = component.find("country");
            var postalCode = component.find("postalCode");
            var email = component.find("emailId");
    
            if (street.get("v.value") == null || street.get("v.value") == '') {
                street.setCustomValidity('Street Cannot Be Empty');
                validation[0] = false;
            }
            else {
                street.setCustomValidity('');
                validation[0] = true;
            }

            if (city.get("v.value") == null || city.get("v.value") == '') {
                city.setCustomValidity('City Cannot be Blank');
                validation[1] = false;
            }
            else {
                city.setCustomValidity('');
                validation[1] = true;
            }

            if (state.get("v.value") == null || state.get("v.value") == '') {
                state.setCustomValidity('State Cannot be Blank');
                validation[2] = false;
            }
            else {
                state.setCustomValidity('');
                validation[2] = true;
            }

            if (country.get("v.value") == null || country.get("v.value") == '') {
                country.setCustomValidity('Country Cannot be Blank');
                validation[3] = false;
            }
            else {
                country.setCustomValidity('');
                validation[3] = true;
            }
            if(postalCode.get("v.value") == null){
                postalCode.setCustomValidity('Postal Code Cannot be Blank');
                validation[4] = false;
            }
           else if (!postalCode.get("v.value").match(/(^[0-9]{6}$)/)) {
               postalCode.setCustomValidity('Invalid Pincode');
                validation[4] = false;
            }
             else {
                postalCode.setCustomValidity('');
                validation[4] = true;
            }
            if(email.get("v.value") == null){
                validation[5] = false;
                email.setCustomValidity('Email Field Cannot be Blank');
            }
            else if (!(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(email.get("v.value")))) {
                validation[5] = false;
                email.setCustomValidity('Enter Proper Email Address');
            } else {
                email.setCustomValidity('');
                validation[5] = true;
            }
            
            street.reportValidity();
            state.reportValidity();
            city.reportValidity();
            country.reportValidity();
            postalCode.reportValidity();
            email.reportValidity();
            var dataok = false;
            
            for (let i = 0; i < validation.length; i++) {
        
                if (validation[i] == false) {
                    dataok = false;
                    break;
                }
                else {
                    dataok = true;
                }
            }  
            return dataok;
        }
})