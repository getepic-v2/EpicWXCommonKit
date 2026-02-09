//
//  AZAppModuleToUnityMQ.h
//  AZCommonBusiness
//
//  Created by 蔡永浩 on 2023/11/9.
//
// APP其他模块返回Unity场景时传递消息的队列
// 传递消息只在两个时机
// 1.场景加载成功
// 2.场景由暂停恢复时
// 消息消费后即移除
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AZAppModuleToUnityMQ : NSObject

+(instancetype)shareInstance;

/**
 向队列里添加消息
 
 @param  key   发送给unity时的消息号，如unity.api.open.page
 @param  params   参数
 */
- (void)addMessageWithKey:(NSString *)key params:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
