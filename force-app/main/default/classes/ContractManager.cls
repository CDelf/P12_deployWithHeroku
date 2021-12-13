@RestResource(urlMapping='/Contracts/*')
global with sharing class ContractManager {
    
    @HttpGet
    global static Contract getContract() {
        // Get contract id in request
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String contractId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        // Search for required fields and associated contact
        Contract result = [ SELECT Id, AccountId, CustomerSignedId, Status, StartDate, ContractTerm FROM Contract WHERE Id = :contractId ];
        return result;
    }
    
     @HttpPost
    global static ID createContract(Id accountId, Id customerSignedId, String status, Date startDate, Integer contractTerm) {
        // Create a new contact and fill fields with entering informations
        Contract thisContract = new Contract(
            accountId = accountId,
            customerSignedId = customerSignedId,
            status = status,
            startDate = startDate,
            contractTerm = contractTerm );
        insert thisContract;
        // Id of salesforce org si returned
        return thisContract.Id;
    }   
    
     @HttpPatch
    global static ID updateContractFields() {
        // Get contract id
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contract thisContract = [SELECT Id FROM Contract WHERE Id = :contractId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Case sObject
            thisContract.put(fieldName, params.get(fieldName));
        }
        update thisContract;
        return thisContract.Id;
    }    
    
}