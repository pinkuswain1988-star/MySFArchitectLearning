public class AccountValidationHandlerGuard {
    public static void beforeInsertOrUpdate(List<Account> accList) {
        ErrorCollector err = new ErrorCollector();

        for(Account acc : accList){
            if(acc.Name != null && acc.Name.contains('Block')){
                acc.addError('Account Name cannot be Block');
                err.add('Blocked Account Name=' + acc.Name);
            }
        }
        if(err.hasErrors()){
            System.enqueueJob(new ErrorLoggerQueueableTriggerGuard(err.messages));
        }
    }
}