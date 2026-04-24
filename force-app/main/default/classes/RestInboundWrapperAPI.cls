@RestResource(urlmapping='/inboundwrapper')
global with sharing class RestInboundWrapperAPI {
    global class ResponseWrapper {
        public string message;
        public string requestBody;
        public string status;
    }
    @HttpPost
    global static ResponseWrapper InboundWrapperAPI() {
        RestRequest req = RestContext.request;

        String body = req.requestBody.toString();

        ResponseWrapper response = new ResponseWrapper();
        response.message = 'call from external to rest class -- Abhisek';
        response.requestBody = body;
        response.status = 'success';
        return response;

    }
}