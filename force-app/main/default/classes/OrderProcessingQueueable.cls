public class OrderProcessingQueueable implements Queueable{
    private List<Id> oppsId;
    public OrderProcessingQueueable(List<Id> oppsId) {
        this.oppsId = oppsId;
    }
    public void execute(QueueableContext context){
        List<Opportunity> Opps = [SELECT Id, Name, Amount, AccountId
            FROM Opportunity
            WHERE Id IN :oppsId];

            List<Invoice__c> invoices = new List<Invoice__c>();
            for(Opportunity opp : Opps){
                invoices.add(new invoice__c(
                    Opportunity__c = opp.Id,
                    Amount__c = opp.Amount));
            }

            Database.SaveResult[] results = Database.insert(invoices, false);
            for(Integer i=0; i<results.size(); i++){
                if(!results[i].isSuccess()){
                    System.debug('Error in Invoice: ' + results[i].getErrors());
                }
                System.debug('Invoice Created: ' + results[i].getId());
            }
    }
    
}