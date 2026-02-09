//
//  TJSNativeParam.m
//  TALHybrid
//
//  Created by leev on 2020/12/17.
//

#import "TJSNativeParam.h"

@interface TJSNativeParam ()
{
    id _params;
    THCallBackToJSHandler _callBackHandler;
}
@end

@implementation TJSNativeParam

- (void)dealloc
{
    
}

- (id)initWithParams:(id)params
{
    self = [super init];
    if (self)
    {
        _continueCallBack = NO;
        _params = params;
    }
    return self;
}

- (void)setCallBackHandler:(THCallBackToJSHandler)callBackHandler
{
    if (callBackHandler)
    {
        _callBackHandler = [callBackHandler copy];
    }
}

@end
