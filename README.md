# Cordova Pingpp Plugin


## Using



#### 目前只包含支付宝、微信、银联渠道。

install form github

```sh
$ cordova plugin add https://github.com/litaoyu/cordova-plugin-pingpp.git
```


javascript

```
js
//调用支付功能            
var param = {
                channel: "alipay",
                amount: 10,
                custom_params:{
                	extra1:'extra1',
                	extra2:'extra2'
                }
            };
		var header = {"Content-Type":"application/json"}
		pingpp.requestPayment(param,'http://218.244.151.190/demo/charge', header, function(result, err) {
			alert('res: ' + result); // "success"
			alert("charge::" + err.charge);
		}, function(result, err) {
			alert('res: ' + result); // "fail"|"cancel"|"invalid"
			alert('charge::' + err.charge);
			alert('msg::' + err.msg);
		});

//开启debug模式
pingpp.setDebugMode(enabled) // [true] or [false];

//获取当前SDK版本号
pingpp.getVersion(function(version){
    alert("当前SDK版本号是:"+version);
});

```



## More Info

Base on pingpp native sdk

[pingpp-ios](https://github.com/PingPlusPlus/pingpp-ios)

[pingpp-android](https://github.com/PingPlusPlus/pingpp-android)

## ChangeLog
- Change plugin ID to "com.justep.cordova.plugin.pingpp"
- Change Cordova version "5.4.1"
- Add Function [setDebugMode()、getVersion()]
- Add LocalSDK (Android、iOS)
- Add URL_SCHEME variable 

## Issues
[issues](https://github.com/litaoyu/cordova-plugin-pingpp/issues)


## 如果本插件给您或您的公司带来帮助 请别忘记点击右上角的【Star】

## License

Apache License 2.0
