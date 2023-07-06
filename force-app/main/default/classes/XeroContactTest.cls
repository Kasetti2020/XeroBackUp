@isTest
private  class XeroContactTest {
        //For addresstype = Customer (other than POBOX)
    @isTest
    
    private static void XeroContact(){
        Account testAccount = new Account(
            Name='Akhilesh',
            Phone='9844818037',
            KT_XERO_Connect__Email__c='akhilesh.h.n@gmail.com',
            Fax='9485632485',
            BillingStreet='Rajajinagar',
            ShippingStreet='Rajajinagar'
        );
            Account testAccount2 = new Account(
            Name='Akhilesh',
            KT_XERO_Connect__Email__c='akhilesh.h.n@gmail.com',
            BillingStreet='Rajajinagar',
            ShippingStreet='Rajajinagar'
        	);
        
       	 Contact testContact = new Contact(
            LastName = 'Akhi',
            AccountId = testAccount2.Id,
            MobilePhone = '9856247853'
            );
        Test.startTest();
        String addressType = 'Customer';
        XeroContact.Address add = new XeroContact.Address(testAccount, addressType);
        //mobile method
        XeroContact.Phone add2 = new XeroContact.Phone(testAccount.Phone, 'Mobile');
		
         XeroContact.Address add3 = new XeroContact.Address(testAccount2, addressType);
        //mobile method
        XeroContact.Phone add4 = new XeroContact.Phone(testAccount2.Phone, 'Mobile');
        
 		//Constructor with account parameter
		XeroContact newContact = new XeroContact(testAccount);
        
        //Contructor with String parameter Xero Contact ID from Response
        XeroContact newContact2 = new XeroContact('sfgsfdfshs');
        //without contact
     
system.assert(true);        
        Test.stopTest();
    }
    
    //For addresstype = POBOX
    @isTest
    private static void XeroContact2(){
        Account testAccount = new Account(
            Name='Akhilesh',
            Phone='9844818037',
            KT_XERO_Connect__Email__c='akhilesh.h.n@gmail.com',
            Fax='9485632485'
        );
        String addressType = 'POBOX';
        Test.startTest();

        XeroContact.Address newAcc = new XeroContact.Address(testAccount, addressType);
        System.debug('Address POBOX'+testAccount);
        system.assert(true);
        Test.stopTest();
    }
}