({
	handleClick : function(component, event, helper) {
        var inputCmp = component.get('v.input');
        console.log(inputCmp);
    	
        
        var action = component.get('c.makeCallout');
        action.setParams({inputString : inputCmp})
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
        
                component.set('v.colorMap', response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        })
        $A.enqueueAction(action);
    },
    
    handleDisplay : function (component, event, helper) {
        
        var colorObject = component.get('v.colorMap');
        console.log(colorObject);
        const keys = Object.keys(colorObject);
        const map = new Map();
        for (let i = 0; i < keys.length; i++) {
            map.set(keys[i], colorObject[keys[i]]);
        }
        console.log(map);
        var hexValue = map.get('hex').toString();
        //console.log(hexValue);
        var rgbValue = 'rgb(' + map.get('red') + ',' + map.get('green') + ',' + map.get('blue') + ')';
        var colorImage = map.get('image');
        var colorName = map.get('name');
        
        component.set('v.hexNumber', hexValue);
        component.set('v.rgbNumber', rgbValue);
        component.set('v.image', colorImage);
        component.set('v.nameOfColor', colorName);
        
		
	},
    
    saveToDatabase : function (component, event, helper) {
    // make a call to the database and save the hex value, rgb value, image link, and name of color to database
    // make sure to check for duplicate color names in database, if so, give error.
    	var hexNum = component.get('v.hexNumber');
    	var rgbNum = component.get('v.rgbNumber');
    	var imageLink = component.get('v.image');
    	var colorName = component.get('v.nameOfColor');
        console.log('inside saveToDatabase');
    
    	var action2 = component.get('c.checkColor');
        action2.setParams({name : colorName});
        action2.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                console.log('inside checkColor');
                component.set('v.colorSave', response.getReturnValue());
                console.log(component.get('v.colorSave'));
                if (component.get('v.colorSave') == 'good') {
            		console.log('after if get colorSave');
           			var action3 = component.get('c.saveColor');
            		console.log('after component get saveColor');
        			action3.setParams({hex: hexNum,
                          				rgb: rgbNum,
                          				image: imageLink,
                          				name: colorName});
            		console.log('before action3 callback method');
        			action3.setCallback(this, function (response) {
            			let state = response.getState();
            			if(state === 'SUCCESS') {
                    		console.log('inside saveColor')
                			component.set('v.saveMessage', 'Color has been saved');
                            component.set('v.success', true);
            			}
                		else {
                    		console.log("Failed with state: " + state);
                		}
            		})
            $A.enqueueAction(action3);
        }
                else {
                    component.set('v.saveMessage', component.get('v.colorSave'));
                    component.set('v.success', false);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        })
        $A.enqueueAction(action2);
        console.log('before if get colorSave');
	}    
})