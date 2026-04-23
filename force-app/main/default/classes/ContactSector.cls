public with sharing class ContactSector {
    public static List<Task> getConatactTask(Set<Id> conatctsId) {
        return[
            SELECT Id, Subject, Status, WhoId FROM Task WHERE Subject = 'Add Campaigning Department' AND WhoId IN :conatctsId
        ];
    }
}