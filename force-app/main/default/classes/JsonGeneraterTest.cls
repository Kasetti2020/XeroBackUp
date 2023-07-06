@isTest
private  class JsonGeneraterTest {
    @isTest
    private static void sendContacts(){
        Account testAccount = new Account(
            Name='Akhilesh',
            Phone='9844818037',
            Email__c='akhilesh.h.n@gmail.com'
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
        
        Invoices__c testInvoice = new Invoices__c(
            Date__c=Date.newInstance(2022, 02, 19),
            Due_Date__c= Date.newInstance(2022, 02, 18),
            Status__c= 'DRAFT',
            Total__c=100000,
            Account__c=testAccount.Id,
            Opportunity__c=testOpportunity.Id
        );
        insert testInvoice;
         test.startTest();
       String xeroRef ='43c57c67-e106-45a9-bedc-ecbe21e45320';
        boolean result = JsonGenerater.sendContacts(testAccount.Id, xeroRef, testOpportunity.Id);
        
        System.assertEquals(true, result);
           test.stopTest();
    }
    
}