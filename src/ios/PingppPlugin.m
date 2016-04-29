#import "PingppPlugin.h"
#import "Pingpp.h"

@implementation PingppPlugin

- (void)createPayment:(CDVInvokedUrlCommand*)command
{
    self.myCallbackId = command.callbackId;
    
    NSDictionary* charge = [[command arguments] objectAtIndex:0];
    NSString* URLScheme = [self getURLScheme];
    
    UIViewController * __weak weakSelf = self.viewController;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [Pingpp createPayment:charge viewController:weakSelf
                 appURLScheme: URLScheme
               withCompletion:^(NSString *result, PingppError *error) {
                   
                   [self callbackResult:result error:error];
                   
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
        [self callbackResult:result error:error];
    }];
}

- (void) callbackResult:(NSString*)result error:(PingppError*) error
{
    CDVPluginResult* pluginResult = nil;
    
    if ([result isEqualToString:@"success"]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:result];
        
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
