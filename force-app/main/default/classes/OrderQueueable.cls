public with sharing class OrderQueueable implements Queueable, Database.AllowsCallouts {

    private string accountId;
    private string correlationId;

    public OrderQueueable(String accountId, String correlationId) {

        this.accountId = accountId;
        this.correlationId = correlationId;
    }

    public void execute(QueueableContext context){
        
    Order_Tracking__c record = [
        SELECT Id, Status__c
        FROM Order_Tracking__c
        WHERE CorrelationId__c = :correlationId
        LIMIT 1
    ];

    record.Status__c = 'In Progress';
    update record;

        // Simulate API delay
        Long start = DateTime.now().getTime();
        while (DateTime.now().getTime() - start < 3000) {}

        // Simulate success
        record.Status__c = 'Completed';
        update record;
    }
}