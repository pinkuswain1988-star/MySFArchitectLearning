public with sharing class ContactService {
    private static Boolean isFirst = false;
    public static void beforeInsert(List<Contact> newContacts) {
        for(Contact c : newContacts){
            if(c.LeadSource == 'Advertisement'){
                if(String.isBlank(c.Department)){
                    c.Department = 'Campaigning Department';
                }
                else{
                    c.Department = c.Department +'\n Campaigning Department';
                }
            } 
        }

    }

    public static void beforeUpdate(List<Contact> newContacts,Map<Id,Contact> oldContacts){
        for(Contact c: newContacts){
            Contact oldC = oldContacts.get(c.Id);
            if(oldC.LeadSource != 'Advertisement' && c.LeadSource == 'Advertisement'){
                if(String.isBlank(c.Department)){
                    c.Department = 'Campaigning Department';
                }
                else{
                    c.Department = c.Department +'\n Campaigning Department';
                }
            }
        }
    }

    public static void afterUpdate(List<Contact> newContacts, Map<Id, Contact> oldContacts) { 
        if(isFirst == true){
            return;
        }
        isFirst = true;
        try{
        List<Task> tasks = new List<Task>();
        Set<Id> conIds = new Set<Id>();
        for(Contact cc : newContacts){
            conIds.add(cc.Id);
        }
        Set<Id> contactsWithTask = new Set<Id>();
        if(!conIds.isEmpty()){
            List<Task> qResult = ContactSector.getConatactTask(conIds);

            for(Task ta : qResult){
                if(ta.WhoId != null){
                    contactsWithTask.add(ta.WhoId);
                }
            }
        }

        
        for(Contact c: newContacts){
            Contact oldC = oldContacts.get(c.Id);
            if(oldC.LeadSource != 'Advertisement' && c.LeadSource == 'Advertisement'){
                if(!contactsWithTask.contains(c.Id)) {
                Task t = new Task();
                t.WhoId = c.Id;
                t.Subject = 'Add Campaigning Department';
                t.Status = 'Not Started';
                t.Description = 'Campaign';
                tasks.add(t);
                }
            }
        }
        if(tasks != null && !tasks.isEmpty()){
            insert tasks;
        }
        }
        finally{
            isFirst = false;
        }
    }
}