public with sharing class CQ_CCD_Part_Family {
    
    private Map<Id, compliancequest__SQX_Part_Family__c> oldValues { get; set; }
    private List<compliancequest__SQX_Part_Family__c> newValues { get; set; }
    
    /**
     * Constructor to initialize newValues and oldValues
     * @newValues - contains Trigger.New instance
     * @oldValues - contains Trigger.Old instance
     */
    public CQ_CCD_Part_Family(List<compliancequest__SQX_Part_Family__c> newValues, Map<Id, compliancequest__SQX_Part_Family__c> oldValues){
        this.oldValues = oldValues == null ? new Map<Id, compliancequest__SQX_Part_Family__c>() : oldValues;
        this.newValues = newValues;
    }
    
    /**
     * Method to create Part record
     */ 
    public CQ_CCD_Part_Family createPartRecord(){
        List<compliancequest__SQX_Part__c> partList = new List<compliancequest__SQX_Part__c>();
        for(compliancequest__SQX_Part_Family__c pf: this.newValues){
            Integer randomNumber = (Integer)( Math.random() * 1000000 );
            partList.add(new compliancequest__SQX_Part__c(
            	Name = pf.Name + randomNumber,
                compliancequest__Active__c = true,
                compliancequest__Part_Number__c = 'ABC'+randomNumber,
                compliancequest__Part_Type__c = 'Assembly',
                compliancequest__Part_Risk_Level__c = 3,
                compliancequest__Part_Family__c = pf.Id
            ));            
        }
        
        if(partList.size()>0){
            insert partList;
        }
        
        return this;
    }
}