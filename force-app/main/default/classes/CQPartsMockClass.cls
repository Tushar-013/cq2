@isTest
Global class CQPartsMockClass implements HttpCalloutMock{
    Global HTTPResponse respond(HTTPRequest req) {
         System.assertEquals('https://example.com/example/test', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Total Quantity Shipped":"100","Part Risk Level":"2","_Id":"PRT3223"}');
        res.setStatusCode(200);
        return res;
    }
}