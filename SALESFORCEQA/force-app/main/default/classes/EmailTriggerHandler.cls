public with sharing class EmailTriggerHandler {

        public static void sendEmail(List<Opportunity> courses, List<Opportunity> oldCourses){

            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            List<Opportunity> listOfInstructors = new List<Opportunity>([SELECT Id, Name, Start_Date__c, Instructor__r.email, Instructor__r.name, StageName FROM Opportunity WHERE Id in :courses]);
            String subject = 'Scheduled Course';
   
            Integer i = 0;
            
            for(Opportunity course : listOfInstructors){
                List<String> toAddresses = new List<String>();
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();


                    if(course.StageName == 'Cancelled' && oldCourses[i].StageName != 'Cancelled'){
                    String body = 'Dear: ' +  + ', <br> Your course of type: ' + Course.Name + '. Starting on ' + course.Start_Date__c + ', has now been cancelled.';
                    toAddresses.add(course.Instructor__r.email);
                    email.setToAddresses(toaddresses);
                    email.setSubject('Cancelled Course');
                    email.setHtmlBody(body);
                    emails.add(email);     
                    }
            
                    else if(course.StageName == 'Scheduled' && oldCourses[i].StageName != 'Scheduled') {
                        String body = 'Dear: ' + course.Instructor__r.Name + ', <br> You have a course of type: ' + Course.Name + '. Starting on ' + course.Start_Date__c + '.';
                        toAddresses.add(course.Instructor__r.email);
                        email.setToAddresses(toAddresses);
                        email.setSubject(subject);
                        email.setHtmlBody(body);
                        emails.add(email);  
                    }   
                    i++;
           
                } 
                Messaging.sendEmail(emails, false);
            }








            public static void sendEmailInsert(List<Opportunity> courses){

                List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                List<Opportunity> listOfInstructors = new List<Opportunity>([SELECT Id, Name, Start_Date__c, Instructor__r.email, Instructor__r.name, StageName FROM Opportunity WHERE Id in :courses]);
                String subject = 'Scheduled Course';
       
                
                
                for(Opportunity course : listOfInstructors){
                    List<String> toAddresses = new List<String>();
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    
    
                        if(course.StageName == 'Cancelled'){
                        String body = 'Dear: ' +  + ', <br> Your course of type: ' + Course.Name + '. Starting on ' + course.Start_Date__c + ', has now been cancelled.';
                        toAddresses.add(course.Instructor__r.email);
                        email.setToAddresses(toaddresses);
                        email.setSubject('Cancelled Course');
                        email.setHtmlBody(body);
                        emails.add(email);     
                        }
                
                        else if(course.StageName == 'Scheduled') {
                            String body = 'Dear: ' + course.Instructor__r.Name + ', <br> You have a course of type: ' + Course.Name + '. Starting on ' + course.Start_Date__c + '.';
                            toAddresses.add(course.Instructor__r.email);
                            email.setToAddresses(toAddresses);
                            email.setSubject(subject);
                            email.setHtmlBody(body);
                            emails.add(email);  
                        }   
                
                    }
                    Messaging.sendEmail(emails, false);
                }

    }
