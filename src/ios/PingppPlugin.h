#import <Cordova/CDV.h>

@interface PingppPlugin : CDVPlugin
/** 调用支付接口 */
- (void) createPayment:(CDVInvokedUrlCommand*)command;
/** 开启Ping++DSK 的 debug模式 */
- (void) setDebugMode:(CDVInvokedUrlCommand*)command;
/** 获取当前SDK版本号 */
- (void) getVersion:(CDVInvokedUrlCommand*)command;
@property (nonatomic, strong) NSString* myCallbackId;

@end
