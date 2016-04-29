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
pingpp.createPayment(charge, function(result){
    console.log('suc: '+result);  // "success"
  }, function(result){
    console.log('err: '+result);  // "fail"|"cancel"|"invalid"
});

//开启debug模式
pingpp.setDebugMode(enabled) // [true] or [false];

//获取当前SDK版本号
pingpp.getVersion(function(version){
    alert("当前SDK版本号是:"+version);
});

```

with Angular (#ionic)

```
js
angular.module('yourApp', [])
  .factory('$pingpp', ['$q', '$window', function ($q, $window) {
    return {
      createPayment: function (charge) {
        return $q(function (resolve, reject) {
          $window.pingpp.createPayment(charge, function () {
            resolve();
          }, function (err) {
            reject(err);
          });
        });
      }
    };
  }]);
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
