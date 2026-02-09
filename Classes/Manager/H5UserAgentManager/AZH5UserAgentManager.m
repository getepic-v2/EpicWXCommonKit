//
//  AZH5UserAgentManager.m
//  CommonBusinessKit
//
//  Created by leev on 2021/9/9.
//

#import "AZH5UserAgentManager.h"
#import <WebKit/WKWebView.h>

#define kUserAgentCacheKey      @"jzh-UserAgent"
#define kWebViewUASuffixKey     @"xesmathexercise"

@interface AZH5UserAgentManager ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation AZH5UserAgentManager

#pragma mark - Public Method

// 配置h5的UA，该方法主要是获取浏览器UA，然后在该UA后面拼接一些特定标识
+ (void)setupUserAgent
{
    [[self sharedInstance] _setupUserAgent];
}

// 获取h5的UA，该UA是app处理过的UA
+ (NSString *)getUserAgent
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *jzhUserAgent = [userDefaults stringForKey:kUserAgentCacheKey];
    return jzhUserAgent;
}


#pragma mark - Private Method

+ (instancetype)sharedInstance
{
    static AZH5UserAgentManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AZH5UserAgentManager alloc] init];
    });
    return instance;
}

- (void)_setupUserAgent
{
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *appVersionNum = [appVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *userAgent = [AZH5UserAgentManager getUserAgent];
    @try {
        if(userAgent != nil && [userAgent rangeOfString:kWebViewUASuffixKey].location != NSNotFound && [userAgent rangeOfString:@"Version/"].location != NSNotFound)
        {
            // 更新appVersion信息
            
            // 获取旧的追加UA信息
            NSRange oldJoinUserAgentRange = [userAgent rangeOfString:@"Version/"];
            NSString *joinUserAgentOld = [userAgent substringFromIndex:oldJoinUserAgentRange.location];
            
            // 生成新的追加UA信息
            NSString *joinUserAgentNew = [NSString stringWithFormat:@"Version/%@ %@", appVersionNum, kWebViewUASuffixKey];
            
            // 最终新的UA
            userAgent = [userAgent stringByReplacingOccurrencesOfString:joinUserAgentOld withString:joinUserAgentNew];
            
            [self saveUserAgent:userAgent];
        }
        else{
            __weak typeof(self) weakSlef = self;
            _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
#if ENABLE_DEBUG_MOD
            if (@available(iOS 16.4, *)) {
                _webView.inspectable = YES;
            }
#endif
            [_webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                if ([result isKindOfClass:[NSString class]])
                {
                    NSString *userAgentOld = (NSString *)result;
                    NSString *userAgentNew = [userAgentOld stringByAppendingFormat:@" Version/%@ %@" , appVersionNum, kWebViewUASuffixKey];
                    [self saveUserAgent:userAgentNew];
                    // 销毁webview
                    weakSlef.webView = nil;
                }
            }];
        }
    } @catch (NSException *exception) {
        
    }
}

- (void)saveUserAgent:(NSString *)userAgent
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:userAgent, @"UserAgent", nil];
    [userDefaults registerDefaults:dictionnary];
    // 保存UA信息，方便之后快速读取
    [userDefaults setObject:userAgent forKey:kUserAgentCacheKey];
    [userDefaults synchronize];
}

@end
