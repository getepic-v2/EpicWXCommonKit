//
//  WKUserContentController+TALJSBridge.m
//  Pods
//
//  Created by leev on 2020/11/5.
//

#import "WKUserContentController+TALJSBridge.h"
#import "TJSMessageHandler.h"

@implementation WKUserContentController (TJSBridge)

- (void)addScriptMessageHandler:(id<TScriptMessageHandler>)scriptMessageHandler name:(NSString *)name nativeObj:(id)nativeObj
{
    TJSMessageHandler *messageHandler = [[TJSMessageHandler alloc] initWithWKScriptMessageHandler:scriptMessageHandler];
    [messageHandler saveName:name nativeObj:nativeObj];
    
    [self addScriptMessageHandler:messageHandler name:name];
}

@end
