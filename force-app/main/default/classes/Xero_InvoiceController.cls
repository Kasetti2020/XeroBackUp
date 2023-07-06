public with sharing class Xero_InvoiceController {
//* Check if xero account ID value is present, if Id present contact in xero.com already exist
@AuraEnabled
public static boolean checkXeroAccountId(String idVal)
{
    boolean isAccountIdPresent = false;
    
    Opportunity[] oppurtunityItem =  [SELECT Id, KT_XERO_Connect__Xero_account_ID__c FROM Opportunity WHERE Id =:idVal WITH SECURITY_ENFORCED];
    
    if(oppurtunityItem[0].Xero_account_ID__c != Null){
        isAccountIdPresent = true;
    } else {
        oppurtunityItem=null;
    }
    return isAccountIdPresent;
}

// Get account details for creating xero contact
@AuraEnabled
public static Contact getAccountDetails(String idVal)
{    
Opportunity oppurtunityItem =  [SELECT Id,AccountId FROM Opportunity WHERE Id = :idVal WITH SECURITY_ENFORCED limit 1 ];
Contact contactItem =  [SELECT id,Name,Email,Account.Name,Account.BillingCountry,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingStreet FROM Contact WHERE AccountId = :oppurtunityItem.AccountId WITH SECURITY_ENFORCED limit 1];
return contactItem;
}

//* Get opportunity details along with opportunityLineItems to create invoice
@AuraEnabled
public static List<Opportunity> getOppurtunityDetails(String idVal)
{    
 List<Opportunity> oppurtunityLineItem = new List<Opportunity>();
 if(idVal != null){
  oppurtunityLineItem =  [SELECT Id, Name, Account.Name, KT_XERO_Connect__XeroContactId__c, 
                                           Account.BillingAddress, Account.BillingCountry ,Account.BillingPostalCode,Account.BillingStreet,Account.BillingState,
                                           Account.BillingCity,CloseDate,CreatedDate, KT_XERO_Connect__OrderNumber__c, KT_XERO_Connect__Total_Amount_Paid__c, 
                                           (SELECT Id,Quantity, UnitPrice,TotalPrice, Discount, Description,ProductCode,
                                           OpportunityId,KT_XERO_Connect__ItemId__c, PricebookEntry.Name, KT_XERO_Connect__Account_Type__c , 
                                            PricebookEntry.Product2.Family FROM OpportunityLineItems)
                                            FROM Opportunity  WHERE Id = :idVal WITH SECURITY_ENFORCED];
 }
 return oppurtunityLineItem;
}



    @AuraEnabled
    public static KT_XERO_Connect__Invoices__c getOppurtunityId(String idVal)
    {
        String isAccountIdPresent;
        Invoices__c oppurtunityItem =  [SELECT id, KT_XERO_Connect__Opportunity__c , Name , KT_XERO_Connect__To__c, 
        KT_XERO_Connect__Account__r.name,KT_XERO_Connect__Date__c,KT_XERO_Connect__Due_Date__c,KT_XERO_Connect__Opportunity__r.Name ,KT_XERO_Connect__Total__c,
        KT_XERO_Connect__Description__c,KT_XERO_Connect__Status__c  
        FROM KT_XERO_Connect__Invoices__c WHERE Id=:idVal WITH SECURITY_ENFORCED];
        if(oppurtunityItem.KT_XERO_Connect__Opportunity__c != Null){
            isAccountIdPresent = oppurtunityItem.KT_XERO_Connect__Opportunity__c;
        }
        return oppurtunityItem;
    }
    
    @AuraEnabled
    public static list<OpportunityLineItem> getoppLineItems(String idVal)
    {
        List<String> res = idVal.split(',');
        
        list<OpportunityLineItem>  oppItemList =  [SELECT Id,Quantity, UnitPrice, TotalPrice, Description,ProductCode,OpportunityId,
                                                   PricebookEntry.Name, KT_XERO_Connect__Account_Type__c, PricebookEntry.Product2.Family 
                                                   FROM OpportunityLineItem 
                                                   WHERE Id IN: res WITH SECURITY_ENFORCED];
        return oppItemList;
    }
    
//*Remove Individual Opportunity Line Items
    @AuraEnabled
    public static Void deleteOppurtunityLineItemRecord(String idVal)
    {
        OpportunityLineItem lineItem = [SELECT id FROM OpportunityLineItem where Id =: idVal];
        if(OpportunityLineItem.SObjectType.getDescribe().isDeletable()){
            delete lineItem;
        }
    }
    
    @AuraEnabled
    public static void updateOppLineItems(String recId , String qty , String discount)
    {
        if(qty != '' && discount == ''){
            OpportunityLineItem lineItem = [SELECT id , Quantity ,UnitPrice, Discount FROM OpportunityLineItem 
                                            where Id =: recId];
            lineItem.Quantity = decimal.valueOf(qty);
            if(OpportunityLineItem.SObjectType.getDescribe().isUpdateable()){
                
                update lineItem;
            }
        }
        if(discount != '' && qty == ''){
            OpportunityLineItem lineItem = [SELECT id , Quantity ,UnitPrice, Discount FROM OpportunityLineItem 
                                            where Id =: recId];
            lineItem.Discount = decimal.valueOf(discount);
            if(OpportunityLineItem.SObjectType.getDescribe().isUpdateable()){
                update lineItem;
            }
        }
    }
    
    @AuraEnabled
    public static  void sendInvoice(String jsonString , Date dateVal){
        String str = '';
        String strng = '';
        // Xero_InvoiceController p = (Xero_InvoiceController)JSON.deserialize(jsonString, Xero_InvoiceController.class);
        String removedSpaces = jsonString.replaceAll('KT_XERO_Connect__','');
        List<Xero_InvoiceController> oppItems = (List<Xero_InvoiceController>) System.JSON.deserialize(removedSpaces.replaceAll('__c',''), List<Xero_InvoiceController>.class);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('Invoices');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeObjectField('Type','ACCREC');
        gen.writeFieldName('Contact');
        gen.writeStartObject();
        gen.writeObjectField('ContactID',oppItems[0].XeroContactId);
        gen.writeEndObject();
        gen.writeFieldName('LineItems');
        gen.writeStartArray();
        
        for (OpportunityLineItems valOpportunityLineItems : oppItems[0].OpportunityLineItems){
            str = str  + valOpportunityLineItems.id + ',';
            gen.writeStartObject();
            gen.writeObjectField('Description',valOpportunityLineItems.PricebookEntry.Name);
            gen.writeObjectField('Quantity',valOpportunityLineItems.Quantity);
            gen.writeObjectField('UnitAmount',valOpportunityLineItems.UnitPrice);
            gen.writeObjectField('AccountCode',valOpportunityLineItems.Account_Type);
            gen.writeObjectField('TaxType','NONE');
            if(valOpportunityLineItems.Discount == null || valOpportunityLineItems.Discount == 0){
                gen.writeObjectField('DiscountRate','0');
            }else
            {
                gen.writeObjectField('DiscountRate',valOpportunityLineItems.Discount);
            }
            // gen.writeObjectField('LineAmount',valOpportunityLineItems.TotalPrice);
            gen.writeEndObject();
        }
        gen.writeEndArray();
        gen.writeObjectField('Date',oppItems[0].CreatedDate);
        gen.writeObjectField('DueDate',dateVal);
        gen.writeObjectField('Reference',oppItems[0].OpportunityLineItems[0].OpportunityId);
        gen.writeObjectField('Status','DRAFT');
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeEndObject();
        string payload=gen.getAsString();
        XeroInvoice xeroRef = XeroAPI.sendInvoice(payload);
        strng = str.substring(0,str.length() - 1);
        
        KT_XERO_Connect__Invoices__c newInvRecord = new KT_XERO_Connect__Invoices__c();
        newInvRecord.Name= xeroRef.InvoiceNumber;
        newInvRecord.KT_XERO_Connect__Invoice_Id__c = xeroRef.InvoiceID;
        newInvRecord.KT_XERO_Connect__Description__c = strng;
        newInvRecord.KT_XERO_Connect__Status__c = xeroRef.Status;
        newInvRecord.KT_XERO_Connect__Account__c = oppItems[0].AccountId; 
        newInvRecord.KT_XERO_Connect__Opportunity__c = oppItems[0].Id; 
        newInvRecord.KT_XERO_Connect__Due_Date__c = Date.valueOf(oppItems[0].CloseDate); 
        newInvRecord.KT_XERO_Connect__Date__c = dateVal; 
        newInvRecord.KT_XERO_Connect__Total__c =xeroRef.Total;
        newInvRecord.KT_XERO_Connect__Contact_Id__c =oppItems[0].XeroContactId;
        if(KT_XERO_Connect__Invoices__c.SObjectType.getDescribe().isCreateable()){
            if(!test.isRunningTest()){
                Insert newInvRecord;
            }
        	
        }
        // return p;
    }  
    
    @AuraEnabled
    public static void sendContact(String jsonString ,String oppId){
        String removedSpaces = jsonString.replaceAll('KT_XERO_Connect__','');
        Xero_InvoiceController oppItems = (Xero_InvoiceController) System.JSON.deserialize(removedSpaces.replaceAll('__c',''), Xero_InvoiceController.class);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('Contacts');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeObjectField('Name',oppItems.Name);
        gen.writeObjectField('EmailAddress',oppItems.Email);
        gen.writeFieldName('Addresses');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeObjectField('AddressType','POBOX');
        gen.writeObjectField('AddressLine1',oppItems.Account.BillingStreet);
        gen.writeObjectField('City',oppItems.Account.BillingCity);
        gen.writeObjectField('PostalCode',oppItems.Account.BillingPostalCode);
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeEndObject();
        string payload=gen.getAsString();
        XeroContact xeroRef = XeroAPI.sendContact(payload);
        string expct = oppItems.AccountId;
        JsonGenerater.sendContacts( oppItems.AccountId ,  xeroRef.ContactID , oppId);
    }
    
    
    
    public class BillingAddress {
        public String Street;
        public String City;
        public String State;
    }
    
    public class Account {
        public String Name;
        public String BillingCity;
        public BillingAddress BillingAddress;
        public String BillingState;
        public String BillingStreet;
        public String BillingPostalCode; 
        public String Xero_contact_ID;
        public String Id;
    }
    
    public String Id;
    public String Name;
    public String AccountId;
    public String Email;
    public String CloseDate;
    public String CreatedDate;
    public String OrderNumber;
    public String DeliveryInstallationStatus;
    public String XeroContactId; 
    public String MyobContactId; 
    public List<OpportunityLineItems> OpportunityLineItems;
    public Account Account;
    
    public class Product2 {
        public String Id;
    }
    
    public class OpportunityLineItems {
        public String OpportunityId;
        public String Id;
        public Integer Quantity;
        public Integer UnitPrice;
        public Integer TotalPrice;
        public Integer Discount;
        public String ProductCode;
        public String PricebookEntryId;
        public String Account_Type;
        public String ItemId;
        public PricebookEntry PricebookEntry;
    }
    
    public class PricebookEntry {
        public String Name;
        public String Product2Id;
        public String Id;
        public Product2 Product2;
    }
    
}