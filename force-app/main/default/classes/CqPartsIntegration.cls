public class CqPartsIntegration {
    public void callCQParts(){
        HTTPRequest req = new HTTPRequest();
        req.setMethod('GET');
        req.setHeader('Content-type','application/json');
        req.setHeader('x-api-key','b96d75ce0f9f342d10af6710ef8ea7ed0ad06');
        req.setEndpoint('https://cqparts-3d06.restdb.io/rest/cqpart');
        HttpResponse res = new HttpResponse();
        Http httpSend = new Http();
        res = httpSend.send(req);
        system.debug('status Code-->'+res.getStatusCode());
        if(res.getStatusCode() == 200){
            system.debug('response Body-->'+res.getBody());
            //map<string,Object> responseMap = (map<string,Object>)Json.deserializeUntyped(res.getBody());
        }        
    }
}