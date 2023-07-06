@isTest
private class XeroInvoiceTest {
    @isTest
    static void XeroInvoice() {
        Account testAccount = new Account(
            Name='Akhilesh',
            Phone='9844818037',
            KT_XERO_Connect__Email__c='akhilesh.h.n@gmail.com'
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
        XeroInvoice inv = new XeroInvoice('sgjsnffg');
        system.assert(true);
    
    }
    
}