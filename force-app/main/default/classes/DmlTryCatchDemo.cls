public with sharing class DmlTryCatchDemo {
    public static void run() {
        try{
            Account acc = new Account();
            insert acc;

        }
        Catch(DmlException e){
            LogUtil.log('DML_TRY_CATCH', e);
            System.debug('Error Message: ' + e.getMessage());
            System.debug('Error Type: ' + e.getTypeName());
            System.debug('STACK: ' + e.getStackTraceString());
        }

    }
}