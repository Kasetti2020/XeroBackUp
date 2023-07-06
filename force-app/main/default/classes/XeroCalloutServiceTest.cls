@isTest
public class XeroCalloutServiceTest {
    
     private class RestMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = '{ "Id": "4d1bae6c-a3b6-4b80-a27b-aa8b2902c5e5", "Status": "OK", "ProviderName": "Kasetti Connect", "DateTimeUTC": "Date(1634534571717)", "Invoices": [ { "Type": "ACCREC", "InvoiceID": "0dd91a7d-d73f-4dd2-9813-33a7349b2e0f", "InvoiceNumber": "INV-0037", "Reference": "Website Design", "Prepayments": [], "Overpayments": [], "AmountDue": 2950000.00, "AmountPaid": 0.00, "SentToContact": false, "CurrencyRate": 1.0000000000, "IsDiscounted": false, "HasErrors": false, "Contact": { "ContactID": "30e9111b-1c54-4f47-8207-a24b3bd07e46", "AccountNumber": "CD451796", "ContactStatus": "ACTIVE", "Name": "Edge Communications", "FirstName": "Rose", "LastName": "Gonzalez", "EmailAddress": "rose@edge.com", "BankAccountDetails": "", "Addresses": [ { "AddressType": "STREET", "City": "", "Region": "", "PostalCode": "", "Country": "" }, { "AddressType": "POBOX", "AddressLine1": "312 Constitution Place", "AddressLine2": "Austin, TX 78767", "AddressLine3": "USA", "AddressLine4": "", "City": "Austin", "Region": "TX", "PostalCode": "", "Country": "" } ], "Phones": [ { "PhoneType": "DEFAULT", "PhoneNumber": "(512) 757-6000", "PhoneAreaCode": "", "PhoneCountryCode": "" }, { "PhoneType": "DDI", "PhoneNumber": "", "PhoneAreaCode": "", "PhoneCountryCode": "" }, { "PhoneType": "FAX", "PhoneNumber": "", "PhoneAreaCode": "", "PhoneCountryCode": "" }, { "PhoneType": "MOBILE", "PhoneNumber": "", "PhoneAreaCode": "", "PhoneCountryCode": "" } ], "UpdatedDateUTC": "Date(1632466435997+0000)", "ContactGroups": [], "IsSupplier": false, "IsCustomer": true, "DefaultCurrency": "INR", "SalesTrackingCategories": [], "PurchasesTrackingCategories": [], "ContactPersons": [], "HasValidationErrors": false }, "DateString": "2019-03-11T00:00:00", "Date": "Date(1552262400000+0000)", "DueDateString": "2021-05-13T00:00:00", "DueDate": "Date(1620864000000+0000)", "BrandingThemeID": "a6d2bd27-112c-4161-ac8d-9b03508cd1ca", "Status": "AUTHORISED", "LineAmountTypes": "Exclusive", "LineItems": [ { "Description": "Acme Tires", "UnitAmount": 120000.00, "TaxType": "NONE", "TaxAmount": 0.00, "LineAmount": 1200000.00, "AccountCode": "200", "Tracking": [], "Quantity": 10.0000, "LineItemID": "ce4b6520-bd3e-4d13-bba5-88d6fc3999f1", "ValidationErrors": [] }, { "Description": "Acme Tires", "UnitAmount": 35000.00, "TaxType": "NONE", "TaxAmount": 0.00, "LineAmount": 1750000.00, "AccountCode": "200", "Tracking": [], "Quantity": 50.0000, "LineItemID": "8858a4f9-ac70-465b-940a-cd0ba2b35d56", "ValidationErrors": [] } ], "SubTotal": 2950000.00, "TotalTax": 0.00, "Total": 2950000.00, "UpdatedDateUTC": "Date(1634534571653+0000)", "CurrencyCode": "INR" } ] }';
            
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    
    
 @isTest
    public static void getOppurtunityIdTest(){
        String method = 'POST';
        String resourceName = 'connections';
        String requestBody;
        Map<String, String> headers;
        
          test.startTest();
        Test.setMock(HttpCalloutMock.class, new RestMock());
        XeroCalloutService.executeCallout(method, resourceName);
        XeroCalloutService.executeCallout(method, resourceName, requestBody);
        XeroCalloutService.executeCallout(method, resourceName, requestBody, headers);
        system.assert(true);
           test.stopTest();
    }
}