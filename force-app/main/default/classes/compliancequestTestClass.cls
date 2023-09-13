@isTest
public class compliancequestTestClass {

    @Testsetup
    public static void recordcreation(){
        compliancequest__SQX_Part__c partobj = new compliancequest__SQX_Part__c();
         partobj.compliancequest__Active__c = false;
         insert  partobj;
       
        //2nd just we need to pass the 
        Task obj  = new Task();
        obj.WhatId =partobj.Id;
        obj.Subject = 'Review Part';
        obj.Status  = 'Not Started';
        insert obj;
        
    }
     public static void testcase(){
                 compliancequest__SQX_Part__c partobj = new compliancequest__SQX_Part__c();
        partobj=[Select Id,compliancequest__Active__c from compliancequest__SQX_Part__c Limit 1];
         //Test.startTest();
         
         // boolean obj = call class method and pass the partobj.Id return string 
         //System.assertEquals(true,obj);
        // Test.stopTest();
     }
}