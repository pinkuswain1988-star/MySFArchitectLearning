public with sharing class MySharingDemo_WithSharing {
    //Custom Exception
    public class AuthorizationException extends Exception {}

    public static List<Account> getVisibleAccounts() {
        //CRUD Check
        if(!Schema.sObjectType.Account.isAccessible()){
            throw new AuthorizationException('Insufficient Privileges');
        }
        //SOQL
        List<Account> accList = [
            SELECT Id, Name, OwnerId, Industry, AnnualRevenue
            FROM Account
        ];
        //FLS Check
        accList = (List<Account>) Security.stripInaccessible(AccessType.READABLE, accList).getRecords();
        for(Account acc : accList){
            System.debug('Account Name: ' + acc.Name);
        }
        return accList;
    }

    /**
     * Insert Account with CRUD + FLS enforcement
     */
    public static void CreateAccount (String accName, String accIndustry){
        if(!Schema.sObjectType.Account.isCreateable()){
            throw new AuthorizationException('No create access on Account');
        }

        Account acc = new Account();
        acc.Name = accName;
        acc.Industry = accIndustry;
        
        List<Account> accToInsert = new List<Account>{acc};
        
        //FLS Check
        accToInsert = (List<Account>) Security.stripInaccessible(AccessType.CREATABLE, accToInsert).getRecords();

        insert accToInsert;
    }
}