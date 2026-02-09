//
//  WKUserContentController+TALJSBridge.h
//  Pods
//
//  Created by leev on 2020/11/5.
//

#import <WebKit/WebKit.h>


@protocol TScriptMessageHandler <WKScriptMessageHandler>

@required

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@optional

// SDK内部即将相应对应message时回调该方法
- (void)userContentController:(WKUserContentController *)userContentController SDKWillRespondScriptMessage:(WKScriptMessage *)message;

// SDK内部处理完message时回调该方法
- (void)userContentController:(WKUserContentController *)userContentController SDKDidHandleScriptMessage:(WKScriptMessage *)message;

// 目前只有SDK触发白名单安全机制时会回调该方法
- (void)userContentController:(WKUserContentController *)userContentController SDKUnableRespondScriptMessage:(WKScriptMessage *)message error:(NSError *)error;


@end

@interface WKUserContentController (TJSBridge)

/// 通过分类实现ScriptMessageHandler
/// @param scriptMessageHandler 具体的消息接受对象
/// @param name 消息名称
/// @param nativeObj 实际的原生实现对象
- (void)addScriptMessageHandler:(id <TScriptMessageHandler>)scriptMessageHandler name:(NSString *)name nativeObj:(id)nativeObj;

@end
