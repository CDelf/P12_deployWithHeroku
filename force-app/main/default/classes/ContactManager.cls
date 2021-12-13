@RestResource(urlMapping='/Contacts/*')
global with sharing class ContactManager {
    
    @HttpGet
    global static Contact getContact() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Contact result = [SELECT Id, LastName, FirstName, Email__c FROM Contact WHERE Id = :contactId];
        return result;
    }
    
    @HttpPost
    global static ID createContact(String lastName, String firstName,String email) {
        // Verify if email exists in Salesforce
        List<Contact> contacts = [ SELECT Id FROM Contact WHERE Email__c = :email ];
        // If not, create a new contact and returns id
        if(contacts.size() == 0 ) {        
            Contact newContact = new Contact (
                lastName = lastName,
                firstName = firstName,
                email__c = email );
            insert newContact;
            return newContact.Id;
        } else {
            // If exists, returns existing id in Salesforce
            return contacts.get(0).Id;
        }
    }
    
    @HttpPatch
    global static ID updateContactFields() {
        // Get the contact Id
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        // Retrieve the contact in org
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Contact sObject
            thisContact.put(fieldName, params.get(fieldName));
        }
        update thisContact;
        return thisContact.Id;
    }    
    
    @HttpDelete
    global static contact deactivateContact() {
        // Get the id of the deleted contact
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        // Search for this contact in org
        Contact thisContact = [ SELECT Id, Active__c FROM Contact WHERE Id = :contactId ];
        // Uncheck Active__c field to deactivate contact
        If(thisContact != null) {
            thisContact.active__c = false;
            update thisContact;
        }
        return thisContact;
    }
}