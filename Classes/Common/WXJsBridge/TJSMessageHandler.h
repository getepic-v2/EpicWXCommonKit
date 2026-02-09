//
//  TJSMessageHandler.h
//  TALHybrid
//
//  Created by leev on 2020/11/5.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "WKUserContentController+TALJSBridge.h"

static NSString * const TALJSBridgeCallBackIdKey = @"callbackid";
static NSString * const TALJSBridgeWebViewKey = @"webview";

@interface TJSMessageHandler : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id<TScriptMessageHandler> messageHandler;

- (id)initWithWKScriptMessageHandler:(id<TScriptMessageHandler>)messageHandler;

- (void)saveName:(NSString *)name nativeObj:(id)nativeObj;

@end
