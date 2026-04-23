@isTest
global class AccountMockHttpFailureGenerator implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(500);
        res.setBody('{"status":"error","message":"Internal server error"}');
        res.setHeader('Content-Type', 'application/json');
        return res;
    }
}