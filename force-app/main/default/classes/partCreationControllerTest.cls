@isTest
public  class partCreationControllerTest {

    @isTest public static void testMethod1(){
        String errors;
        compliancequest__SQX_Part_Family__c partFamily = new compliancequest__SQX_Part_Family__c();
        partFamily.Name = 'Test Family';
        insert partFamily;
        
        Test.startTest();
        try{
            compliancequest__SQX_Part__c part = new compliancequest__SQX_Part__c();
            part.compliancequest__Part_Family__c = partFamily.id;
            part.compliancequest__Part_Number__c = 'Test Parts';
            part.Name='Varsha';
            part.compliancequest__Part_Risk_Level__c =3;
            part.compliancequest__Active__c=true; //if part is inserted through third party tool or through automations
            insert part;  
        }catch(Exception e){
            system.debug('messgae'+e.getMessage()); 
            errors =  e.getMessage();
        }
        

        System.assertEquals(true, errors.contains('Only CQ Admin can mark the Part as Active ')); //Reason is also mandatory if part is active
        Test.stopTest();
    }
    
    
      public testMethod static void testMethod2(){

         compliancequest__SQX_Part_Family__c partFamily = new compliancequest__SQX_Part_Family__c();
         partFamily.Name = 'Test Family';
         insert partFamily;
         
         
          compliancequest__SQX_Part__c part = new compliancequest__SQX_Part__c();
          part.compliancequest__Part_Family__c = partFamily.id;
          part.compliancequest__Part_Number__c = 'Test Parts';
          part.compliancequest__Part_Risk_Level__c =3;
          part.Name='Varsha1';
          part.compliancequest__Active__c=false; //if part is inserted through third party tool or through automations
          insert part;  
          
         
         /* Task tasks = new Task();
          tasks.Subject='Hi There';
          tasks.Status='Not Started';
          tasks.ActivityDate= system.today()+7;
          tasks.OwnerId = part.OwnerId;
          tasks.WhatId=part.id;
          insert tasks;*/
          //List<compliancequest__SQX_Part__c> p=[select OwnerId,Subject from compliancequest__SQX_Part__c where id=:part.id];
          Date dueDates=system.today()+7;
          String subjects = 'Review Part'+part.compliancequest__Part_Number__c;
          Test.startTest();
          List<Task> tasksList = [select id, WhatId,OwnerId,ActivityDate,Subject, Status from Task where whatid =: part.id AND Status='Not Started'  AND ActivityDate= :dueDates AND Subject=: subjects];   //if task is not inserted it wil fail
          system.debug('tasksList'+[select id, WhatId,OwnerId,ActivityDate,Subject, Status from Task where whatid =: part.id AND Status='Not Started' ]);
          System.assertEquals(tasksList.size(),1,'Task should be Inserted');
          
         
          Test.stopTest();
         
         
       
    }
    
    public testMethod static void testMethod3(){
         String errors;
         compliancequest__SQX_Part_Family__c partFamily = new compliancequest__SQX_Part_Family__c();
         partFamily.Name = 'Test Family';
         insert partFamily;
         
         
          compliancequest__SQX_Part__c part = new compliancequest__SQX_Part__c();
          part.compliancequest__Part_Family__c = partFamily.id;
          part.compliancequest__Part_Number__c = 'Test Parts';
          part.compliancequest__Part_Risk_Level__c =3;
          part.Name='Varsha2';
          part.compliancequest__Active__c=false;
          insert part;  
          
        Test.startTest();
        try{
            part.compliancequest__Active__c=true;  
            update part;
        }catch(Exception e){
            errors=e.getMessage();
        }
        
        System.assertEquals(true, errors.contains('Only CQ Admin can mark the Part as Active '));
        
        
        Test.stopTest();
       
    }
    
    public testMethod static void testMethod4(){

        compliancequest__SQX_Part_Family__c partFamily = new compliancequest__SQX_Part_Family__c();
        partFamily.Name = 'Test Family';
        insert partFamily;
        
        
        compliancequest__SQX_Part__c part = new compliancequest__SQX_Part__c();
        part.compliancequest__Part_Family__c = partFamily.id;
        part.compliancequest__Part_Number__c = 'Test Parts';
        part.Name='Varsha3';
        part.compliancequest__Part_Risk_Level__c =3;
        part.compliancequest__Active__c=false;
        insert part;  
        
        /*Task tasks = new Task();
        tasks.Subject='Hi There';
        tasks.Status='Not Started';
        tasks.ActivityDate= system.today()+7;
        tasks.OwnerId = part.OwnerId;
        tasks.WhatId=part.id;
        insert tasks;*/
        
        part.compliancequest__Active__c=true;  
        part.compliancequest__Reason_For_Change__c='Part is Activated';
        update part; // automation will update task status
        
        Test.startTest();
        
        List<Task> tasksListStatus = [select id, status, whatid from Task where whatid=:part.id AND Status='Completed' order by CreatedDate desc LIMIT 1]; 
        System.assertEquals(tasksListStatus.size(),1,'Task should be Updated');
        
        Test.stopTest();
        
    }
}