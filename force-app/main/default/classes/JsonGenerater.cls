public class JsonGenerater {

public static boolean sendContacts(String accId , String xeroId , String oppId){
    Account acc = [SELECT Id , KT_XERO_Connect__Xero_contact_ID__c From Account Where id =:accId WITH SECURITY_ENFORCED];
    acc.KT_XERO_Connect__Xero_contact_ID__c = xeroId;
    if(Schema.sObjectType.Account.fields.KT_XERO_Connect__Xero_contact_ID__c.isUpdateable()){
    update acc;
    }
        Opportunity oppurtunityItem =  [SELECT Id, KT_XERO_Connect__XeroContactId__c FROM Opportunity WHERE Id = :oppId WITH SECURITY_ENFORCED];
    oppurtunityItem.KT_XERO_Connect__XeroContactId__c = xeroId;
    if(Schema.sObjectType.Opportunity.fields.KT_XERO_Connect__XeroContactId__c.isUpdateable()){
        update oppurtunityItem;
    }
        return true;
}
}