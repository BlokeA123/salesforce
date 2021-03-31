@isTest
public with sharing class CourseTriggerHandler_Test {

        @testSetup
        private static void testSetupObjectDataFactory() {
    
            List<Opportunity> oppList = new List<Opportunity>();
            for(Integer i =0; i < 201; i++){
                Opportunity testCourse = new Opportunity (StageName='Scheduled',Name='Test Company Ltd', Start_Date__c =Date.newInstance(Date.today().year(), 9, 1),
                                                        CloseDate= Date.newInstance(Date.today().year(), 9, 3), OwnerId='0054L000000FqU5QAK',Instructor__c='0054L000000FsBWQA0', Course__c='a024L0000033YaVQAU') ;
                oppList.add(testCourse);
                
            }
    
            insert oppList;
    
            List<AutoNumber__c> autoNumberList = new List<AutoNumber__c>();
            AutoNumber__c autoNumService = new AutoNumber__c (Name = 'Service Invoice Number', Service_Invoice_Index__c = 1);
            autoNumberList.add( autoNumService);
            AutoNumber__c autoNumExpense = new AutoNumber__c (Name = 'Expense Invoice Number', Expense_Invoice_Index__c = 1);
            autoNumberList.add( autoNumExpense);
            insert autoNumberList;
    
            
            
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = [SELECT Id FROM User WHERE profileId = :p.Id LIMIT 1];
            System.runAs(u){
            }
    
    
        }
        
        @isTest
        public static void OppToEventUpdateOrDelete_Test() {
    
            
    
            Test.startTest();
                    List<Opportunity> oppList = [SELECT Id, StageName,Start_Date__c,CloseDate,OwnerId,Name,Instructor__c FROM Opportunity ];
                    System.debug('oppList bring in ' + oppList);
                for(Integer i = 0; i < oppList.size(); i++){
    
                    oppList[i].Start_Date__c = Date.newInstance(Date.today().year(), 9, 2); 
                    oppList[i].StageName = 'Completed';
                }
                // System.debug('The number'+oppList.size());
                // update oppList; 
                // for(Integer i = 0; i < oppList.size(); i++){
    
                //     oppList[i].Start_Date__c = Date.newInstance(Date.today().year(), 9, 2); 
                //     oppList[i].StageName = 'Scheduled';
                // }
                // System.debug('The number'+oppList.size());
                // update oppList;   
                // for(Integer i = 0; i < oppList.size(); i++){
    
                //     oppList[i].Start_Date__c = Date.newInstance(Date.today().year(), 9, 2); 
                //     oppList[i].StageName = 'Cancelled';
                // }
                System.debug('The number'+oppList.size());
                update oppList;     
            Test.stopTest();
            System.assertEquals(201, [SELECT count() FROM Event ]);
            System.assertEquals(1, [SELECT count() FROM Invoice__C]);
    
        }
        
    }