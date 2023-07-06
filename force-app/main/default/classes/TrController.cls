public with sharing class TrController
{
    public KT_XERO_Connect__Invoices__c TimeEntries {get;set;}
    public Opportunity oppurtunityLineItem {get;set;}
    public Account acc {get;set;}
    public List<OpportunityLineItem> SOLIRecs {get;set;}
    public string ReqID {get;set;}
    public TrController(ApexPages.StandardController controller)
    {
        ReqId = Apexpages.currentPage().getparameters().get('Id');  
        LoadData();
    }
    private void LoadData()
    {
        //Load the related time entry records from the database.
        
        TimeEntries = [SELECT id, Name ,KT_XERO_Connect__To__c,KT_XERO_Connect__Account__r.ShippingStreet, 
        KT_XERO_Connect__Account__r.ShippingCity , KT_XERO_Connect__Account__r.ShippingState ,KT_XERO_Connect__Account__r.ShippingPostalCode ,  
        KT_XERO_Connect__Account__r.ShippingCountry,KT_XERO_Connect__Account__r.name,KT_XERO_Connect__Date__c,KT_XERO_Connect__Due_Date__c,KT_XERO_Connect__Opportunity__r.Name, 
        KT_XERO_Connect__Total__c,KT_XERO_Connect__Description__c FROM KT_XERO_Connect__Invoices__c WHERE Id=:ReqID WITH SECURITY_ENFORCED];
        string str = TimeEntries.Description__c;
        List<String> res = str.split(',');
        SOLIRecs =  [SELECT Id,Quantity, UnitPrice, TotalPrice, Description,ProductCode,OpportunityId,
                     PricebookEntry.Name, KT_XERO_Connect__Account_Type__c,PricebookEntry.Product2.Family FROM 
                     OpportunityLineItem WHERE Id IN: res WITH SECURITY_ENFORCED];
    }
}