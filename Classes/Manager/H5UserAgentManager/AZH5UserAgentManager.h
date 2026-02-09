//
//  AZH5UserAgentManager.h
//  CommonBusinessKit
//
//  Created by leev on 2021/9/9.
//
/**
 * @desc 主要用于处理webView的UA信息，在webView的UA中追加自定义的信息用于区分app环境
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AZH5UserAgentManager : NSObject

/**
 * @desc 配置h5的UA，该方法主要是获取浏览器UA，然后在该UA后面拼接一些特定标识
 */
+ (void)setupUserAgent;

/**
 * @desc 获取h5的UA，该UA是app处理过的UA
 */
+ (NSString *)getUserAgent;

@end

NS_ASSUME_NONNULL_END
