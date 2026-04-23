public with sharing class ContactDomainService {
    public class Request {
        @AuraEnabled public String domain;
        @AuraEnabled public Integer limitSize;
        @AuraEnabled public Boolean useStripInaccessibleFallback;
    }

    public class Response {
        @AuraEnabled public Boolean success;
        @AuraEnabled public String message;
        @AuraEnabled public List<Contact> contacts;
        public Response(Boolean success, String message, List<Contact> contacts) {
            this.success = success;
            this.message = message;
            this.contacts = contacts == null ? new List<Contact>() : contacts;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Response findByEmailDomain(Request req) {
        String domain = (req == null || String.isBlank(req.domain))
            ? null
            : req.domain.trim().toLowerCase();

        Integer lim = (req == null || req.limitSize == null || req.limitSize <= 0 || req.limitSize > 2000)
            ? 200
            : req.limitSize;

        Boolean fallback = (req != null && req.useStripInaccessibleFallback == true);

        if (String.isBlank(domain)) {
            return new Response(false, 'Domain is required (e.g., gmail.com).', new List<Contact>());
        }

        try {
            // Enforces CRUD + FLS at query time (recommended when possible)1
            List<Contact> rows = [
                SELECT Id, Name, Email, EmailDomain__c, LastModifiedDate
                FROM Contact
                WHERE EmailDomain__c = :domain
                WITH SECURITY_ENFORCED
                ORDER BY LastModifiedDate DESC
                LIMIT :lim
            ];
            return new Response(true, 'OK', rows);

        } catch (Exception e) {
            // If query fails due to security enforcement, optionally fallback.
            if (!fallback) {
                return new Response(false, 'Query failed: ' + e.getMessage(), new List<Contact>());
            }

            // Fallback: query without WITH SECURITY_ENFORCED, then strip fields (FLS).
            // Note: This does NOT enforce CRUD automatically; check object permission if you want strict CRUD.
            if (!Schema.sObjectType.Contact.isAccessible()) {
                return new Response(false, 'No access to Contact object.', new List<Contact>());
            }

            List<Contact> rows2 = [
                SELECT Id, Name, Email, EmailDomain__c, LastModifiedDate
                FROM Contact
                WHERE EmailDomain__c = :domain
                ORDER BY LastModifiedDate DESC
                LIMIT :lim
            ];

            SObjectAccessDecision dec =
                Security.stripInaccessible(AccessType.READABLE, rows2);

            List<Contact> safeRows = (List<Contact>) dec.getRecords();
            return new Response(true, 'OK (stripInaccessible fallback used)', safeRows);
        }
    }
}