trigger InvoiceTrigger on Invoice__c (before insert, after insert, before update, after update, before delete, after delete) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            InvoiceTriggerHandler.UpdateAutoNumbers(trigger.new);

    }
    else if(trigger.isUpdate){

    }
    else if(trigger.isDelete){

        


    }
  }
  
  }