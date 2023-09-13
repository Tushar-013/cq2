/**
 * @description       : 
 * @author            : Jyoti Chahal
 * @group             : 
 * @last modified on  : 08-25-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class Test_CaseTriggerController {
    @testsetup static void setupCaseNC(){
        Case newCase= new Case();
        newCase.Subject= 'NC Test';
        newCase.Description= 'NC Desc';
        newCase.Status= 'New';
        newCase.Origin= 'Email';
        insert newCase;
        
        Case newCase1= new Case();
        newCase1.Subject= 'NC Test';
        newCase1.Description= 'NC Desc';
        newCase1.Type= 'Question';
        newCase1.Status= 'New';
        newCase1.Origin= 'Email';
        insert newCase1;
    }
    @isTest
    static void testProcess(){
        User newUser= new User();
        newUser.Alias= 'NC456';
        newUser.Email= 'NCtest@info.com';
        newUser.Username='testNC@info.com';
        newUser.LastName= 'testNC';
        newUser.ProfileId= userInfo.getProfileId();
        newUser.LanguageLocaleKey= 'en_US';
        newUser.LocaleSidKey='en_US';
        newUser.TimeZoneSidKey='America/Los_Angeles';
        newUser.EmailEncodingKey='UTF-8';
        insert newUser;
        
        PermissionSet ps=[Select ID from PermissionSet Where Name = 'CQ_Admin_Extended_Permissions' LIMIT 1];
        system.runAs(newUser){
            PermissionSetAssignment psa= new PermissionSetAssignment();
            psa.AssigneeId= newUser.Id;
            psa.PermissionSetId= ps.Id;
            Insert psa;
            
            Case newCase= new Case();
            newCase.Subject= 'NC Test';
            newCase.Description= 'NC Desc';
            newCase.Status= 'New';
            newCase.Type= 'Problem';
            newCase.Origin= 'Email';
            insert newCase;
            list<compliancequest__SQX_Nonconformance__c> confList = [SELECT id FROM compliancequest__SQX_Nonconformance__c WHERE Related_to_Case__c =:newCase.Id];
            Assert.isFalse(confList.isEmpty(), 'No Conformance attached to case');
            List<Case> caseList=[SElect Id From Case WHERE Type = 'Problem' AND Id=:newCase.Id];
            system.Assert.isFalse(caseList.isEmpty(),'No Case Found');
        }
    }
    @isTest
    static void testProcess2(){
        User newUser= new User();
        newUser.Alias= 'NC45666';
        newUser.Email= 'NCtest66@info.com';
        newUser.Username='testNC66@info.com';
        newUser.LastName= 'testNC66';
        newUser.ProfileId= userInfo.getProfileId();
        newUser.LanguageLocaleKey= 'en_US';
        newUser.LocaleSidKey='en_US';
        newUser.TimeZoneSidKey='America/Los_Angeles';
        newUser.EmailEncodingKey='UTF-8';
        insert newUser;
        
        PermissionSet ps=[Select ID from PermissionSet Where Name = 'CQ_Admin_Extended_Permissions' LIMIT 1];
        system.runAs(newUser){
            PermissionSetAssignment psa= new PermissionSetAssignment();
            psa.AssigneeId= newUser.Id;
            psa.PermissionSetId= ps.Id;
            Insert psa;
            
            List<Case> csList= [Select Id From Case WHERE Type != 'Problem' LIMIT 1];
            system.Assert.isFalse(csList.isEmpty(),'No Case');
            Case csObj= csList.get(0);
            csObj.Type= 'Problem';
            update csObj;
            list<compliancequest__SQX_Nonconformance__c> confList = [SELECT id FROM compliancequest__SQX_Nonconformance__c WHERE Related_to_Case__c =:csObj.Id];
            Assert.isFalse(confList.isEmpty(), 'No Conformance attached to case');
            List<Case> caseList=[SElect Id From Case WHERE Id =: csObj.Id AND CQ_CAN_SQX_NC_Reference__c != NULL];
            system.Assert.isFalse(caseList.isEmpty(),'No Case Found');
        }
    }
}