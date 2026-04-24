trigger OrderProvisionTrigger on Order_Provision_Event__e (after insert) {

    for(Order_Provision_Event__e event : Trigger.new){
        System.debug('Event is triggered');
        //IntegrationCallout.sendProvisionRequest(event.Order_d__c,event.Product__c,event.Action__c);
        System.enqueueJob(new ProvisionRequestQueueable(event.Order_d__c,event.Product__c,event.Action__c));
    }

}