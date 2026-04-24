@RestResource(urlmapping='/testInbound')
global with sharing class TestInboundAPI {

    global class ResponseWrapper {
        public string message;
        public string requestBody;
        public string status;
    }

    @HttpPost
    global static ResponseWrapper handleRequest () {

        RestRequest req = RestContext.request;

        String body = req.requestBody.toString();

        ResponseWrapper response = new ResponseWrapper();
        
        response.message = 'call from external to rest class';
        response.requestBody = body;
        response.status = 'success';

        return response;

    }
}