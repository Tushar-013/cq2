/* 
 * An autolaunched flow with the name "CQ CCC Assessment" that takes in "recordId" as input parameter is available.
 * The flow returns the Annual revenue of the record whose record Id is passed.
 * Write the code to invoke the flow and print the Annual revenue for record Id '0010500000ReZY0AAN';
 * Annual Revenue is of Type Decimal and record Id is of type String.
*/
public class CQ_CCD_CallFlow {
    public static void CQ_CCD_CallAutoLaunchedFlow(){
                      
        Map<String, Object> params = new Map<String, Object>();
        params.put('recordId', '0010500000ReZY0AAN');
        Flow.Interview.CQ_CCC_Assessment fetchAnnualRevenue = new Flow.Interview.CQ_CCC_Assessment(params);
        fetchAnnualRevenue.start();
        
        Decimal returnValue = (Decimal) fetchAnnualRevenue.getVariableValue('annualRevenue');
        System.debug('Annual Revenue: '+ returnValue);


  
    }

}