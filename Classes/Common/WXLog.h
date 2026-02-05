//
//  WXLog.h
//  EpicUnityAdapter
//
//  Created by TAL on 2026/2/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXLog : NSObject

/**
 * @desc 曝光日志埋点【非页面曝光！！！】
 * @param eventId 埋点id,由日志平台分配
 * @param params 业务信息
 */
+ (void)show:(NSString*)eventId params:(NSDictionary * _Nullable)params;

/**
 * @desc 行为日志埋点
 * @param eventId 埋点id,由日志平台分配
 * @param params 业务信息
 */
+ (void)click:(NSString*)eventId params:(NSDictionary * _Nullable)params;

+ (void)sys:(NSString*)eventId label:(NSString *)label attachmentDic:(NSDictionary*)params;

@end

NS_ASSUME_NONNULL_END
