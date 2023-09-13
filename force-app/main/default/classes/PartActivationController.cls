public class PartActivationController {
    
    @AuraEnabled
    public static boolean checkCQAdminUser(){
        boolean isCQAdmin = false;
        try{
            set<Id> assigneeIdsSet = new set<Id>();
            PermissionSet CQAdminUserPermissionSet = [SELECT Id,Name FROM PermissionSet WHERE Name = 'CQ_Admin'];
            list<PermissionSetAssignment> permAssignmentList = [SELECT Id, AssigneeId FROM PermissionSetAssignment 
                                                      WHERE PermissionSetId =:CQAdminUserPermissionSet.Id];
            
            if(permAssignmentList.size()>0){
                for(PermissionSetAssignment rec : permAssignmentList){
                    assigneeIdsSet.add(rec.AssigneeId);
                }
                if(assigneeIdsSet.contains(UserInfo.getUserId())){
                    isCQAdmin = true;
                }else{
                 	isCQAdmin = false;   
                }
            }
            
        }catch(Exception e){
            system.debug('exception--->'+e.getMessage());
        }
        
        
        return isCQAdmin;
    }

}