@RestResource(urlMapping='/accntapi/*')
global with sharing class AccountInboundRestService {
    global class AccountRequest {
        public String name;
        public String phone;
        public String website;
    }

    global class AccountResponse {
        public String status;
        public String message;
        public Id accountId;
    }

    @HttpPost
    global static Accountresponse createAccount(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        AccountResponse responseObj = new AccountResponse();

        try{
            String requestBody = req.requestBody.toString();
            AccountRequest input = (AccountRequest) JSON.deserialize(requestBody, AccountRequest.class);

            if(input == null && String.isBlank(input.name)){
                res.statusCode = 400;
                responseObj.status = 'ERROR';
                responseObj.message = 'Account name is required';
                return responseObj;

            }
            else{
                Account acc = new Account();
                acc.Name = input.name;
                acc.Phone = input.phone;
                acc.Website = input.website;
                insert acc;

                res.statusCode = 200;
                responseObj.status = 'Success';
                responseObj.message = 'Account created';
                responseObj.accountId = acc.Id;
                return responseObj;
            }

        }
        catch(Exception e){
            res.statusCode = 500;
            responseObj.status = 'ERROR';
            responseObj.message = e.getMessage();
            return responseObj;
        }

    }
}