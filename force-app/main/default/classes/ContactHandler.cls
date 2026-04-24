public with sharing class ContactHandler {
    public static void run() {
        try{
            if(Trigger.isBefore && Trigger.isInsert){
            ContactService.beforeInsert(Trigger.new);
            }
            else if(Trigger.isAfter && Trigger.isInsert){}
            else if(Trigger.isBefore && Trigger.isUpdate){
                ContactService.beforeUpdate((List<Contact>)Trigger.new, (Map<Id,Contact>)Trigger.oldMap);
            }
            else if(Trigger.isAfter && Trigger.isUpdate){
                ContactService.afterUpdate((List<Contact>)Trigger.new, (Map<Id,Contact>)Trigger.oldMap);
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }
}