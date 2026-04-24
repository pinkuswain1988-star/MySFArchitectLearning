public with sharing class AccountOrderLwcController {

    @AuraEnabled(Cacheable=true)
    public static List<Account> getAccounts() {
        return [
            SELECT Id, Name, Industry FROM Account LIMIT 10
        ];

    }

    @AuraEnabled
    public static String createOrder(Id accountId){
        String correlationId = String.valueOf(Datetime.now().getTime());

        Order_Tracking__c tracking = new Order_Tracking__c(
            Account__c = accountId,
            CorrelationId__c = correlationId,
            Status__c = 'Pending'
        );
        insert tracking;

        //Process Asynchronously
        System.enqueueJob(new OrderQueueable(accountId, correlationId));

        return correlationId;
    }

    @AuraEnabled
    public static string getOrderStatus(String correlationId){
        Order_Tracking__c record = [
            SELECT Status__c FROM Order_Tracking__c WHERE CorrelationId__c = :correlationId LIMIT 1
        ];

        return record.Status__c;
    }
}