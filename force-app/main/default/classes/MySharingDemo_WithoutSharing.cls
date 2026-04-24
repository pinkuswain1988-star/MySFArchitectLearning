public with sharing class MySharingDemo_WithoutSharing {
    //Custom Exception
    public class AuthorizationException extends Exception {}
    public static List<Account> getAccounts() {
        if(!Schema.sObjectType.Account.isAccessible()){
            throw new AuthorizationException('Account is not accessible');
        }
        List<Account> accList = [SELECT Id, Name, OwnerId
            FROM Account];
        
        accList = (List<Account>) Security.stripInaccessible(AccessType.READABLE, accList).getRecords();

        for(Account acc : accList){
            System.debug(acc.Name);
        }
        return accList;

    }
}