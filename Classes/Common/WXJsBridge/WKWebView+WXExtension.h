//
//  WKWebView+WXExtension.h
//  CommonBusinessKit
//
//  Created by 唐绍禹 on 2021/8/5.
//

#import <WebKit/WebKit.h>
#import "WKUserContentController+WXExtension.h"
#import "WXJsBridge.h"

@interface WKWebView (WXExtension)
@property (nonatomic, strong) WXJsBridge *jsbridge;

- (BOOL)containWhiteHost:(NSURL *_Nullable)url;

@property (nonatomic, strong) NSArray * _Nullable whiteHostList;

@property (nonatomic, assign) BOOL ignoreWhiteHostList;

@property (nullable, nonatomic, weak) id <WKNavigationDelegate> wx_navigationDelegate;

@property (nullable, nonatomic, weak) id <WKUIDelegate> wx_UIDelegate;

@end

