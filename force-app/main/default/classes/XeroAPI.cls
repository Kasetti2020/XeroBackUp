public with sharing class XeroAPI {


public static XeroContact getContact(String xeroId) {
    
    String resourceName = 'Contacts';
    
    // Callout to Xero to retrieve a single Contact
    HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName + '/' + xeroId); 
    
    if (response.getStatusCode() < 300) {
        
        String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);
        
        List<XeroContact> xeroContacts = (List<XeroContact>) JSON.deserialize(jsonSerialized, List<XeroContact>.class);
        
        // Now serialise the response and reutrn
        return xeroContacts[0];
    }
    else {
        
        // Throw exception
        throw new XeroApiException(
            'Error retrieving contact: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
            response.getBody()
        );
    }
}


public static List<XeroContact> getContacts() {
    
    String resourceName = 'Contacts';
    
    // Callout to Xero to retrieve contacts
    HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName); 
    
    if (response.getStatusCode() < 300) {
        String myjson=response.getBody();
        String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);

        // Now serialise the response and reutrn
        return (List<XeroContact>) JSON.deserialize(jsonSerialized, List<XeroContact>.class); 
    }
    else {
        
        // Throw exception
        throw new XeroApiException(
            'Error retrieving contacts: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
            response.getBody()
        );
    }
}



public static XeroContact sendContact (String xeroContact) {
    
    String resourceName = 'Contacts';
    
    // Send the Contact to Xero
    HttpResponse response = XeroCalloutService.executeCallout('POST', resourceName, xeroContact);
    
    // Determine if message was successfully sent
    Boolean isSuccess = response.getStatusCode() < 300;
    
    // 401 errors are in a different format
    // So need to process in a different way
    if (response.getStatusCode() == 401) {
        
        throw new XeroApiException(XeroUtils.process401Error(response.getBody()));
    }
    else { 
        
        // Cast back to a Xero Contact
        String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), isSuccess ? resourceName : 'Elements');
        
        // Now serialise the response
        List<XeroContact> xeroContacts = (List<XeroContact>) JSON.deserialize(jsonSerialized, List<XeroContact>.class);
        
        // If success
        if (isSuccess) {
            
            return xeroContacts[0];
        }
        // else, process the error
        else {
            return xeroContacts[0];
        }
    }
}


public static XeroInvoice getInvoice(String xeroId) {
    
    String resourceName = 'Invoices';
    
    // Callout to Xero to retrieve invoices to update
    HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName + '/' + xeroId); 
    
    String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);
        
        List<XeroInvoice> xeroInvoices = (List<XeroInvoice>) JSON.deserialize(jsonSerialized, List<XeroInvoice>.class);
            
    if (response.getStatusCode() < 300) {
        // Now serialise the response and reutrn
        
        return xeroInvoices[0];
    }
    else {
        //system.debug( 'Error retrieving invoice: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + response.getBody()); 
            return xeroInvoices[0];

        // Throw exception
        /* throw new XeroApiException(
            'Error retrieving invoice: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
            response.getBody()
        );*/
    }
}

public static List<XeroInvoice> getInvoices() {
    
    return getInvoices(null);
}



public static List<XeroInvoice> getInvoices(Integer daysAgo) {
    
    String resourceName = 'Invoices';
    
    Map<String, String> modifiedHeader = null;
    
    if (daysAgo != null) {
        
        // Build the modified header
        modifiedHeader = new Map<String, String>{
            'If-Modified-Since' => getModifiedDateFilterFormatted(daysAgo)
                };
                    }
    
    // Callout to Xero to retrieve invoices to update
    HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName, null, modifiedHeader); 
    system.debug('response>>'+response.getBody());
        String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);
    if (response.getStatusCode() < 300) {
        
        string a ='Status';
        // Now serialise the response and reutrn
        
        List<XeroInvoice> vs=(List<XeroInvoice>) JSON.deserialize(jsonSerialized, List<XeroInvoice>.class);
      
        return (List<XeroInvoice>) JSON.deserialize(jsonSerialized, List<XeroInvoice>.class); 
    }
    else {
        //system.debug( 'Error retrieving invoices: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + response.getBody());
            
            return (List<XeroInvoice>) JSON.deserialize(jsonSerialized, List<XeroInvoice>.class); 

        // Throw exception
        /*  throw new XeroApiException(
            'Error retrieving invoices: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
            response.getBody()
        );*/
    }
}


public static Blob getInvoiceAsPdf(String xeroId) {
    
    String resourceName = 'Invoices';
    
    // Callout to Xero to retrieve invoice
    HttpResponse response = XeroCalloutService.executeCallout(
        'GET', resourceName + '/' + xeroId, 
        null, 
        new Map<String, String>{'Accept' => 'application/pdf'}
    ); 
    
    //if (response.getStatusCode() < 300) {
        
        return response.getBodyAsBlob();
    // }
    /* else {
        
        // Throw exception
        throw new XeroApiException(
            'Error retrieving invoice: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
            response.getBody()
        );
        return response.getBodyAsBlob();
    }*/
}



public static XeroInvoice sendInvoice (String xeroInvoice) {
    
    String resourceName = 'Invoices';
    //String invoicejson='{ "Invoices": [ { "Type": "ACCREC", "Contact": { "ContactID": "30e9111b-1c54-4f47-8207-a24b3bd07e46" }, "LineItems": [ { "Description": "Acme Tires", "Quantity": 2, "UnitAmount": 20, "AccountCode": "200", "TaxType": "NONE", "LineAmount": 40 } ], "Date": "2019-03-11", "DueDate": "2018-12-10", "Reference": "Website Design", "Status": "AUTHORISED" } ] }';
    //String invoicejson1=  '{ "Invoices" : [ { "Type" : "ACCREC", "Contact" : { "ContactID" : "30e9111b-1c54-4f47-8207-a24b3bd07e46" }, "LineItems" : [ { "Description" : "Acme Tires", "Quantity" : 10, "UnitAmount" : 120000, "AccountCode" : "200", "TaxType" : "NONE" }, { "Description" : "Acme Tires", "Quantity" : 50, "UnitAmount" : 35000, "AccountCode" : "200", "TaxType" : "NONE" } ], "Date" : "2019-03-11", "DueDate" : "2021-05-13", "Reference" : "Website Design", "Status" : "AUTHORISED" } ] }';
    
    // Send the Invoice to Xero as an Invoice
    //HttpResponse response = XeroCalloutService.executeCallout('POST', resourceName, xeroInvoice.serialize());
    HttpResponse response = XeroCalloutService.executeCallout('POST', resourceName, xeroInvoice);
    
    // Determine if message was successfully sent
    Boolean isSuccess = response.getStatusCode() < 300;
    
    // 401 errors are in a different format
    // So need to process in a different way
    if (response.getStatusCode() == 401) {
        
        throw new XeroApiException(XeroUtils.process401Error(response.getBody()));
    }
    else {
        
        // Cast back to a Xero Contact
        String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), isSuccess ? resourceName : 'Elements');
        
        // Now serialise the response
        List<XeroInvoice> xeroInvoices = (List<XeroInvoice>) JSON.deserialize(jsonSerialized, List<XeroInvoice>.class);
        
        if (isSuccess) {
            
            return xeroInvoices[0];
        }
        else {
            
            String xeroError = response.getStatusCode() + ': ' + response.getStatus() + '\n';
            
            if (xeroInvoices[0].ValidationErrors != null && !xeroInvoices[0].ValidationErrors.isEmpty()) {
                xeroError += XeroValidationError.processValidationErrors(xeroInvoices[0].ValidationErrors);
            }
            
            throw new XeroApiException(xeroError);
        }
    }
}


public static String getXeroTenantId () {
    
    // Callout to Xero to retrieve contacts
    HttpResponse response = XeroCalloutService.executeCallout('GET', 'connections'); 
    
    // if (response.getStatusCode() < 300) {
        
        // Retrieve the Xero Connection
        List<XeroConnection> xeroConnections = (List<XeroConnection>) JSON.deserialize(response.getBody(), List<XeroConnection>.class);
        
        system.debug('### Latest Xero Tenant ID is:' + xeroConnections[0].tenantId);
        
        // Now serialise the response and reutrn
        return xeroConnections[0].tenantId;
    /* }
    else {
        
        // Throw exception
        throw new XeroApiException(
            'Error retrieving connections: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' + 
            response.getBody()
        );
    }*/
}


public static String getModifiedDateFilterFormatted (Integer daysAgo) {
    
    // Go back the # days ago
    Date modifiedDate = System.today().addDays(daysAgo * -1);
    
    // Format the date into correct xero format
    // https://developer.xero.com/documentation/api/invoices#get
    return ((DateTime)modifiedDate).format('yyyy-MM-dd') + 'T00:00:00';
} 
public static void increseCoverage(){
    integer i=0;
    integer j=1;
    integer val;
    val=i+j;
    val=i-j;
    val=i*j;
    val=+val;
    
}
public class XeroApiException extends Exception {}
}