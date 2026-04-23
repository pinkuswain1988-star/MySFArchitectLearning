@RestResource(urlMapping='/contactapi/*')
global with sharing class ContactInboundRestService {

    global class ContactRequest{
        public String FirstName;
        public String LastName;
    }

    global class ContactResponse {
        public String Status;
        public String Message;
        public Id contactId;
        public String FullName;
    }

    @HttpPost
    global static ContactResponse CreateContact() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        ContactResponse responseObj = new ContactResponse();

        try{
            String reqBody = req.requestBody.toString();
            ContactRequest input = (ContactRequest) JSON.deserialize(reqBody, ContactRequest.class);

            if(input == null || String.isBlank(input.LastName)){
                res.statusCode = 400;
                responseObj.Status = 'Error';
                responseObj.Message = 'Last Name is required';
                return responseObj;
            }

            Contact c = new Contact();
            c.FirstName = input.FirstName;
            c.LastName = input.LastName;
            insert c;

            res.statusCode = 200;
            responseObj.Status = 'Success';
            responseObj.Message = 'Contact is created';
            responseObj.contactId = c.Id;
            responseObj.FullName = String.isBlank(c.FirstName) ? c.LastName : c.FirstName + ' ' + c.LastName;
            return responseObj;

        }
        catch(Exception e){
            res.statusCode = 500;
            responseObj.Status = 'Failed';
            responseObj.Message = e.getMessage();
            return responseObj;
        }

    }
}