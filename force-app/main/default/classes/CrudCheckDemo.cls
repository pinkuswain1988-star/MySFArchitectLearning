public with sharing class CrudCheckDemo {
    public static SimpleResponse run() {
        SimpleResponse r = new SimpleResponse();
        if(Schema.SObjectType.Account.isCreateable()){
            Account acc = new Account(Name='CURD Account2');
            insert acc;
            r.OK = true;
            r.Message = 'Account created successfully';
            r.errors.add('Account created successfully');
        }
        else{
            System.debug('Insufficient Privileges');
        }
        return r;
    }
}