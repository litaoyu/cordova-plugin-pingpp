/**
 * ping++, cordova, module
 * License: Apache License 2.0
 * */

module.exports = {
    /**
     * @param {var|boll} enabled
     */
    setDebugMode:function (enabled){
        cordova.exec(function(){}, function(){}, "PingppPlugin", "setDebugMode", [enabled]);
    },
    /**
     * @param {Function} successCallback [获取当前SDK的版本号]
     */
    getVersion:function(successCallback){
        cordova.exec(successCallback, function(){}, "PingppPlugin", "getVersion", []);
    },
    /**
     * @param {object|string} params
     * @param {object|string} url
     * @param {Function} successCallback ['success']
     * @param {Function} errorCallback ['fail'|'cancel'|'invalid']
     */
    requestPayment:function (params, url, header, successCallback, errorCallback) {
    	
    	window.cordovaHTTP.post(url, params, header, function(response) {
    		 
    		 var charge = response.data;
			 if (typeof charge === 'object') { charge = JSON.stringify(charge); }
	         cordova.exec(function(response){
	        	 if(typeof response !== 'object'){ response = JSON.parse(response);}
	        	 successCallback(response.result, response.err);
	         }, function(response){
	        	 if(typeof response !== 'object'){ response = JSON.parse(response);}
	        	 errorCallback(response.result, response.err);
	         }, "PingppPlugin", "createPayment", [charge]);
		}, function(response) {
			error(response, null);
		});
    },
};
