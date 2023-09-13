public class CQPartHandler {
    public static void createCqTask(List<compliancequest__SQX_Part__c> newCQPartList){
        List<Task> newTaskList=new List<Task>();
        List<compliancequest__SQX_Part__c> updatenewCQPartList = new List<compliancequest__SQX_Part__c>();
        Map<string,compliancequest__SQX_Part__c> updateCQMap = new Map<string,compliancequest__SQX_Part__c>();
        for(compliancequest__SQX_Part__c cq : newCQPartList){
            updateCQMap.put(cq.compliancequest__Part_Number__c,cq);
            Task tsk = new Task();
            tsk.subject = cq.compliancequest__Part_Number__c;
            tsk.ActivityDate = System.today().addDays(7);
            tsk.OwnerId = cq.OwnerId;
            tsk.status = 'Not Started';
            newTaskList.add(tsk);
        }
        try{
            if(newTaskList.size()>0)
        	{
            	Insert newTaskList;
			}
        }
        catch(Exception e){
            System.debug('Exception'+ e.getMessage());
        }
        
	}
    public static void updateCqTask(Map<Id,compliancequest__SQX_Part__c> oldCQPartMap,Map<Id,compliancequest__SQX_Part__c> newCQPartMap){
        List<task> updateTaskList = new List<Task>();
        set<string> keyset = new  set<string>();
        for(compliancequest__SQX_Part__c cq : newCQPartMap.values()){
            keyset.add(cq.compliancequest__Part_Number__c);
		}
        List<task> oldTaskList = [select id,subject,status from Task where subject In:keyset];
        system.debug('oldTaskList'+ oldTaskList);
        Map<string,Task> oldTaskMap  = new Map<string,Task>();
        for(task t : oldTaskList){
            oldTaskMap.put(t.subject,t);
		}
        for(compliancequest__SQX_Part__c cq : newCQPartMap.values()){
            if(cq.compliancequest__Active__c == true && oldCQPartMap.get(cq.Id).compliancequest__Active__c != true){
                if(cq.compliancequest__Reason_For_Change__c != Null){
                    Task cqTsk = new Task();
                    cqTsk.Id = oldTaskMap.get(cq.compliancequest__Part_Number__c).Id;
                    cqTsk.Status = 'Completed';
                    updateTaskList.add(cqTsk);
                }
			}
        }
        try{
            if(updateTaskList.size()>0){
            Update updateTaskList;
        	}
        }
        catch(Exception e){
            system.debug('Exception'+ e.getMessage());
        }
        
	}
}