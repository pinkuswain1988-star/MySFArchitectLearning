@RestResource(urlMapping='/onzcaseapi/*')
global with sharing class ONZInboundCaseAPI {

    global class caseRequest{
        public String subject;
        public String description;
        public String origin;
    }

    global class caseResponse{
        public String status;
        public String message;
        public Id caseId;
    }
    @HttpPost
    global static caseResponse createCase() {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        caseResponse responseObj = new caseResponse();

        if(req.requestBody == null){
            res.statusCode = 400;
            responseObj.status = 'ERROR';
            responseObj.message = 'Request body is required';
            return responseObj;
    }

        String body = req.requestBody.toString();
        caseRequest input = (caseRequest) JSON.deserialize(body, caseRequest.class);

        try{
        if(input == null || String.isBlank(input.origin)){
            res.statusCode = 400;
            responseObj.status = 'ERROR';
            responseObj.message = 'Origin is required field';
            return responseObj;
        }

        Case c = new Case();
        c.Subject = input.subject;
        c.Description = input.description;
        c.Origin = input.origin;
        insert c;
        
        res.statusCode = 200;
        responseObj.status = 'Success';
        responseObj.message = 'Case Created';
        responseObj.caseId = c.Id;
        return responseObj;

        }
        catch(Exception e){
            res.statusCode = 500;
            responseObj.status = 'Error';
            responseObj.message = e.getMessage();
            return responseObj;
        }
    }
}