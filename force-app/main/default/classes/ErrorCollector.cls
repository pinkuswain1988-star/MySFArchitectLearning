public class ErrorCollector {
        public List<String> messages = new List<String>();

        public void add(String msg) { messages.add(msg); }

        public Boolean hasErrors() { return !messages.isEmpty(); }
}