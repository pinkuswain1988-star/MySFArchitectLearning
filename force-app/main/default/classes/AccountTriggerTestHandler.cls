public with sharing class AccountTriggerTestHandler {
public static void handle() {
        if (Trigger.isBefore && Trigger.isInsert) {
            beforeInsert((List<Account>) Trigger.new);
        } 
        else if (Trigger.isBefore && Trigger.isUpdate) {
            beforeUpdate((List<Account>) Trigger.new, (Map<Id, Account>) Trigger.oldMap);
        } 
        else if (Trigger.isAfter && Trigger.isInsert) {
            afterInsert((List<Account>) Trigger.new);
        } 
        else if (Trigger.isAfter && Trigger.isUpdate) {
            afterUpdate((List<Account>) Trigger.new, (Map<Id, Account>) Trigger.oldMap);
        } 
        else if (Trigger.isBefore && Trigger.isDelete) {
            beforeDelete((List<Account>) Trigger.old);
        } 
        else if (Trigger.isAfter && Trigger.isDelete) {
            afterDelete((List<Account>) Trigger.old);
        } 
        else if (Trigger.isAfter && Trigger.isUndelete) {
            afterUndelete((List<Account>) Trigger.new);
        }
    }

    public static void beforeInsert(List<Account> newList) {
        for (Account acc : newList) {
            acc.Name = acc.Name + ' beforeInsertTest';
        }
    }

    public static void beforeUpdate(List<Account> newList, Map<Id, Account> oldMap) {
        for (Account acc : newList) {
            Account oldAcc = oldMap.get(acc.Id);
            if (acc.Name != oldAcc.Name) {
                acc.Name = acc.Name + ' beforeUpdateTest';
            }
        }
    }

    public static void afterInsert(List<Account> newList) {
        for (Account acc : newList) {
            System.debug('Inserted Account Id: ' + acc.Id);
        }
    }

    public static void afterUpdate(List<Account> newList, Map<Id, Account> oldMap) {
        for (Account acc : newList) {
            Account oldAcc = oldMap.get(acc.Id);
            System.debug('Old Name: ' + oldAcc.Name + ', New Name: ' + acc.Name);
        }
    }

    public static void beforeDelete(List<Account> oldList) {
        for (Account acc : oldList) {
            System.debug('Deleting Account: ' + acc.Name);
        }
    }

    public static void afterDelete(List<Account> oldList) {
        for (Account acc : oldList) {
            System.debug('Deleted Account: ' + acc.Name);
        }
    }

    public static void afterUndelete(List<Account> newList) {
        for (Account acc : newList) {
            System.debug('Undeleted Account: ' + acc.Name);
        }
    }
}