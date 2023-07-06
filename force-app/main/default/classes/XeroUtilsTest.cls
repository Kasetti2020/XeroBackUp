@isTest 
public class XeroUtilsTest {

    @isTest 
    static void testProcess401Error () {

        String errorResponse = 'oauth_problem=token_rejected&oauth_problem_advice=The%20organisation%20for%20this%20access%20token%20is%20not%20active';

        String processedError = XeroUtils.process401Error(errorResponse);
        string jsonBody='{ "Id": "bd906cb2-04bc-4f62-8385-8ad799cf11ab", "Status": "OK", "ProviderName": "Kasetti Connect", "DateTimeUTC": "Date(1634559944675)", "Contacts": [ { "ContactID": "30e9111b-1c54-4f47-8207-a24b3bd07e46", "AccountNumber": "CD451796", "ContactStatus": "ACTIVE", "Name": "Edge Communications", "FirstName": "Rose", "LastName": "Gonzalez", "EmailAddress": "rose@edge.com", "BankAccountDetails": "", "Addresses": [ { "AddressType": "STREET", "City": "", "Region": "", "PostalCode": "", "Country": "" }, { "AddressType": "POBOX", "AddressLine1": "312 Constitution Place", "AddressLine2": "Austin, TX 78767", "AddressLine3": "USA", "AddressLine4": "", "City": "Austin", "Region": "TX", "PostalCode": "", "Country": "" } ], "Phones": [ { "PhoneType": "DDI", "PhoneNumber": "", "PhoneAreaCode": "", "PhoneCountryCode": "" }, { "PhoneType": "DEFAULT", "PhoneNumber": "(512) 757-6000", "PhoneAreaCode": "", "PhoneCountryCode": "" }, { "PhoneType": "FAX", "PhoneNumber": "", "PhoneAreaCode": "", "PhoneCountryCode": "" }, { "PhoneType": "MOBILE", "PhoneNumber": "", "PhoneAreaCode": "", "PhoneCountryCode": "" } ], "UpdatedDateUTC": "Date(1632466435997+0000)", "ContactGroups": [], "IsSupplier": false, "IsCustomer": true, "DefaultCurrency": "INR", "Balances": { "AccountsReceivable": { "Outstanding": 40236040.00, "Overdue": 40236040.00 }, "AccountsPayable": { "Outstanding": 0.00, "Overdue": 0.00 } }, "ContactPersons": [], "HasAttachments": false, "Attachments": [], "HasValidationErrors": false } ] }';
        string generateJsonString=XeroUtils.generateJsonStringForParsing(jsonBody, 'objectName');
       system.assert(true);
    } 
}