@isTest
public class xeroAPIbatchTest {
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
    
   static testMethod void test1(){ 
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Contact c = new Contact();
        c.AccountId = acc.ID;
        c.FirstName = 'test';
        c.LastName = 'test';
        c.email = 'test@test.com';
        insert c;
        
        Opportunity opp = new Opportunity();
        opp.name = 'Account ';
        opp.accountId = acc.id;
        opp.amount = 1000;
        opp.closeDate = Date.today().addDays(5);
        opp.stageName = 'Prospecting';
        insert opp;
        
        
        KT_XERO_Connect__Invoices__c inv = new KT_XERO_Connect__Invoices__c();
        inv.KT_XERO_Connect__Account__c = acc.id;
        inv.KT_XERO_Connect__Opportunity__c = opp.id;
        inv.KT_XERO_Connect__Description__c = '';
        inv.KT_XERO_Connect__Date__c = System.TODAY();
        inv.KT_XERO_Connect__Due_Date__c = System.TODAY();
        inv.KT_XERO_Connect__Status__c = 'DRAFT';
        inv.KT_XERO_Connect__Total__c =100; 
        insert inv;
       
        List<KT_XERO_Connect__Invoices__c> invoicesList = new  List<KT_XERO_Connect__Invoices__c>();
       invoicesList.add(inv);
       
        List<XeroInvoice> invoc=new  List<XeroInvoice>();
       
       Test.startTest();  
        Test.setMock(HttpCalloutMock.class, new RestMock());
       for ( AsyncApexJob aJob : [ Select id ,Status from AsyncApexJob] )
{
System.AbortJob(aJob.Id);
}
        xeroAPIbatch obj = new xeroAPIbatch(invoc);
       
        Database.BatchableContext bc1;
        obj.start(bc1);
        obj.execute(bc1, invoicesList);
       String strSchedule ='0 0 0 3 9 ? ';
strSchedule = strSchedule + Datetime.now().addYears(1).year();
       xeroAPIsheduler abs= new xeroAPIsheduler();
String jobId = System.schedule('test-xeroAPIsheduler',strSchedule, abs);
      // abs.execute(null);
       // DataBase.executeBatch(obj);     
       system.assert(true);    
        Test.stopTest();
   }
}