public with sharing class PartialDmlDemo {
    public static void run() {

        try{
           List<Account> accList = new List<Account>{
             new Account (Name='Account1'),
             new Account (Name=null),
             new Account (Name = 'Account2')
           };

           Database.SaveResult[] results = Database.insert(accList, false);
           
           for(Integer i=0; i<results.size();i++){
             if(results[i].isSuccess()){
                System.debug('✅ OK index ' + i + ' id=' + results[i].getId());
             }
            else {
            for (Database.Error err : results[i].getErrors()) {
                System.debug('❌ FAIL index ' + i + ' => ' + err.getStatusCode() + ' ' + err.getMessage());
            }
            }
           }

        }
        Catch(Exception e){
            System.debug('Error Message: ' + e.getMessage());
        }

    }
}