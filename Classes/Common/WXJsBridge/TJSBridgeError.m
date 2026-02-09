//
//  TJSBridgeError.m
//  TALHybrid
//
//  Created by leev on 2020/12/17.
//

#import "TJSBridgeError.h"

@interface TJSBridgeError ()
{
    NSInteger _code;
    NSString *_message;
}
@end

@implementation TJSBridgeError

- (id)initWithErrorCode:(NSInteger)code message:(NSString *)message
{
    self = [super init];
    if (self)
    {
        _code = code;
        _message = message;
    }
    return self;;
}

@end
