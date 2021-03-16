public class RESTConsumptionAPI {
    @AuraEnabled
    public static Map<String, Object> makeCallout(String inputString) {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.thecolorapi.com/id?' + inputString);
        request.setMethod('GET');
        Map<String, Object> finalMap = new Map<String, Object>();
        
        HttpResponse response = http.send(request);
        //System.debug(response.getBody());
        
        if(response.getStatusCode() == 200) {
            Object deserializedResponse = JSON.deserializeUntyped(response.getBody());
            Map<String, Object> respMap = (Map<String, Object>) deserializedResponse;
            Map<String, Object> hexMap = (Map<String, Object>) respMap.get('hex');
            Map<String, Object> imageMap = (Map<String, Object>) respMap.get('image');
            Map<String, Object> rgbMap = (Map<String, Object>) respMap.get('rgb');
            Map<String, Object> nameMap = (Map<String, Object>) respMap.get('name');
            
            String hexValue = String.valueOf(hexMap.get('value'));
            Integer redValue = Integer.valueOf(rgbMap.get('r'));
            Integer blueValue = Integer.valueOf(rgbMap.get('b'));
            Integer greenValue = Integer.valueOf(rgbMap.get('g'));
            
            String imageLocation = String.valueOf(imageMap.get('named'));
            
            String nameOfColor = String.valueOf(nameMap.get('value'));
            
            finalMap.put('hex', hexMap.get('value'));
            finalMap.put('red', rgbMap.get('r'));
            finalMap.put('blue', rgbMap.get('b'));
            finalMap.put('green', rgbMap.get('g'));
            finalMap.put('image', imageMap.get('named'));
            finalMap.put('name', nameMap.get('value'));
            
            //System.debug('Hex Value: ' + hexValue);
            //System.debug('Red Value: ' + redValue);
            //System.debug('Blue Value ' + blueValue);
            //System.debug('Green Value ' + greenValue);
            //System.debug('Image Location: ' + imageLocation);
            //System.debug('Name Of Color: ' + nameOfColor);
                
               
            
            //System.debug(hexMap.get('value'));
            //System.debug(respMap.get('hex'));
            //System.debug(respMap.get('image'));
            //System.debug(respMap.get('rgb'));
            //System.debug(respMap.get('name'));
            System.debug(finalMap);
        }
        return finalMap;
    }
    
    
    @AuraEnabled
    public static String checkColor(String name) {
        String errorMessage = '';
        List<Color__c> colors = [SELECT Name, Id FROM Color__c WHERE Name =: name];
        if(colors.size() != 0) {
            errorMessage = 'Name already exists in database';
        }
        else {
            errorMessage = 'good';
        }
        return errorMessage;
    }

    
    @AuraEnabled
    public static void saveColor(String hex, String rgb, String image, String name) {
        try {
            Color__c newColor = new Color__c(Name = name,
                                             Hex_Value__c = hex,
                                             RGB_Value__c = rgb,
                                             Image_Location__c = image);
            insert newColor;
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}