public with sharing class TxnPatternsDemo {
    public static void run() {
        SavePoint sp = Database.setSavepoint();
        List<String> errors = new List<String>();
        try{
            //create a good account
            insert new Account(Name='Good Account');

            //partial account same
            List<Account> accs = new List<Account>{
                new Account(Name= 'Partial Account1'),
                new Account (Name=null),
                new Account(Name='Partial Account2')
            };
            Database.SaveResult[] results = Database.insert( accs, false);
            //partial failure
            for(integer i=0; i< results.size(); i++){
                if(!results[i].isSuccess()){
                    for(Database.Error err : results[i].getErrors()){
                        errors.add('PartialDML index=' + i + ' ' + err.getStatusCode() + ' ' + err.getMessage());
                    }
                }
                System.debug(results[i].success);
            }
            if(!errors.isEmpty()){
                Database.rollback(sp);
                System.enqueueJob(new ErrorLoggerQueueable(errors));
            }
        }
        catch(Exception e){
            Database.rollback(sp);
            errors.add('Unhandled: ' + e.getMessage());
            System.enqueueJob(new ErrorLoggerQueueable(errors));
        }

    }
}