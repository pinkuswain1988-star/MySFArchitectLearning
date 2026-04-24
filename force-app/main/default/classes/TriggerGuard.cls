public class TriggerGuard {
    private static List<String> ran = new List<String>();
    public static Boolean runOnce(String key) {
        if(ran.contains(key)) return false;
        ran.add(key);
        return true;
    }
}