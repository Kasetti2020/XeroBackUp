// description Handles the physical callout to the Xero API

public with sharing class XeroCalloutService {
    
    
    // * description Execute the physical callout and return the response
    // * return Returns the HttpResponse from the Xero API
    
    public static HttpResponse executeCallout (String method, String resourceName) {
        return executeCallout(method, resourceName, null, null);
    }
    
    public static HttpResponse executeCallout (String method, String resourceName, String requestBody) {
        return executeCallout(method, resourceName, requestBody, null);
    }
    
    public static HttpResponse executeCallout (String method, String resourceName, String requestBody, Map<String, String> headers) {
        System.debug('method>>>'+method);
        System.debug('resourceName>>>'+resourceName);
        System.debug('requestBody>>>'+requestBody);
        // Instantiate a new request
        HttpRequest request = new HttpRequest();
        
        // Set request parameters
        request.setMethod(method);
        
        // Set the endpoint using the named credential
        request.setEndpoint(
            'callout:Xero/' + 
            (resourceName.equalsIgnoreCase('connections') ? 'connections': 'api.xro/2.0/' + resourceName)
        );
        
        // Accept a JSON response from the call
        request.setHeader('Accept', 'application/json');
        KT_XERO_Connect__Xero__mdt xeroTenantId  = KT_XERO_Connect__Xero__mdt.getInstance('XeroTenant');
        
        // Set the Xero Tenant ID
        request.setHeader('xero-tenant-id', xeroTenantId.KT_XERO_Connect__Xero_Tenant_Id__c);
        
        // Set max timeout
        request.setTimeout(120000);
        
        // If the callout includes a body (POST and PUT requests)
        if (String.isNotBlank(requestBody)) {
            
            // Set the body to the callout
            request.setBody(requestBody);
            
            // Set the content to XML
            request.setHeader('Content-Type', 'application/json');
        }
        // If we have headers passed into the method, add them to the request
        if (headers != null && !headers.isEmpty()) {
            for (String headerKey :headers.keySet()) {
                request.setHeader(headerKey, headers.get(headerKey));
            }
        }
        // Debug headers
        if (headers != null && !headers.isEmpty()) {
            for(String headerKey :headers.keySet()) {
            }
        }
        // Execute the callout
        HttpResponse response = new Http().send(request);
        system.debug('response>>>'+response);
        return response;
    }  
    
    public static String getTenantIdDynamically(){
        String method = 'GET';
        String resourceName = 'connections';
        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setEndpoint(
            'callout:Xero/' + 
            (resourceName.equalsIgnoreCase('connections') ? 'connections': 'api.xro/2.0/' + resourceName)
        );
        request.setHeader('Accept', 'application/json');
        HttpResponse response = new Http().send(request);
        List<XeroConnection> xeroConnections = (List<XeroConnection>) JSON.deserialize(response.getBody(), List<XeroConnection>.class);
        String xeroTenantId = xeroConnections[0].tenantId;
        
        return xeroTenantId;
    }
    
    
}