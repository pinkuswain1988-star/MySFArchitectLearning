@isTest
private class AccountMockSyncQueueableBulkTest {
    @testSetup
    static void createBaseData() {
        List<Account> accList = new List<Account>();
        for(Integer i=0;i<=200;i++){
            Account acc = new Account(
                Name = 'Bulk Account' + i,
                Send_To_Mock__c = false
            );
            accList.add(acc);
        }
        if(!accList.isEmpty()){
            insert accList;
        }
    }

    @isTest
    static void testSingleAccountSuccess(){
        Test.setMock(HttpCalloutMock.class, new AccountMockHttpResponseGenerator());

        Account acc = [SELECT Id, Name, Send_To_Mock__c FROM Account LIMIT 1];

        Test.startTest();
        acc.Send_To_Mock__c = true;
        update acc;
        Test.stopTest();

        Account updAcc = [SELECT Id, Name, Send_To_Mock__c, Mock_Status__c FROM Account WHERE Id = :acc.Id];

        System.assertEquals(true, updAcc.Send_To_Mock__c);
        System.assertEquals('200', updAcc.Mock_Status__c);

    }

    @isTest
    static void testBulkAccountsSuccess(){
        Test.setMock(HttpCalloutMock.class, new AccountMockHttpResponseGenerator());

        List<Account> accList = [SELECT Id, Name, Send_To_Mock__c FROM Account LIMIT 5];
        Set<Id> accIds = new Set<Id>();
        for(Account acc : accList){
            acc.Send_To_Mock__c = true;
            accIds.add(acc.Id);
        }

        Test.startTest();
        update accList;
        Test.stopTest();

        List<Account> updaccList = [SELECT Id, Name, Send_To_Mock__c, Mock_Status__c FROM Account WHERE Id IN :accIds];

        System.assertEquals(5, updaccList.size());

        for(Account updAcc : updaccList){
            System.assertEquals(true, updAcc.Send_To_Mock__c);
            System.assertEquals('200', updAcc.Mock_Status__c);
        }

    }

    @isTest
    static void testMixedEligibleAndIneligibleAccounts(){
        Test.setMock(HttpCalloutMock.class, new AccountMockHttpResponseGenerator());
        List<Account> accList = [SELECT Id, Name, Send_To_Mock__c FROM Account LIMIT 5];
        accList[0].Send_To_Mock__c = true;
        accList[1].Send_To_Mock__c = true;
        accList[2].Send_To_Mock__c = false;
        accList[3].Send_To_Mock__c = false;

        Set<Id> accIds = new Set<Id>();
        for(Account a : accList){
            accIds.add(a.Id);
        }

        Test.startTest();
        update accList;
        Test.stopTest();

        List<Account> updatedList = [
        SELECT Id, Send_To_Mock__c, Mock_Status__c, Mock_Response__c
        FROM Account
        WHERE Id IN :accIds
        ORDER BY Name];
        
        Integer processedCount = 0;
        Integer skippedCount = 0;

        for(Account updAcc : updatedList){
            if(updAcc.Send_To_Mock__c == true){
                System.assertEquals('200', updAcc.Mock_Status__c);
                processedCount++;
            }
            else{
                System.assertEquals(null, updAcc.Mock_Status__c);
                skippedCount++;
            }
        }

        System.assertEquals(2, processedCount);
        System.assertEquals(3, skippedCount);

    }

    @isTest
    static void testNoEligibleAccounts() {
        Test.setMock(HttpCalloutMock.class, new AccountMockHttpResponseGenerator());

        List<Account> accList = [
            SELECT Id, Name, Send_To_Mock__c
            FROM Account
            LIMIT 3
        ];

        Set<Id> accIds = new Set<Id>();
        for(Account a : accList){
            accIds.add(a.Id);
        }

        Test.startTest();
        update accList;
        Test.stopTest();

        List<Account> updatedList = [
            SELECT Id, Mock_Status__c, Mock_Response__c
            FROM Account
            WHERE Id IN :accIds
        ];

        for(Account acc : updatedList){
            System.assertEquals(null, acc.Mock_Status__c);
            System.assertEquals(null, acc.Mock_Response__c);
        }
    }

    @isTest
    static void testCalloutFailureResponse(){
        Test.setMock(HttpCalloutMock.class, new AccountMockHttpFailureGenerator());

         Account acc = [SELECT Id, Name, Send_To_Mock__c FROM Account LIMIT 1];
         acc.Send_To_Mock__c = true;

         Test.startTest();
         update acc;
         Test.stopTest();

         Account updacc = [SELECT Id, Mock_Status__c
                          FROM Account
                          WHERE Id = :acc.Id];

         System.assertEquals('500', updacc.Mock_Status__c);
    }
}