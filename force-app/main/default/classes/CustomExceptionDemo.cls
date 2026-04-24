public with sharing class CustomExceptionDemo {
    public class BusinessException  extends Exception {}
    public static void run(Boolean forceFail) {
            try{
                if(forceFail) throw new BusinessException('Business rule failed: something not allowed');
                System.debug('✅ Success path');
            }
            catch(BusinessException e){
                LogUtil.log('BUSINESS_ERR', e);
            }
        }
}