@isTest
global class AccountMockHttpResponseGenerator implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"status":"success","message":"Account synced"}');
        res.setHeader('Content-Type', 'application/json');
        return res;
    }
}