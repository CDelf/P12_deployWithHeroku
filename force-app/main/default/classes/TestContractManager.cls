@isTest
private class TestContractManager {
    
     @isTest static void getContract() {
        // Create an account and contract
        Account acc = new Account(Name = 'Test');
        insert acc;
        Contract newContract = new Contract(AccountId = acc.Id, Status = 'Draft', StartDate = Date.today(), ContractTerm = 3);
        insert newContract;
        Id contractId = newContract.Id;
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://brave-koala-hkbmbl-dev-ed.my.salesforce.com/services/apexrest/Contracts/'
            + contractId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Contract myContract = ContractManager.getContract();
        // Verify results
        System.assert(myContract != null);
        System.assertEquals('Draft', myContract.Status);
        System.debug('Today : ' + Date.today());
    }
    
     @isTest static void createContract() {
         // Create account 
         Account acc = new Account(Name = 'Test');
         insert acc;
        // Use class method to create a new Contract
        Id contractId = contractManager.createContract(acc.Id, null, 'draft', Date.today(), 3);
        // Verify results
        System.assert(contractId != null);
        Contract myContract = [ SELECT Id, Status FROM Contract WHERE Id = :contractId ];
        System.assert(myContract != null);
        System.assertEquals(myContract.Status, 'Draft');
    }
    
   @isTest static void modifyContract() {
       // Create an account
       Account acc = new Account(Name = 'Test');
       insert acc;
        // Create a contract
        Contract newContract = new Contract(AccountId = acc.Id, Status = 'Draft', StartDate = Date.today(), ContractTerm = 3);
        insert newContract;
        Id contractId = newContract.Id;
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://brave-koala-hkbmbl-dev-ed.my.salesforce.com/services/apexrest/Contracts/'
            + contractId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"ContractTerm": 6}');
        RestContext.request = request;
        // Call the method to test
        Id myContractId = ContractManager.updateContractFields();
        // Check updated field 
        Contract checkMyContract = [ SELECT Id, ContractTerm FROM Contract WHERE Id = :myContractId ];
        // Verify results
        System.assert(myContractId != null);
        System.assertEquals(6, checkMyContract.ContractTerm);
    }
}