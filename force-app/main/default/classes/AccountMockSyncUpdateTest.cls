@isTest
private class AccountMockSyncUpdateTest {
    @isTest
    static void AccountMockSyncUpdateTest() {

    //Create Data
    Account acc = new Account(
        Name = 'Test Abjbskdsdhlksdn',
        Send_To_Mock__c = false
    );
    insert acc;
    Test.setMock(HttpCalloutMock.class, new AccountMockHttpResponseGenerator());
    Test.startTest();
    acc.Send_To_Mock__c = true;
    update acc;
    Test.stopTest();
    
    Account updAcc = [SELECT Id, Name, Send_To_Mock__c, Mock_Status__c, Mock_Response__c FROM Account WHERE Id = :acc.Id];
    
    System.assertEquals('200', updAcc.Mock_Status__c);
    }
}