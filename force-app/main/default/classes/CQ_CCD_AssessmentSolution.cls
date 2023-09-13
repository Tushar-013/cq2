public class CQ_CCD_AssessmentSolution {
    
    public List<CQ_CCD_Assessment__c> aList{get;set;}
    
    public CQ_CCD_AssessmentSolution(ApexPages.StandardController s){
        aList = [Select CQ_CCD_Candidate_Name__c, CQ_CCD_Score__c From CQ_CCD_Assessment__c];
    }


}