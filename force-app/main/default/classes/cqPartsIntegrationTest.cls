@isTest
public class cqPartsIntegrationTest {
    static testmethod void callCQPartsTest(){
        HTTPRequest req = new HTTPRequest();
        req.setMethod('GET');
        req.setHeader('Content-type','application/json');
        req.setHeader('x-api-key','b96d75ce0f9f342d10af6710ef8ea7ed0ad06');
        req.setEndpoint('https://cqparts-3d06.restdb.io/rest/cqpart');
        system.test.setMock(HttpCalloutMock.class, new CqPartsIntegrationMock());        
        CqPartsIntegration cqPartsInt = new CqPartsIntegration();
        cqPartsInt.callCQParts();
    }
}