public with sharing class VijayCqRest {

    
    public static HttpResponse getDataFromApi(){
        http http = new http();
        HttpRequest request = new HttpRequest();
        request.setMethod('Get');
        request.setHeader('Content-type','application/json');
        request.setEndpoint('');
        HttpResponse response =http.send(request);
        if(response!=null && response.getStatusCode()==200){
        }
        return null;
    }
    
    
}