public class AccountFutureService {
    @future (callout=true)
    public static void sendAccountToBilling(Set<Id> accIds) {
        List<Account> accList = [SELECT id,Name,Industry FROM Account WHERE Id = :accIds];

        for(Account acc : accList){
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://api.billing.com/account');
            req.setMethod('POST');
            req.setBody(JSON.serialize(acc));
            System.debug(JSON.serialize(acc));
            HttpResponse resp = new HttpResponse();
            try{
                resp = http.send(req);
                System.debug(resp.getBody());
                System.debug(resp.getStatusCode());
            }catch(System.CalloutException e){
                System.debug('Callout Error: ' + e);
            }
        }

    }
}