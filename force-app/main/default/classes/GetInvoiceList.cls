public with sharing class GetInvoiceList {
@AuraEnabled
    public static List<Invoices__c> getInvoiceList(String idVal)    
    {   
        system.debug('idVal>>'+idVal);
       List<Invoices__c> lstInvoice;
            lstInvoice=[SELECT Name, KT_XERO_Connect__Opportunity__c, KT_XERO_Connect__Status__c, Account__r.Name,
            KT_XERO_Connect__Date__c, KT_XERO_Connect__Due_Date__c, KT_XERO_Connect__Total__c FROM KT_XERO_Connect__Invoices__c 
                                      WHERE KT_XERO_Connect__Opportunity__c=:idVal WITH SECURITY_ENFORCED ORDER BY CreatedDate ];                         
        system.debug('lstInvoice>>'+lstInvoice);
        return lstInvoice; 
    } 

}