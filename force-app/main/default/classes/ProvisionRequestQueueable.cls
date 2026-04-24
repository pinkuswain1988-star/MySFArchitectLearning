public class ProvisionRequestQueueable implements Queueable, Database.AllowsCallouts  {

    private String orderId;
    private String product;
    private String action;

    public ProvisionRequestQueueable(String orderId, String product, String action){
        this.orderId = orderId;
        this.product = product;
        this.action = action;
    }

    public void execute(QueueableContext context) {

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        req.setEndpoint('https://c1f83765-6285-4e10-8d98-f4e053c1c0d7.mock.pstmn.io/billing-sync');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        Map<String, Object> body = new Map<String,Object>();
        body.put('product', product);
        body.put('orderId', orderId);
        body.put('action', action);
        req.setBody(JSON.serialize(body));

        res = http.send(req);

        System.debug('Response status: ' + res.getStatusCode());
        System.debug('Response body: ' + res.getBody());
    }
}