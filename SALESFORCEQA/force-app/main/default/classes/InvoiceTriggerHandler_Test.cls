@isTest
public with sharing class InvoiceTriggerHandler_Test {
    @isTest
    public static void AutoNumGenerator(){
        String serviceRecordType = Schema.SObjectType.Invoice__c.getRecordTypeInfosByName().get('Service Invoice').getRecordTypeId();
        List<Invoice__c> invoiceList = new List<Invoice__c>();

        List<AutoNumber__c> autoNumberList = new List<AutoNumber__c>();
        AutoNumber__c autoNumService = new AutoNumber__c (Name = 'Service Invoice Number', Service_Invoice_index__c = 1, Expense_Invoice_index__c = 1);
        autoNumberList.add( autoNumService);
        insert autoNumberList;


        for(Integer i = 0; i<201; i++){
            Invoice__c serviceInvoices = new Invoice__c(Name='abc', RecordTypeId = serviceRecordType, course_selection__c = '0064L000006w3BqQAI');
            invoiceList.add(serviceInvoices);
        }
        insert invoiceList;

        Test.startTest();
        Test.stopTest();
            List<Invoice__c> recordA = [SELECT Name FROM Invoice__c ORDER BY Name ASC LIMIT 1 ];
            List<Invoice__c> recordB = [SELECT Name FROM Invoice__c ORDER BY Name DESC LIMIT 1 ];
            String getRecordAName = recordA[0].Name;
            String getRecordBName = recordB[0].Name;


            System.assertEquals(201, [SELECT count() FROM Invoice__c]);
            System.assertEquals('INV-{0001}', getRecordAName);
            System.assertEquals('INV-{0201}', getRecordBName);
    }
}