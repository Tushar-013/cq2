public class CQ_CCD_invocableApex {
    @InvocableMethod(label='Invoke Apex')
    public static List<FlowOutputs> invokeThisMethod(List<FlowInputs> request) {
        
        String fName = request.get(0).FirstName;
        String lName = request.get(0).LastName;
        
        FlowOutputs result = new FlowOutputs();
        
        result.FullName = fName + lName;
        result.age = request.get(0).age;
        
        List<FlowOutputs> responseWrapper= new List<FlowOutputs>();
        responseWrapper.add(result);
        return responseWrapper;  

    }
    
    public class FlowInputs{
    
        @InvocableVariable
        public String FirstName;
        
        @InvocableVariable
        public String LastName;
        
        @InvocableVariable
        public String age;
        
    }
    
    public class FlowOutputs{
        
        @InvocableVariable
        public String FullName;
        
        @InvocableVariable
        public String age;

    }    
}