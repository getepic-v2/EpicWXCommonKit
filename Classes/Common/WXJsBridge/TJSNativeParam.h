//
//  TJSNativeParam.h
//  TALHybrid
//
//  Created by leev on 2020/12/17.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "TJSBridgeError.h"

typedef void (^THCallBackToJSHandler)(id result, TJSBridgeError *error);

@interface TJSNativeParam : NSObject

/// js调用native时的入参
@property (nonatomic, strong, readonly) id params;

///  js调用原生之后的回调
@property (nonatomic, copy, readonly) THCallBackToJSHandler callBackHandler;

/// 是否持续回调，default is NO，接入方可以根据场景改变该值，如果在不需要持续回调的场景将该值设置为YES会导致TJSNativeParam对象发生内存泄漏
@property (nonatomic, assign) BOOL continueCallBack;

@end
