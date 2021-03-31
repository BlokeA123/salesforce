public class InvoiceTriggerHandler {
    
    public static void UpdateAutoNumbers(List<Invoice__c> courseInvoices){
        AutoNumber__c[] Index = [SELECT  Service_Invoice_Index__c, Expense_Invoice_Index__c FROM AutoNumber__c];
        
        List<Autonumber__c> increment = [SELECT Service_Invoice_Index__c, Expense_Invoice_Index__c FROM AutoNumber__c];
        List<Autonumber__c> toUpdate = new List<Autonumber__c>();
        
        String ServiceRecordType = Schema.SObjectType.Invoice__c.getRecordTypeInfosByName().get('Service Invoice').getRecordTypeId();
        String ExpenseRecordType = Schema.SObjectType.Invoice__c.getRecordTypeInfosByName().get('Expenses Invoice').getRecordTypeId();
        
        for (Invoice__c a : courseInvoices){
            
            if(a.RecordTypeId == ServiceRecordType){
                
                Decimal toInt = Index[0].Service_Invoice_Index__c.intValue();
                String toString = toInt.toPlainString();
                Integer size = toString.length();            
                Integer addZeros = 4 - size;            
                String placeHolder = '';
                
                for(Integer i = 0; i < addZeros; i++){
                    placeHolder += '0';
                }
                
                a.Name = 'INV-{'+ placeHolder + Index[0].Service_Invoice_Index__c + '}';
                AutoNumber__c test = increment[0];
                test.Service_Invoice_Index__c += 1;
                toUpdate.add(test);
            }
            
            else if(a.RecordTypeId == ExpenseRecordType){
                
                Decimal toInt = Index[0].Expense_Invoice_Index__c.intValue();
                String toString = toInt.toPlainString();
                Integer size = toString.length();            
                Integer addZeros = 4 - size;            
                String placeHolder = '';
                
                for(Integer i = 0; i < addZeros; i++){
                    placeHolder += '0';
                }
                
                a.Name = 'EXPINV-{' + placeHolder + Index[0].Expense_Invoice_Index__c + '}';
                AutoNumber__c test = increment[0];
                test.Expense_Invoice_Index__c += 1;
                toUpdate.add(test);
                
                
            }
        }


        set<autoNumber__c> toSet = new set<autoNumber__c>();
        List<autoNumber__c> toList = new List<autoNumber__c>();
        toSet.addAll(toUpdate);
        toList.addAll(toSet);
        update ToList;
    }
    
}