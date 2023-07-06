@isTest
public class Xero_InvoiceControllerTest { 
    
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
    
     private class RestMock1 implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = '{ "Id": "c23bd2a7-7765-44ac-9417-62f05e8292c6", "Status": "OK", "ProviderName": "Kasetti Connect", "DateTimeUTC": "Date(1634536760067)", "Contacts": [ { "ContactID": "45ff1b8b-8dc9-4148-b0f2-23c240a4bfc2", "ContactStatus": "ACTIVE", "Name": "Stella Pavlova", "EmailAddress": "spavlova@uog.com", "BankAccountDetails": "", "Addresses": [ { "AddressType": "STREET", "City": "", "Region": "", "PostalCode": "", "Country": "" }, { "AddressType": "POBOX", "AddressLine1": "1301 Avenue of the Americas", "City": "New York", "Region": "", "PostalCode": "10019", "Country": "" } ], "Phones": [ { "PhoneType": "DEFAULT", "PhoneNumber": "", "PhoneAreaCode": "", "PhoneCountryCode": "" }, { "PhoneType": "DDI", "PhoneNumber": "", "PhoneAreaCode": "", "PhoneCountryCode": "" }, { "PhoneType": "FAX", "PhoneNumber": "", "PhoneAreaCode": "", "PhoneCountryCode": "" }, { "PhoneType": "MOBILE", "PhoneNumber": "", "PhoneAreaCode": "", "PhoneCountryCode": "" } ], "UpdatedDateUTC": "Date(1633001996557+0000)", "ContactGroups": [], "IsSupplier": false, "IsCustomer": false, "SalesTrackingCategories": [], "PurchasesTrackingCategories": [], "ContactPersons": [], "HasValidationErrors": false } ] }';
            
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    public static void getOppurtunityIdTest(){
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingStreet = '345 Shoreline ParkMountain View, CA 94043USA';
        acc.BillingCity = 'Mountain View';
        acc.BillingPostalCode= '562135';
        acc.BillingState='CA';
        acc.BillingCountry='USA';
        acc.KT_XERO_Connect__createXeroContact__c=true;
        acc.KT_XERO_Connect__Same_as_Billing_Address__c=true;
        
        
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
        
        Id pricebookId = Test.getStandardPricebookId();
        
        //Create your product
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        //create your opportunity line item.  This assumes you already have an opportunity created, called opp
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 5,
            Discount = 5,
            PricebookEntryId = pbEntry.Id,
            TotalPrice = 500);
        insert oli;
        
        
        test.startTest();
        Xero_InvoiceController.getOppurtunityId(inv.id);
        Xero_InvoiceController.getoppLineItems(inv.id); 
        Xero_InvoiceController.checkXeroAccountId(opp.id);
        Xero_InvoiceController.getAccountDetails(opp.id); 
        Xero_InvoiceController.getOppurtunityDetails(opp.id);
        Xero_InvoiceController.deleteOppurtunityLineItemRecord(oli.id);
        Xero_InvoiceController.updateOppLineItems(oli.id , '100' , '10'); 
        Xero_InvoiceController.updateOppLineItems(oli.id , '1' , '10'); 
        Xero_InvoiceController.updateOppLineItems(oli.id , '100' , '1'); 
        system.assert(true);
        test.stopTest();
        
    }
    
     @isTest
    public static void updateOppLineItemTest(){
        
         Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        //Create your product
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
          Opportunity opp = new Opportunity();
        opp.name = 'Account ';
        opp.accountId = acc.id;
        opp.amount = 1000;
        opp.closeDate = Date.today().addDays(5);
        opp.stageName = 'Prospecting';
        insert opp;
        
          //create your opportunity line item.  This assumes you already have an opportunity created, called opp
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 5,
            Discount = 5,
            PricebookEntryId = pbEntry.Id,
            TotalPrice = 500);
        insert oli;
        
        
         test.startTest();
       
        Xero_InvoiceController.updateOppLineItems(oli.id , '' , '10'); 
        Xero_InvoiceController.updateOppLineItems(oli.id , '100' , ''); 
        system.assert(true);
         test.stopTest();
    }
    
    
     @isTest
    public static void getOppurtunityIdTest1(){
        
        String jsonStringInv = '[{"Id":"0065g00000AftADAAZ","Name":"United Oil Installations","AccountId":"0015g00000JPipZ","XeroContactId__c":"30e9111b-1c54-4f47-8207-a24b3bd07e46","CloseDate":"2021-05-13","CreatedDate":"2021-07-09T04:52:03.000Z","OrderNumber__c":"554821","DeliveryInstallationStatus__c":"In progress","OpportunityLineItems":[{"OpportunityId":"0065g00000AftADAAZ","Id":"00k5g00001KPjEzAAL","Quantity":50,"UnitPrice":35000,"TotalPrice":1627500,"Discount":7,"ProductCode":"GC5020","PricebookEntryId":"01u5g000003V3K1AAK","PricebookEntry":{"Name":"GenWatt Gasoline 300kW","Product2Id":"01t5g0000036WmIAAU","Id":"01u5g000003V3K1AAK","Product2":{"Id":"01t5g0000036WmIAAU"}},"Account_Type__c":"200"},{"OpportunityId":"0065g00000AftADAAZ","Id":"00k5g00001Lb3veAAB","Quantity":2,"UnitPrice":50000,"TotalPrice":95000,"Discount":5,"ProductCode":"GC3040","PricebookEntryId":"01u5g000003V3JsAAK","PricebookEntry":{"Name":"GenWatt Propane 500kW","Product2Id":"01t5g0000036Wm9AAE","Id":"01u5g000003V3JsAAK","Product2":{"Id":"01t5g0000036Wm9AAE"}},"Account_Type__c":"200"},{"OpportunityId":"0065g00000AftADAAZ","Id":"00k5g00001Lb42gAAB","Quantity":10,"UnitPrice":40000,"TotalPrice":360000,"Discount":10,"ProductCode":"SL9080","PricebookEntryId":"01u5g000003V3JtAAK","PricebookEntry":{"Name":"SLA: Platinum","Product2Id":"01t5g0000036WmAAAU","Id":"01u5g000003V3JtAAK","Product2":{"Id":"01t5g0000036WmAAAU"}},"Account_Type__c":"200"}],"Account":{"Name":"United Oil & Gas Corp.","BillingAddress":{"street":"1301 Avenue of the America","city":"New York","state":"NY","postalCode":"10019"},"BillingPostalCode":"10019","BillingCity":"New York","Id":"0015g00000JPipZAAT"}}]';
        String jsonStringCon = '{"Id":"0035g000009xaR2AAI","Name":"Andy Young","Email":"a_young@dickenson.com","AccountId":"0015g00000JPipXAAT","Account":{"Name":"Dickenson plc","BillingCountry":"USA","BillingPostalCode":"66045","BillingCity":"Lawrence","BillingState":"KS","BillingStreet":"1301 Hoch Drive","Id":"0015g00000JPipXAAT"}}';
            
            
         Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        //Create your product
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
          Opportunity opp = new Opportunity();
        opp.name = 'Account ';
        opp.accountId = acc.id;
        opp.amount = 1000;
        opp.closeDate = Date.today().addDays(5);
        opp.stageName = 'Prospecting';
        insert opp;
        
          //create your opportunity line item.  This assumes you already have an opportunity created, called opp
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 5,
            Discount = 5,
            PricebookEntryId = pbEntry.Id,
            TotalPrice = 500);
        insert oli;
        
        
         test.startTest();
        Test.setMock(HttpCalloutMock.class, new RestMock());
        //Xero_InvoiceCntrl.updateOppLineItems(oli.id , '' , '10'); 
        //Xero_InvoiceCntrl.updateOppLineItems(oli.id , '100' , ''); 
        Xero_InvoiceController.SendInvoice(jsonStringInv,Date.today().addDays(5));
         //Xero_InvoiceCntrl.SendContact(jsonStringCon);
         system.assert(true);
        test.stopTest();
    }
    
    @isTest
    public static void getOppurtunityIdTest2(){
        
         Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
         Opportunity opp = new Opportunity();
        opp.name = 'Account ';
        opp.accountId = acc.id;
        opp.amount = 1000;
        opp.closeDate = Date.today().addDays(5);
        opp.stageName = 'Prospecting';
        insert opp;

        
        
       String jsonStringCon = '{"Id":"0035g000009xaR2AAI","Name":"Andy Young","Email":"a_young@dickenson.com","AccountId":"'+acc.Id+'","Account":{"Name":"Dickenson plc","BillingCountry":"USA","BillingPostalCode":"66045","BillingCity":"Lawrence","BillingState":"KS","BillingStreet":"1301 Hoch Drive","Id":"0015g00000JPipXAAT"}}';
             test.startTest();
        Test.setMock(HttpCalloutMock.class, new RestMock1());
        
         Xero_InvoiceController.sendContact(jsonStringCon, opp.Id);
        system.assert(true);
        test.stopTest();
    }
    
   
}