public class CQ_CCD_Assessment {
    
    public List<CQ_CCD_Assessment__c> aList{get;set;}
    
    public CQ_CCD_Assessment(ApexPages.StandardController s){
        aList = [Select Id From CQ_CCD_Assessment__c];
    }
}