public class partTriggerHelperAnchal {
    public static void createTask(List<compliancequest__SQX_Part__c> cqpartList){
        
        System.debug('ab');
        List<Task> tasktobeCreated = new List<Task>();
        Task task;
        for(compliancequest__SQX_Part__c cqpart:cqpartList){
            task = new Task();
            task.Subject = 'Review Part - ' + cqpart.compliancequest__Part_Number__c;
            task.ActivityDate = cqpart.createdDate.addDays(7).date();
            task.OwnerId = cqpart.CreatedById;
            task.Status = 'Not Started';
            tasktobeCreated.add(task);
            
        }
        System.debug(tasktobeCreated);
        if(!tasktobeCreated.isEmpty()){
            try{
                insert tasktobeCreated;
            }
            catch(Exception e){
                System.debug(e.getMessage());
            }
        }
        
    }
    
    public static void updateTaskStatus(List<compliancequest__SQX_Part__c> cqpartList){
        Set<String> cqpartIds = new Set<String>();
        for(compliancequest__SQX_Part__c cq :cqpartList){
            if(cq.compliancequest__Active__c && cq.compliancequest__Reason_For_Change__c != null){
                cqpartIds.add(cq.compliancequest__Part_Number__c);
            }
        }
        List<Task> taskList = [Select id,Status,Subject from Task where Subject like '%Review Part - %'];
        List<Task> tasktobeUdated = new List<Task>();
        for(Task task:taskList){
            if(cqpartIds.contains(task.Subject.substringAfterLast(' - '))){
                task.Status = 'Completed';
                tasktobeUdated.add(task);
            }
        }
        if(!tasktobeUdated.isEmpty()){
            try{
                update tasktobeUdated;
            }
            catch(Exception e){
                System.debug(e.getMessage());
            }
        }
    }  
}