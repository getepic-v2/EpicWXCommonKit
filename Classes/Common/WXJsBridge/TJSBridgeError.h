//
//  TJSBridgeError.h
//  TALHybrid
//
//  Created by leev on 2020/12/17.
//

#import <Foundation/Foundation.h>

@interface TJSBridgeError : NSObject

/// 失败code
@property (nonatomic, assign, readonly) NSInteger code;

/// 失败message
@property (nonatomic, strong, readonly) NSString *message;

/**
 * @desc 指定初始化方法
 */
- (id)initWithErrorCode:(NSInteger)code message:(NSString *)message;

@end
