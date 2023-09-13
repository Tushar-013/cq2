/**
 * @description       : 
 * @author            : Jyoti Chahal
 * @group             : 
 * @last modified on  : 08-25-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class caseTriggerController {
    /**
    * @description 
    * @author Jyoti Chahal
    * @param caseList 
    * @return boolean 
    **/
    public static boolean isRecursion= true;
    /**
    * @description 
    * @author Jyoti Chahal
    * @param caseList 
    **/
    public static void createNonconformance(List<Case> caseList){
        try{
                List<PermissionSetAssignment> permissionSetList=[Select AssigneeId,PermissionSet.Name From PermissionSetAssignment Where PermissionSet.Name = 'CQ_Admin_Extended_Permissions' AND AssigneeId =: UserInfo.getUserId()];
                system.debug('permissionSetList:::'+permissionSetList);
                Set<Id> caseIds= new Set<Id>();
                List<Case> updateCaseList= new List<Case>();
                List<compliancequest__SQX_Nonconformance__c> newConformanceList= new List<compliancequest__SQX_Nonconformance__c>();
                for(Case caseObj: caseList){
                    if(caseObj.Type == 'Problem'){
                        caseIds.add(caseObj.Id);
                    }
                }
                //checking the case ids
            if(!caseIds.isEmpty()){
                Map<Id,compliancequest__SQX_Nonconformance__c> exisingNCMap= new Map<Id,compliancequest__SQX_Nonconformance__c>([Select Id,Name From compliancequest__SQX_Nonconformance__c Where Related_to_Case__c IN: caseIds LIMIT 10000]);
                system.debug('exisingNCMap:::'+exisingNCMap.values());
                for(Case caseObj: caseList){
                    if(!permissionSetList.isEmpty() && exisingNCMap.isEmpty()){
                        newConformanceList.add(new compliancequest__SQX_Nonconformance__c(compliancequest__Type__c='Internal',compliancequest__NC_Title__c=caseObj.Subject,compliancequest__Description__c=caseObj.Description,compliancequest__QMS_Reference_Number__c=caseObj.CaseNumber,Related_to_Case__c=caseObj.Id));            
                    }
                }
                //insert the NC object and checkig the access
                if(!newConformanceList.isEmpty() && (Schema.SObjectType.compliancequest__SQX_Nonconformance__c.isCreateable())){
                    insert newConformanceList;
                }
                for(compliancequest__SQX_Nonconformance__c NCobj: newConformanceList){
                    updateCaseList.add(new Case(Id= NCobj.Related_to_Case__c,CQ_CAN_SQX_NC_Reference__c=NCobj.Id));
                }
                //update the case object and checkig the access
                if(!updateCaseList.isEmpty() && (Schema.SObjectType.Case.isUpdateable())){
                    update updateCaseList;
                }
            }
            
        }
        catch(Exception ex){
            system.debug('EXception:::'+ex.getMessage());
            throw ex;
        }
        
    }
    
}