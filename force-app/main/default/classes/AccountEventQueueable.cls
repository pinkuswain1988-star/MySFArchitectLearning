public with sharing class AccountEventQueueable implements Queueable, Database.AllowsCallouts {
    private String accountId;
    public AccountEventQueueable(String accId) {
        this.accountId = accId;
    }

    public void execute(QueueableContext context){
        List<Account> accList = [SELECT Id, Name FROM Account WHERE Id = :accountId];

        for (Account acc : accList){
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint('https://postman-echo.com/post');
            req.setHeader('Content-Type', 'application/json');

            Map<String,Object> body = new Map<String,Object>();
            body.put('accountId',acc.Id);
            req.setBody(JSON.serialize(body));

            Http http = new Http();
            HttpResponse resp = http.send(req);

            System.debug(resp);

            /*if(resp.getStatusCode() == 200 && resp.getBody() != null && resp != null){
                Map<String,Object> responseObj = new Map<String,Object>();
                responseObj = (Map<String,Object>) JSON.deserializeUntyped(resp.getBody());
                String message = (String)responseObj.get('message');
                System.debug(message);
            }*/

        }

    }
}