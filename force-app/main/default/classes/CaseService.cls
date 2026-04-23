public with sharing class CaseService {

    private static Boolean taskCreationInProgress = false;

    public static void applyEscalationUpdates(Map<Id,Case> oldCases, List<Case> newCases) {
        for(Case c : newCases){
            Case OldC = oldCases.get(c.Id);
            if(OldC.Status != 'Escalated' && c.Status == 'Escalated'){
                c.Priority = 'High';
                if(String.isBlank(c.Description)){
                    c.Description = 'Case escalated. High priority assigned.';
                }
                else{
                    c.Description = c.Description + '\nCase escalated. High priority assigned.';
                }
                
            }
        }
    }

    public static void createFollowUpTasks(Map<Id,Case> oldCases, List<Case> newCases){
        if(taskCreationInProgress == true){
            return;
        }
        taskCreationInProgress = true;
        try{
            List<Task> tasks = new List<Task>();
            Set<Id> caseIds = new Set<Id>();
            for(Case c : newCases){
            Case oldC = oldCases.get(c.Id);
            if(oldC.Status != 'Escalated' && c.Status == 'Escalated'){
                caseIds.add(c.Id);
                //Create Task
                Task t = new Task();
                t.WhatId = c.Id;
                t.Subject = 'Follow up on escalated case';
                t.Status = 'Not Started';
                t.Priority = 'High';
                tasks.add(t);
            }
            }
            if(tasks != null && !tasks.isEmpty()){
                insert tasks;
            }
            List<Case> escalatedCases = CaseSelector.getEscalatedCases(caseIds);
            System.debug('Escalated cases fetched: ' + escalatedCases);
        }
        finally{
            taskCreationInProgress = false;
        }
    }

}