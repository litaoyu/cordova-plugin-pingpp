#import "PingppPlugin.h"
#import "Pingpp.h"

@implementation PingppPlugin
NSDictionary *charge ;
- (void)createPayment:(CDVInvokedUrlCommand*)command
{
    [Pingpp setDebugMode:YES];
    self.myCallbackId = command.callbackId;
    
    charge = [[command arguments] objectAtIndex:0];
    NSString* URLScheme = [self getURLScheme];
    
    UIViewController * __weak weakSelf = self.viewController;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [Pingpp createPayment:charge viewController:weakSelf
                 appURLScheme: URLScheme
               withCompletion:^(NSString *result, PingppError *error) {
                   [self callbackResult: result charge:charge  error:error];

               }];
    });
}

-(void)setDebugMode:(CDVInvokedUrlCommand *)command{
    bool enabled = [[[command arguments] objectAtIndex:0] boolValue];
    [Pingpp setDebugMode:enabled];
}
- (void) getVersion:(CDVInvokedUrlCommand*)command{
    self.myCallbackId = command.callbackId;
    NSString *version = [Pingpp version];
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:version];
    NSLog(@"%@",version);
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.myCallbackId];
}

- (void)handleOpenURL:(NSNotification*)notification
{
    NSURL* url = [notification object];
    
    NSLog(@"handleOpenURL: %@", [url description]);
    
    if (![url isKindOfClass:[NSURL class]]) {
        return;
    }
    
    [Pingpp handleOpenURL:url withCompletion:^(NSString* result, PingppError* error) {
        [self callbackResult:result charge:charge error:error];
    }];
}

- (void) callbackResult:(NSString*)result charge:(NSDictionary *)charge error:(PingppError*) error
{
    CDVPluginResult* pluginResult = nil;
    NSMutableDictionary * errorDic = [NSMutableDictionary dictionary];
    NSLog(@"result:%@",result);
    if ([result isEqualToString:@"success"]) {
        [errorDic setValue:@{@"charge":charge} forKey:@"err"];
        [errorDic setValue:result forKey:@"result"];
        NSData* data = [NSJSONSerialization dataWithJSONObject:errorDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonString];
        
    } else {
        
        [errorDic setValue:@{@"charge":charge,@"msg":error.getMsg}
                              forKey:@"err"];
        [errorDic setValue:result forKey:@"result"];
        NSData* data = [NSJSONSerialization dataWithJSONObject:errorDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:jsonString];
        
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.myCallbackId];
}
-(NSString *)getURLScheme{
    
    NSArray *urlSchemeList = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    if ([urlSchemeList count] == 0) {
        NSLog(@"URL Scheme 为空，请在 plugin.xml 添加。");
        return nil;
    }
    NSDictionary *urlSchemeType = [urlSchemeList objectAtIndex:0];
    NSArray *schemes = [urlSchemeType objectForKey:@"CFBundleURLSchemes"];
    if ([schemes count] == 0) {
        NSLog(@"URL Scheme 为空，请在 plugin.xml 添加。");
        return nil;
    }
    NSString *scheme = [schemes objectAtIndex:0];
    
    return scheme;
    
}

@end
