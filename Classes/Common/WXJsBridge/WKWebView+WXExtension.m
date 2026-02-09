//
//  WKWebView+WXExtension.m
//  CommonBusinessKit
//
//  Created by 唐绍禹 on 2021/8/5.
//

#import "WKWebView+WXExtension.h"

#import <objc/message.h>
#import <arpa/inet.h>
#import "AZH5UserAgentManager.h"
#import <WXToolKit/WXToolKit.h>
#import "YYKit/YYKit.h"
#import "WXCommonMacro.h"
#import <Masonry/Masonry.h>
#import "AppInfo.h"
#import "EpicUnityAdapterManager.h"

//#import "AppUnityPluginConfigManager.h"



@interface AZReloadView : UIView
@property (nonatomic, copy) void(^reloadBlock)(void);
@end

@interface WKWebView ()<TScriptMessageHandler,WKUIDelegate,WKNavigationDelegate>
@end

@implementation WKWebView (WXExtension)

+ (void)load {
    
    Method initWithConfigMethod = class_getInstanceMethod([self class], @selector(initWithFrame:configuration:));
    Method wx_initWithConfigMethod = class_getInstanceMethod([self class], @selector(wx_initWithFrame:configuration:));
    method_exchangeImplementations(initWithConfigMethod, wx_initWithConfigMethod);
    
    Method loadRequestMethod = class_getInstanceMethod([self class], @selector(loadRequest:));
    Method wx_loadRequestMethod = class_getInstanceMethod([self class], @selector(wx_loadRequest:));
    method_exchangeImplementations(loadRequestMethod, wx_loadRequestMethod);
    
}


#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)wx_initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    
    //注册WXJS和NTJS
    [self regsiterWXJsBridgeWithConfiguration:configuration];
    
    [self wx_initWithFrame:frame configuration:configuration];
    [self resetIPadUA];
    
    
    return self;
}

- (void)resetIPadUA {
        NSString *userAgent = [AZH5UserAgentManager getUserAgent];
        if(nil == userAgent)
        {
            return;
        }
        [self setCustomUserAgent:userAgent];
}

- (WKNavigation *)wx_loadRequest:(NSURLRequest *)request
{
    if (request.URL)
    {
        NSMutableURLRequest *mutableURLRequest = nil;
        if ([request isKindOfClass:[NSMutableURLRequest class]])
        {
            mutableURLRequest = (NSMutableURLRequest *)request;
        }
        else
        {
            mutableURLRequest =  [NSMutableURLRequest requestWithURL:request.URL cachePolicy:request.cachePolicy timeoutInterval:request.timeoutInterval];
        }
        
        [mutableURLRequest addValue:[NSString stringWithFormat:@"%@", [AppInfo appVersionNumber]] forHTTPHeaderField:@"appVersionNumber"];
        [mutableURLRequest addValue:[AppInfo systemName] forHTTPHeaderField:@"systemName"];
        [mutableURLRequest addValue:@"7" forHTTPHeaderField:@"device"];
    
        NSArray *cookieList = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:mutableURLRequest.URL];
        NSDictionary* cookieHeaderDict = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieList];
        NSString *cookie = [cookieHeaderDict wx_stringForKey:@"Cookie"];
        [mutableURLRequest setValue:cookie forHTTPHeaderField:@"Cookie"];
        
        //拼接__injectToken，补齐除了WXBrowerController其他场景的逻辑
        if(![mutableURLRequest.URL.absoluteString containsString:@"__injectToken"]){
            if([mutableURLRequest.URL.absoluteString hasPrefix:@"file://"]){
                mutableURLRequest.URL = [NSURL fileURLWithPath:[mutableURLRequest.URL.absoluteString wx_appendQueryString:[NSString stringWithFormat:@"__injectToken=%@", [EpicUnityAdapterManager sharedInstance].authProvider.authToken]]];
            }
            else
            {
                mutableURLRequest.URL = [NSURL URLWithString:[mutableURLRequest.URL.absoluteString wx_appendQueryString:[NSString stringWithFormat:@"__injectToken=%@",[EpicUnityAdapterManager sharedInstance].authProvider.authToken]]];
            }
        }
        request = mutableURLRequest;
    }
    
    return [self wx_loadRequest:request];
}

#pragma mark - 注册bridge

- (void)regsiterWXJsBridgeWithConfiguration:(WKWebViewConfiguration *)configuration {
    
    BOOL WXJsBridgeExist = NO;
    for (NSString *name in configuration.userContentController.messageNames) {
        if ([name isEqualToString:@"WXJsBridge"]) {
            WXJsBridgeExist = YES;
        }
    }
    
    if (WXJsBridgeExist == NO) {
        if (self.jsbridge == nil) {
            self.jsbridge = [WXJsBridge new];
        }
        [configuration.userContentController addScriptMessageHandler:self name:@"WXJsBridge" nativeObj:self.jsbridge];
    }
}
//#pragma mark - JS交互


#pragma mark - 同步cookie

#pragma mark - getter、setter
static const char *WXJsBridgeKey = "WXJsBridgeKey";
static const char *NTJsBridgeKey = "NTJsBridgeKey";
static const char *UIDelegateKey = "UIDelegateKey";
static const char *NavigationDelegateKey = "NavigationDelegateKey";
static const char *WhiteHostListKey = "WhiteHostListKey";
static const char *NTIgnoreWhiteHostListKey = "NTIgnoreWhiteHostListKey";

- (void)setJsbridge:(WXJsBridge *)jsbridge {
    objc_setAssociatedObject(self, &WXJsBridgeKey, jsbridge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WXJsBridge *)jsbridge {
    return objc_getAssociatedObject(self, &WXJsBridgeKey);
}

- (void)setWx_UIDelegate:(id<WKUIDelegate>)wx_UIDelegate {
    objc_setAssociatedObject(self, &UIDelegateKey, [YYWeakProxy proxyWithTarget:wx_UIDelegate], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.UIDelegate = self;
}

- (id<WKUIDelegate>)wx_UIDelegate {
    return objc_getAssociatedObject(self, &UIDelegateKey);
}

- (void)setIgnoreWhiteHostList:(BOOL)ignoreWhiteHostList {
    objc_setAssociatedObject(self, &NTIgnoreWhiteHostListKey, @(ignoreWhiteHostList), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ignoreWhiteHostList {
    return [objc_getAssociatedObject(self, &NTIgnoreWhiteHostListKey) boolValue];
}


- (void)setWx_navigationDelegate:(id<WKNavigationDelegate>)wx_navigationDelegate {
    objc_setAssociatedObject(self, &NavigationDelegateKey, [YYWeakProxy proxyWithTarget:wx_navigationDelegate], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.navigationDelegate = self;
}

- (id<WKNavigationDelegate>)wx_navigationDelegate {
    return objc_getAssociatedObject(self, &NavigationDelegateKey);
}

- (void)setWhiteHostList:(NSArray *)whiteHostList {
    objc_setAssociatedObject(self, &WhiteHostListKey, whiteHostList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)whiteHostList {
    return objc_getAssociatedObject(self, &WhiteHostListKey);
}


#pragma mark - 校验白名单
- (BOOL)containWhiteHost:(NSURL *)url {
    
    return YES;
//    if ([url.absoluteString hasPrefix:@"http://"]) {
//        
//        return NO;
//    }
//    
//    NSString *host = url.host;
//    if (host.length == 0) {
//        return YES;
//    }
//    
//    BOOL isVaildIP = [self isValidIP:host];
//    if (isVaildIP) {
//        return YES;
//    }else {
//        NSArray *blackList = [[AppConfigManager sharedManager].whiteList wx_arrayForKey:@"blacklist"];
//        if ([[AppUnityPluginConfigManager sharedManager].blackList isKindOfClass:[NSArray class]]) {
//            blackList = [AppUnityPluginConfigManager sharedManager].blackList;
//        }
//        NSArray *whiteList = [[AppConfigManager sharedManager].whiteList wx_arrayForKey:@"whitelist"];
//        if ([[AppUnityPluginConfigManager sharedManager].whiteList isKindOfClass:[NSArray class]]) {
//            whiteList = [AppUnityPluginConfigManager sharedManager].whiteList;
//        }
//        NSMutableArray *remoteWhiteList = [NSMutableArray arrayWithArray:whiteList];
//        [remoteWhiteList addObjectsFromArray:self.whiteHostList];
//        [remoteWhiteList addObject:@"chuangjing.com"];
//        
//        __block BOOL blackContains = NO;
//        [blackList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            NSString *blackHost = [obj stringByReplacingOccurrencesOfString:@"*" withString:@""];
//            if ([host containsString:blackHost] || [blackHost containsString:host]) {
//                blackContains = YES;
//                *stop = YES;
//            }
//        }];
//        
//        if (blackContains) {
//            return NO;
//        }
//        
//        if (remoteWhiteList.count == 0) {
//            return YES;
//        }
//        
//        __block BOOL whiteContains = NO;
//        [remoteWhiteList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            // 匹配通配符
//            NSString *whiteHost = [obj stringByReplacingOccurrencesOfString:@"*" withString:@""];
//            if ([host containsString:whiteHost] || [whiteHost containsString:host]) {
//                whiteContains = YES;
//                *stop = YES;
//            }
//        }];
//        
//        if (whiteContains) {
//            return YES;
//        }
//        
//        return NO;
//    }
}

- (BOOL)isValidIP:(NSString *)host {
    if (!host) {
        return NO;
    }
    
    int success;
    struct in_addr dst;
    struct in6_addr dst6;
    const char *utf8 = [host UTF8String];
    // check IPv4 address
    success = inet_pton(AF_INET, utf8, &(dst.s_addr));
    if (!success) {
        // check IPv6 address
        success = inet_pton(AF_INET6, utf8, &dst6);
    }
    return success;
}

- (BOOL)respondsToSelector:(SEL)aSelector {

    if ([NSStringFromSelector(aSelector) isEqualToString:@"webView:createWebViewWithConfiguration:forNavigationAction:windowFeatures:"] ||
        [NSStringFromSelector(aSelector) isEqualToString:@"webView:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:"] ||
        [NSStringFromSelector(aSelector) isEqualToString:@"webView:decidePolicyForNavigationAction:decisionHandler:"] ||
        [NSStringFromSelector(aSelector) isEqualToString:@"webView:didFailProvisionalNavigation:withError:"]) {
        return YES;
    }
    
    if ([self.wx_UIDelegate respondsToSelector:aSelector] || [self.wx_navigationDelegate respondsToSelector:aSelector]) {
        return YES;
    }

    return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {

    if ([self.wx_UIDelegate respondsToSelector:aSelector]) {
        return self.wx_UIDelegate;
    }
    if ([self.wx_navigationDelegate respondsToSelector:aSelector]) {
        return self.wx_navigationDelegate;
    }

    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if ([self.wx_UIDelegate respondsToSelector:@selector(webView:createWebViewWithConfiguration:forNavigationAction:windowFeatures:)]) {
        return [self.wx_UIDelegate webView:webView createWebViewWithConfiguration:configuration forNavigationAction:navigationAction windowFeatures:windowFeatures];
    }else {
        if (!navigationAction.targetFrame.isMainFrame) {
            [webView loadRequest:navigationAction.request];
        }
        return nil;
    }
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    if ([self.wx_UIDelegate respondsToSelector:@selector(webView:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:)]) {
        [self.wx_UIDelegate webView:webView runJavaScriptAlertPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
    }else {
//        MttAlertController *alert = [ MttAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//        __weak MttAlertController *weakAC = alert;
//        alert.naBlock = completionHandler;
//
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            weakAC.naBlock = nil;
//            if (completionHandler) {
//                completionHandler();
//            }
//        }];
//        [alert addAction:action];
//        [[VCManager getTopVC] presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - WKNavigationDelegate

- (NSArray *)whiteAppSchemas
{
    return @[@"tmall", @"xiaosouti", @"monkeyoral", @"xes1v1", @"mqqwpa", @"snssdk1128"];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest *request = navigationAction.request;
    NSString *scheme = request.URL.scheme;
    
    if ([scheme isEqualToString:kAppScheme]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplicationOpenURL" object:nil userInfo:@{@"openURL":request.URL.absoluteString}];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [JumpUrlHandle jumpWithUrlString:[request.URL absoluteString] extraParams:nil];
        });
        decisionHandler(WKNavigationActionPolicyCancel);
        
        
    }else if (scheme && [[self whiteAppSchemas] containsObject:scheme]) {
        
        if ([[UIApplication sharedApplication] canOpenURL:request.URL]){
            [[UIApplication sharedApplication] openURL:request.URL];
            decisionHandler(WKNavigationActionPolicyCancel);
        }else {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
        
    }else if ([[request.URL absoluteString] rangeOfString:@"apple.com"].location != NSNotFound) {
        
        BOOL status = [[UIApplication sharedApplication] openURL:request.URL];
        decisionHandler(status?WKNavigationActionPolicyCancel:WKNavigationActionPolicyAllow);
        
    }else if ([request.URL.scheme isEqualToString:@"tel"]) {
        
        if ([[UIApplication sharedApplication] canOpenURL:request.URL]){
            [[UIApplication sharedApplication] openURL:request.URL];
            decisionHandler(WKNavigationActionPolicyCancel);
        }else {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
        
    }else if (!self.ignoreWhiteHostList && ![self containWhiteHost:request.URL]) {
        decisionHandler(WKNavigationActionPolicyCancel);
//        [WXLog sys:@"webview_illegal_url" label:@"域名不在白名单内" attachmentDic:@{
//            @"param_one" : request.URL.absoluteString ?: @"",
//        }];
        if ([self.wx_navigationDelegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
            [self.wx_navigationDelegate webView:webView didFailProvisionalNavigation:nil withError:[NSError errorWithDomain:@"WXWebView" code:-34356 userInfo:@{NSLocalizedDescriptionKey:@"当前网页不受信任"}]];
        }
    }else {
        
        if ([self.wx_navigationDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
            [self.wx_navigationDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
        }else {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {

    NSURL *url = [NSURL URLWithString:[error.userInfo wx_stringForKey:NSErrorFailingURLStringKey]];
    if ([url.absoluteString containsString:@"mailto:"] ||
        [url.absoluteString containsString:@"tel:"] ||
        [url.absoluteString containsString:@"telprompt:"] ||
        [url.absoluteString containsString:@"sms:"]) {
        [[UIApplication sharedApplication] openURL:url];
    }else if ([self containWhiteHost:webView.URL] && [self.wx_navigationDelegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        if(error.code >= -1206 && error.code <= -1200) {
          NSError *newError = [NSError errorWithDomain:error.domain code:error.code userInfo:@{NSLocalizedDescriptionKey:@"当前网页不受信任"}];
            error = newError;
        }
        else if(error.code == 105)
        {
            [self showReloadView];
        }
        else 
        {
            NSError *newError = [NSError errorWithDomain:error.domain code:error.code userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"加载失败（%ld）",(long)error.code]}];
              error = newError;
        }
        
        if(error.code != 105){
            [self.wx_navigationDelegate webView:webView didFailProvisionalNavigation:navigation withError:error];
        }
    }
}

- (void)showReloadView {
    @WeakObj(self)
    UIColor *color = self.backgroundColor;
    self.backgroundColor = [UIColor whiteColor];
    AZReloadView *reloadView = [[AZReloadView alloc]init];
    reloadView.reloadBlock = ^ {
        selfWeak.backgroundColor = color;
        [selfWeak loadRequest:[NSURLRequest requestWithURL:selfWeak.URL]];
    };
        
    [self addSubview:reloadView];
    [reloadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-30);
    }];
}

@end


@implementation AZReloadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    UIButton *myBtnD = [UIButton buttonWithType:UIButtonTypeCustom];
    [myBtnD setTitle:@"刷新页面" forState:UIControlStateNormal];
    myBtnD.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [myBtnD setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [myBtnD addTarget:self action:@selector(reloadRequest) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:myBtnD];
    [myBtnD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(self);
    }];
    
    UILabel *mylabelD = [[UILabel alloc]init];
    mylabelD.text = @"点击上方允许网站，5秒后再点击刷新页面";
    mylabelD.textColor = [UIColor wx_colorWithHEXValue:0x999999];
    mylabelD.font = [UIFont systemFontOfSize:16.0f];
    [self addSubview:mylabelD];
    [mylabelD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(myBtnD.mas_top).offset(-5);
        make.top.left.and.right.equalTo(self);
    }];
}


- (void)reloadRequest {
    
    [self removeFromSuperview];
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

- (void)dealloc {
   
}

@end


