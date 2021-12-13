@isTest
private class TestContactManager {
    
    @isTest static void getContact() {
        // Create a contact
        Contact newContact = new Contact(LastName = 'Test', Email__c = 'test@salesforce.com');
        insert newContact;
        Id contactId = newContact.Id;
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://brave-koala-hkbmbl-dev-ed.my.salesforce.com/services/apexrest/Contacts/'
            + contactId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Contact myContact = ContactManager.getContact();
        // Verify results
        System.assert(myContact != null);
        System.assertEquals('Test', myContact.LastName);
    }
    
    @isTest static void createExistingContact() {
        // Create a contact
        Contact newContact = new Contact(LastName = 'Test', Email__c = 'test@salesforce.com');
        insert newContact;
        // Use class method to create a contact with existing email
        Id myContactId = ContactManager.createContact('Contact', 'Martin', 'test@salesforce.com');
        // Check contacts
        List<Contact> contacts = [ SELECT Id, LastName, Email__c FROM Contact WHERE Email__c LIKE 'test@salesforce.com'];
        System.assertEquals(1, contacts.size());
        System.assertEquals('Test', contacts.get(0).LastName);
        System.assertEquals(newContact.Id, contacts.get(0).Id);
    }
    
    @isTest static void createNewContact() {
        // Use class method to create a new Contact
        Id contactId = contactManager.createContact('Test', 'Martin', 'test@hotmail.com');
        // Verify results
        System.assert(contactId != null);
        Contact myContact = [ SELECT Id, LastName FROM Contact WHERE Id = :contactId ];
        System.assert(myContact != null);
        System.assertEquals(myContact.LastName, 'Test');
    }
    
    @isTest static void modifyContact() {
        // Create a contact
        Contact newContact = new Contact(LastName = 'Test', Phone = '0000000000', Email__c = 'test@salesforce.com');
        insert newContact;
        Id contactId = newContact.Id;
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://brave-koala-hkbmbl-dev-ed.my.salesforce.com/services/apexrest/Contacts/'
            + contactId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Phone": "1111111111"}');
        RestContext.request = request;
        // Call the method to test
        Id myContactId = ContactManager.updateContactFields();
        // Check updated field 
        Contact checkMyContact = [ SELECT Id, Phone FROM Contact WHERE Id = :myContactId ];
        // Verify results
        System.assert(myContactId != null);
        System.assertEquals('1111111111', checkMyContact.Phone);
    }
    
    
    @isTest static void deleteContact() {
        // Create a contact
        Contact newContact = new Contact(LastName = 'Test', Email__c = 'test@salesforce.com');
        insert newContact;
        Id contactId = newContact.Id;
        // Set up a test request to delete the contact
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://brave-koala-hkbmbl-dev-ed.my.salesforce.com/services/apexrest/Contacts/'
            + contactId;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        // Call the method to test
        Contact myContact = ContactManager.deactivateContact();
        // Check Active__c field 
        Contact checkMyContact = [ SELECT Id, Active__c FROM Contact WHERE Id = :myContact.Id ];
        // Verify results
        System.assert(myContact != null);
        System.assertEquals(false , checkMyContact.Active__c );
    }
}