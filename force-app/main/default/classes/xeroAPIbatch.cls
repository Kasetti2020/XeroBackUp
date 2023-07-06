global with sharing class xeroAPIbatch implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {

 // instance member to retain state across transactions
    public  list<XeroInvoice> Xinvoice =new list<XeroInvoice>();
    list<string> ids= new list<string>();
    list<string> satus= new list<string>();
    Map<string,string> oldMap = new Map<string,string>();
    Map<string,Map<string,Map<string,string>>> oldMap1 = new Map<string,Map<string,Map<string,string>>>();
    public xeroAPIbatch(List<XeroInvoice> invoc)
    {
        
        this.Xinvoice=invoc;
        system.debug('this.Xinvoice::'+this.Xinvoice);
    }
    global Integer recordsProcessed = 0;
    
    //String ids=Xinvoice.InvoiceID;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Xinvoice=xeroAPI.getInvoices();
        for(integer i=0;i<Xinvoice.size();i++){
            ids.add(Xinvoice[i].InvoiceID);
            oldMap.put(Xinvoice[i].InvoiceID, Xinvoice[i].Status);
        }
        
        return Database.getQueryLocator('select Id, KT_XERO_Connect__Status__c,KT_XERO_Connect__Invoice_Id__c from KT_XERO_Connect__Invoices__c where KT_XERO_Connect__Invoice_Id__c IN: ids');
        
    }
    global void execute(Database.BatchableContext bc, List<KT_XERO_Connect__Invoices__c> scope){
        Map<list<string>,list<string>> xeroMaps=new  Map<list<string>,list<string>>();
        xeroMaps.put(ids,satus);

        list<KT_XERO_Connect__Invoices__c> invcList= new list<KT_XERO_Connect__Invoices__c>();
        for(KT_XERO_Connect__Invoices__c invoiceRec : scope){
            String mapVal = oldMap.get(invoiceRec.KT_XERO_Connect__Invoice_Id__c);
            KT_XERO_Connect__Invoices__c invc = new KT_XERO_Connect__Invoices__c();
            invc.Id = invoiceRec.Id;
            invc.KT_XERO_Connect__Status__c = oldMap.get(invoiceRec.KT_XERO_Connect__Invoice_Id__c);
            invcList.add(invc);
        }
        update invcList;
        // process each batch of records
        //  List<XeroInvoice> invoc=new  List<XeroInvoice>(xeroAPI.getInvoices());
    }
    global void finish(Database.BatchableContext bc){
    }
}