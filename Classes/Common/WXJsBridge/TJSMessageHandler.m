//
//  TJSMessageHandler.m
//  TALHybrid
//
//  Created by leev on 2020/11/5.
//

#import "TJSMessageHandler.h"
#import <objc/message.h>
#import <arpa/inet.h>
#import "TJSWeakProxy.h"
#import "TJSNativeParam+TJSPrivate.h"

#define kTALJSBridgeFuncKeyName                             @"taljsfname"

#define kTALJSBridgeCallBackIdKey                           @"callbackid"

#define kTALJSBridgeParamsKey                               @"params"

@interface TJSMessageHandler ()

@property (nonatomic, strong) NSMutableDictionary *nativeHandlerDic;

@property (nonatomic, strong) NSMutableDictionary *callBackHandlerDic;

@end

@implementation TJSMessageHandler

- (void)dealloc
{
    [self.nativeHandlerDic removeAllObjects];
    [self.callBackHandlerDic removeAllObjects];
    _nativeHandlerDic = nil;
    _callBackHandlerDic = nil;
}

#pragma mark - Public Method

- (id)initWithWKScriptMessageHandler:(id<TScriptMessageHandler>)messageHandler
{
    self = [super init];
    if (self)
    {
        _messageHandler = messageHandler;
        _nativeHandlerDic = [NSMutableDictionary dictionaryWithCapacity:42];
        _callBackHandlerDic = [NSMutableDictionary dictionaryWithCapacity:42];
    }
    return self;;
}

- (void)saveName:(NSString *)name nativeObj:(id)nativeObj
{
    if (!name || !nativeObj)
    {
        return;;
    }
    [self.nativeHandlerDic setObject:[TJSWeakProxy proxyWithTarget:nativeObj] forKey:name];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSString *name = message.name;
    id body = message.body;
    
    NSDictionary *dic = nil;
    if ([body isKindOfClass:[NSString class]])
    {
        NSError *error;
        NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    }
    
    NSArray *allKeys = dic.allKeys;
    // 认为是走的SDK消息处理逻辑
    if ([self.nativeHandlerDic.allKeys containsObject:name] && [allKeys containsObject:kTALJSBridgeFuncKeyName])
    {
        // 携带的参数
        id params = [dic objectForKey:kTALJSBridgeParamsKey];
        
        // callbackId
        NSString *callbackId = [dic objectForKey:kTALJSBridgeCallBackIdKey];
        
        // 负责处理的native对象
        id nativeObj = [self.nativeHandlerDic objectForKey:name];
        
        // 方法名
        NSString *funcName = [dic objectForKey:kTALJSBridgeFuncKeyName];

        
        
        SEL selector = NSSelectorFromString(funcName);
        SEL params_selector = NSSelectorFromString([funcName stringByAppendingString:@":"]);
        
        if (params || callbackId) {
            //有参数
            if ([nativeObj respondsToSelector:params_selector]) {
                //本地有实现带参数的该方法
                __weak typeof(self) weakSelf = self;
                
                // 构造新的对象
                TJSNativeParam *obj = [[TJSNativeParam alloc] initWithParams:params];
                
                WKWebView *webView = message.webView;
                __weak typeof(webView) webViewWeak = webView;
                
                __weak typeof(obj) objWeak = obj;
                
                [obj setCallBackHandler:^(id result, TJSBridgeError *error) {
                    __strong typeof(objWeak) objStrong = objWeak;
                    
                    if (callbackId && (result || error))
                    {
                        NSString *jsonStr = @"";
                        // 执行callback
                        NSMutableDictionary *callbackDic = [NSMutableDictionary dictionary];
                        [callbackDic setObject:callbackId forKey:@"callbackid"];
                        if (result)
                        {
                            [callbackDic setObject:result forKey:@"result"];
                        }
                        [callbackDic setObject:[NSNumber numberWithBool:objStrong.continueCallBack] forKey:@"continue"];
                        
                        if (error)
                        {
                            NSInteger code = error.code;
                            NSString *message = error.message;
                            NSMutableDictionary *errorDic = [NSMutableDictionary dictionary];
                            [errorDic setObject:[NSNumber numberWithInteger:code] forKey:@"code"];
                            if (message)
                            {
                                [errorDic setObject:message forKey:@"message"];
                            }
                            
                            [callbackDic setObject:errorDic forKey:@"error"];
                        }
                        
                        @try {
                            NSError *error;
                            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:callbackDic options:NSJSONWritingPrettyPrinted error:&error];
                            if (jsonData)
                            {
                                jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                            }
                            
                        } @catch (NSException *exception) {
                            
                        }
                        NSString *js = [NSString stringWithFormat:@"window.app_executeCallBack(%@)", jsonStr];

                        [webViewWeak evaluateJavaScript:js completionHandler:NULL];
                    }
                    
                    // 最后删除键值对
                    if (callbackId && !objStrong.continueCallBack)
                    {
                        [weakSelf.callBackHandlerDic removeObjectForKey:callbackId];
                    }
                }];
                
                // 添加callBackId
                if (callbackId) {
                    [self.callBackHandlerDic setObject:obj forKey:callbackId];
                }
                
                if (self.messageHandler && [self.messageHandler respondsToSelector:@selector(userContentController:SDKWillRespondScriptMessage:)]) {
                    [self.messageHandler userContentController:userContentController SDKWillRespondScriptMessage:message];
                }
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [nativeObj performSelector:params_selector withObject:obj];
#pragma clang diagnostic pop
                
                if (self.messageHandler && [self.messageHandler respondsToSelector:@selector(userContentController:SDKDidHandleScriptMessage:)]) {
                    [self.messageHandler userContentController:userContentController SDKDidHandleScriptMessage:message];
                }
                return;
            }else if([nativeObj respondsToSelector:selector]) {
                //本地有实现不带参数的该方法
                
                if (self.messageHandler && [self.messageHandler respondsToSelector:@selector(userContentController:SDKWillRespondScriptMessage:)]) {
                    [self.messageHandler userContentController:userContentController SDKWillRespondScriptMessage:message];
                }
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [nativeObj performSelector:selector];
#pragma clang diagnostic pop
                
                if (self.messageHandler && [self.messageHandler respondsToSelector:@selector(userContentController:SDKDidHandleScriptMessage:)]) {
                    [self.messageHandler userContentController:userContentController SDKDidHandleScriptMessage:message];
                }
                return;
            
            }
        }else {
            //无参数
            if ([nativeObj respondsToSelector:selector]) {
                //本地有实现不带参数的该方法
                
                if (self.messageHandler && [self.messageHandler respondsToSelector:@selector(userContentController:SDKWillRespondScriptMessage:)]) {
                    [self.messageHandler userContentController:userContentController SDKWillRespondScriptMessage:message];
                }
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [nativeObj performSelector:selector];
#pragma clang diagnostic pop
                
                if (self.messageHandler && [self.messageHandler respondsToSelector:@selector(userContentController:SDKDidHandleScriptMessage:)]) {
                    [self.messageHandler userContentController:userContentController SDKDidHandleScriptMessage:message];
                }
                return;
                
            }else if([nativeObj respondsToSelector:params_selector]) {
                //本地有实现带参数的该方法
                
                if (self.messageHandler && [self.messageHandler respondsToSelector:@selector(userContentController:SDKWillRespondScriptMessage:)]) {
                    [self.messageHandler userContentController:userContentController SDKWillRespondScriptMessage:message];
                }
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [nativeObj performSelector:params_selector withObject:nil];
#pragma clang diagnostic pop
                
                if (self.messageHandler && [self.messageHandler respondsToSelector:@selector(userContentController:SDKDidHandleScriptMessage:)]) {
                    [self.messageHandler userContentController:userContentController SDKDidHandleScriptMessage:message];
                }
                return;
                
            }
        }
    }
    
    // 不符合规则的message需要转发到接入方
    if (self.messageHandler && [self.messageHandler respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)])
    {
        [self.messageHandler userContentController:userContentController didReceiveScriptMessage:message];
    }
}

- (BOOL)hostList:(NSArray *)hostList containHost:(NSString *)host
{
    // 如果host是ip的话就直接返回YES
    BOOL isVaildIP = [self isValidIP:host];
    if (isVaildIP)
    {
        return isVaildIP;
    }
    else
    {
        __block BOOL contains = NO;
        [hostList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 匹配通配符
            NSString *whiteHost = [obj stringByReplacingOccurrencesOfString:@"*" withString:@""];
            if ([host containsString:whiteHost] || [whiteHost containsString:host])
            {
                contains = YES;
                *stop = YES;
            }
        }];
        
        return contains;
    }
}

- (BOOL)isValidIP:(NSString *)host
{
    if (!host)
    {
        return NO;
    }
    
    int success;
    struct in_addr dst;
    struct in6_addr dst6;
    const char *utf8 = [host UTF8String];
    // check IPv4 address
    success = inet_pton(AF_INET, utf8, &(dst.s_addr));
    if (!success)
    {
        // check IPv6 address
        success = inet_pton(AF_INET6, utf8, &dst6);
    }
    return success;
}

@end
