trigger CourseTrigger on Opportunity (after insert, after update, after delete, before update, before delete, before insert) {
    if(trigger.isAfter){
          if(trigger.isInsert){
        CourseTriggerHandler.ShareCourse(trigger.new);
        EmailTriggerHandler.sendEmailInsert(trigger.new);
        CourseTriggerHandler.eventShare(trigger.new);
      }
      else if(trigger.isUpdate){
          CourseTriggerHandler.updateCalenderEvent(trigger.new);
          EmailTriggerHandler.sendEmail(trigger.new, trigger.old);
          CourseTriggerHandler.createServiceInvoice(trigger.new, trigger.oldMap);
          CourseTriggerHandler.deleteCalenderEvent(trigger.new);
      }
      else if(trigger.isDelete){

          


      }
    }
    
    }