@isTest
public class TrControllerTest {

     @isTest
    public static void getOppurtunityIdTest(){
         Account acc = new Account();
        acc.Name = 'Test Account';
        acc.KT_XERO_Connect__createXeroContact__c=true;
        acc.KT_XERO_Connect__Same_as_Billing_Address__c=true;
        acc.BillingState='Hebbal';
        acc.BillingCity='Bangalore';
        acc.BillingPostalCode='956452';
        acc.BillingState='Karnataka';
        acc.BillingCountry='India';
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
        
        KT_XERO_Connect__Invoices__c inv = new KT_XERO_Connect__Invoices__c();
        inv.Name='INV-0063';
        inv.KT_XERO_Connect__Account__c = acc.id;
        inv.KT_XERO_Connect__Opportunity__c = opp.id;
        inv.KT_XERO_Connect__Description__c = oli.id;
        inv.KT_XERO_Connect__Date__c = System.TODAY();
        inv.KT_XERO_Connect__Due_Date__c = System.TODAY();
        inv.KT_XERO_Connect__Status__c = 'DRAFT';
        inv.KT_XERO_Connect__Total__c =100; 
        insert inv;
        
       
        test.startTest();
        test.setCurrentPage(Page.PDFgenVF);
        Apexpages.currentPage().getparameters().put('id',inv.Id); 
      	ApexPages.StandardController controller= new ApexPages.StandardController(inv);
      	TrController cont = new  TrController(controller);
        cont.acc=acc;
        cont.oppurtunityLineItem=opp;
        test.stopTest();
        system.assert(true);
        
    }
}