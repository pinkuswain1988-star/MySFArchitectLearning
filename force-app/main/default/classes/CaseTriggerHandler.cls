public with sharing class CaseTriggerHandler {
    
    public static void beforeInsert(List<Case> newCases){
        for(Case c : newCases){
            if(c.Priority == 'High'){
                c.Subject = 'VIP Case Created';
                c.Description = 'VIP case';
            }
            else if (c.Priority == 'Medium'){
                c.Subject = 'Medium Priority Case Created';
                c.Description = 'Medium case';
            }
            else if (c.Priority == 'Low'){
                c.Subject = 'Low Priority Case Created';
                c.Description = 'Low case';                
            }
        }
    }
    
    public static void beforeUpdate(Map<Id,Case> oldCases, List<Case> newCases){
        
        CaseService.applyEscalationUpdates(oldCases, newCases);
        
    }
    
    public static void afterUpdate(Map<Id,Case> oldCases, List<Case> newCases){
        CaseService.createFollowUpTasks(oldCases, newCases);
    }

}