@isTest
global class CqPartsIntegrationMock implements HttpCalloutMock{
	global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://example.com/example/test', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"_id":"619683d69402c24f000237e9","Part Name":"Population Sensor","Total Quantity Shipped":350000}]');
        res.setStatusCode(200);
        return res;
    }
}