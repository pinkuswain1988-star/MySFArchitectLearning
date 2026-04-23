public with sharing class CaseSelector {
    public static List<Case> getEscalatedCases(Set<Id> casesIds) {

        return[SELECT Id, CaseNumber, Status, Priority, Account.Name FROM Case WHERE Status = 'Escalated' AND Id IN : casesIds];

    }
}