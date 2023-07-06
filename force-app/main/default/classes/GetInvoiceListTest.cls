@isTest
private class GetInvoiceListTest {
    @isTest
    static void getInvoiceList() {
        Account testAccount = new Account(
            Name='Akhilesh',
            Phone='9844818037',
            KT_XERO_Connect__Email__c='akhilesh@gmail.com',
            KT_XERO_Connect__createXeroContact__c=true,
            KT_XERO_Connect__Same_as_Billing_Address__c=true
        );
        insert testAccount;
        Opportunity testOpportunity = new Opportunity(
            Name='Sales',
            Amount=1000000,
            CloseDate= Date.newInstance(2022,02,18),
            AccountId=testAccount.Id,
            StageName='Perception Analysis'
        );
        insert testOpportunity;
        
        KT_XERO_Connect__Invoices__c testInvoice = new KT_XERO_Connect__Invoices__c(
            KT_XERO_Connect__Date__c=Date.newInstance(2022, 02, 19),
            KT_XERO_Connect__Due_Date__c= Date.newInstance(2022, 02, 18),
            KT_XERO_Connect__Status__c= 'DRAFT',
            KT_XERO_Connect__Total__c=100000,
            KT_XERO_Connect__Account__c=testAccount.Id,
            KT_XERO_Connect__Opportunity__c=testOpportunity.Id
        );
        insert testInvoice;

        List<KT_XERO_Connect__Invoices__c> listOfInvoice = [SELECT Name, KT_XERO_Connect__Opportunity__c, KT_XERO_Connect__Status__c, 
        KT_XERO_Connect__Account__r.Name, KT_XERO_Connect__Date__c,KT_XERO_Connect__Due_Date__c,    
        KT_XERO_Connect__Total__c FROM KT_XERO_Connect__Invoices__c WHERE KT_XERO_Connect__Opportunity__c=:testOpportunity.Id ORDER BY CreatedDate LIMIT 3 ];
        List<KT_XERO_Connect__Invoices__c> actual = GetInvoiceList.getInvoiceList(testOpportunity.Id);

        System.assertEquals(listOfInvoice, actual);
        // System.debug([SELECT Name FROM Contact WHERE AccountId=:testAccount.Id ]));
    }
}