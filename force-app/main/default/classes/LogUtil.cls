public class LogUtil {
    public static void log(String tag, Exception e) {
        System.debug('❌ [' + tag + '] ' + e.getTypeName() + ': ' + e.getMessage());
        System.debug('STACK: ' + e.getStackTraceString());
    }
}