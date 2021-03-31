public with sharing class CourseTriggerHandler {
    
       
    public static void shareCourse(List<Opportunity> coursesToShare) {

        
        List<OpportunityShare> opportunitiesToShare = new List<OpportunityShare>();
        
        for( Opportunity opportunity : coursesToShare){
        
       OpportunityShare x = new OpportunityShare();
        
        x.OpportunityID = opportunity.Id;
        x.OpportunityAccessLevel = 'Edit';
        x.UserOrGroupId = opportunity.Instructor__c;
        
        opportunitiesToShare.add(x);
         }
        
        insert opportunitiesToShare;
    }


    public static void eventShare(List<Opportunity> eventsToShare){
        List<event> calenderEvents = new List<Event>();
        
        for(Opportunity o : eventsToShare){
            Event calenderEvent = new Event();
        calenderEvent.Subject = 'Course';
        calenderEvent.StartDateTime=o.Start_Date__c;
        calenderEvent.EndDateTime=o.CloseDate;
        calenderEvent.OwnerID=o.Instructor__C;
        calenderEvent.WhatId=o.Id;
        calenderEvents.add(calenderEvent);
        }
        insert calenderEvents;
    }

    public static void updateCalenderEvent(List<Opportunity> isUpdate){
        List<Event> calToUpdate = new List<Event>();
        List<Event> calenderEventUp = [SELECT Id, StartDateTime, EndDateTime, Subject, whatId, OwnerID, Location FROM Event WHERE WhatId in :isUpdate];
        
        for(Opportunity o : isUpdate){ 
            integer i = 0;
            for(Event e: calenderEventUp){
                if(calenderEventUp[i].WhatId == o.Id){
                    calenderEventUp[i].Subject = o.Name;
                    calenderEventUp[i].StartDateTime=o.Start_Date__c;
                    calenderEventUp[i].EndDateTime=o.CloseDate;
                    calenderEventUp[i].OwnerID=o.Instructor__C;
                    calenderEventUp[i].WhatId=o.Id;
                    calenderEventUp[i].Location=o.Location__c;
                    calToUpdate.add(calenderEventUp[i]);
                    i++;
                }           
            }   
        }
        update calToUpdate;
}

    public static void deleteCalenderEvent(List<Opportunity> isDelete){
        List<Event> calToDelete = new List<Event>();
        List<Event> calEvents = [SELECT Id, WhatId FROM Event];
        System.debug('l');
        for(Opportunity o : isDelete){
            System.debug('l');
            for(Event ev : calEvents){
                system.debug(ev.WhatId + ' ' + o.Id + o.StageName);
                if(ev.WhatId == o.Id && o.StageName.equalsignorecase('Cancelled')){
                    calToDelete.add(ev);
                }
            }System.debug(calToDelete.size());
            if(calToDelete.size() > 0){
                System.debug(calEvents.size());
                delete calToDelete;
                calEvents = [SELECT Id, WhatId FROM Event];
                System.debug(calEvents.size());

            }

        }

    }


    public static boolean isFirstTime = true;
    public static void createServiceInvoice(List<Opportunity> serviceInvoices, Map<Id, Opportunity> oldMap){
        
        List<Invoice__c> invoicesToInsert = new List<Invoice__C>();
        List<Invoice_Line_Item__C> invoiceLinesToInsert = new List<Invoice_Line_Item__C>();
        Id serviceLineRecTypeId = Schema.SObjectType.Invoice_Line_Item__c.getRecordTypeInfosByName().get('Services').getRecordTypeId();
        Id serviceRecTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByName().get('Service Invoice').getRecordTypeId();
        
        for(Opportunity course : serviceInvoices){
            if(isFirstTime){
                isFirstTime = false;
                if(course!=oldMap.get(course.Id)){
                    if(course.StageName == 'Completed' && oldMap.get(course.Id).StageName!='Completed'){
                        if(course.StageName == 'Completed'){
                            Invoice__C newInv = new Invoice__C();
                            newInv.Status__c = 'Draft';
                            newInv.Course_Selection__c = course.Id;
                            newInv.RecordTypeId = serviceRecTypeId;
                            invoicesToInsert.add(newInv);
                        }
                    insert invoicesToInsert;
                            }
                    }
                }
            }

        for(Invoice__C inv : invoicesToInsert){
            decimal duration = inv.course_selection__r.Duration__c;
                for(integer i = 0; i < 5; i++){
                    Invoice_Line_Item__c newLine = new Invoice_Line_Item__c();
                    newLine.invoice__c = inv.Id;
                    newLine.description__c = 'Day of training.';
                    newLine.recordTypeId = serviceLineRecTypeId;
                    newLine.Date__c = date.Today(); 
                    invoiceLinesToInsert.add(newLine);
                            }
            insert invoiceLinesToInsert;
                     }
            }
      }