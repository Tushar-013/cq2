@isTest
public class VijayCqRestTest {

    @testsetup 
    public static void setdata(){
    
        
    }
    
    @isTest
    public static void test_method1(){
    	user testuser=[select id, name from user where profile.name='System administrator' LIMIT 1];
        system.runAs(testuser){
           system.Test.setMock(HttpCalloutMock.class, new VijayCqTestHttpResponse());
           system.Test.startTest();
           HttpResponse res = VijayCqRest.getDataFromApi();
        	String contentType = res.getHeader('Content-Type');
        	System.assert(contentType == 'application/json');
        	String actualValue = res.getBody();
        	String expectedValue = '{"example":"test"}';
        	System.assertEquals(actualValue, expectedValue);
        	System.assertEquals(200, res.getStatusCode());
        }
        
    }
    
    @isTest
    public static void test_method2(){
        
    }
}