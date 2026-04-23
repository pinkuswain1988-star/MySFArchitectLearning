public class IntegrationCallout {
    @Future(callout=true)
    public static void sendProvisionRequest(String orderId, String Product, String action) {
        HttpRequest req = new HttpRequest();
        HttpResponse resp = new HttpResponse();
        Http http = new Http();
        req.setEndpoint('https://c1f83765-6285-4e10-8d98-f4e053c1c0d7.mock.pstmn.io/billing-sync');
        req.SetMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        Map<String, Object> body = new Map<String,Object>();
        body.put('orderId', orderId);
        body.put('product', Product);
        body.put('action', action);
        req.setBody(JSON.serialize(body));

        resp = http.send(req);

        System.debug(resp);
        System.debug('Response: ' + resp.getBody());

    }
}