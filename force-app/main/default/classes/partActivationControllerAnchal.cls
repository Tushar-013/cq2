public class partActivationControllerAnchal {   
    @AuraEnabled(cacheable=true)
    public static boolean hasCQAdminPermissionSet(){
        System.debug('ab');
        PermissionSet cqps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Admin'];
        List<PermissionSetAssignment> psList = [select PermissionSet.id from PermissionSetAssignment where AssigneeId =: userInfo.getUserId()];
        for(PermissionSetAssignment ps:psList){
            if(ps.PermissionSet.id == cqps.id){
                 System.debug('ab');
                return true;
            }
        }
         return false;
       
    } 
    @AuraEnabled(cacheable=true)
    public static List<compliancequest__SQX_Part__c> getRecordDetail(Id recordID){
        System.debug(recordID);
       return [Select id,compliancequest__Reason_For_Change__c,compliancequest__Active__c from compliancequest__SQX_Part__c where id=:recordID];
       
    } 

}