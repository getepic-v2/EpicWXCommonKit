//
//  WXAnimationManager.h
//  ParentsCommunity
//
//  Created by tianlong on 2018/7/5.
//  Copyright © 2018年 XES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXAnimationView.h"

@interface WXAnimationManager : NSObject

#pragma mark - 全局调用
/**
 配置动画参数
 @param json 动画json
 @param speed 播放速度
 @param repeatCount 重复次数,默认不重复,只播放一次
 @param identifier 动画唯一标识
 @param layout 外界布局,增加这个block的原因:先调播放,在布局动画不能正常结束
 @param autoPlay 是否自动播放
 @param completion 播放完成回调
 */
+ (void)playWithJson:(NSString *)json
               speed:(CGFloat)speed
         repeatCount:(NSInteger)repeatCount
          identifier:(NSString *)identifier
              layout:(void (^)(WXAnimationView *aniView))layout
            autoPlay:(BOOL)autoPlay
          completion:(void (^)(BOOL finished))completion;

/** 全局对象 */
+ (instancetype)defaultManager;
+ (void)playAllAnimations;
+ (void)playWithIdentifier:(NSString *)identifier;
+ (void)pauseAllAnimations;
+ (void)pauseWithIdentifier:(NSString *)identifier;

/**
 移除所有动画（比较暴力，不建议使用）
 * 特别说明：防止移除其他业务的动画，建议使用stopAniamtionWithIdentifier进行动画的移除操作
 */
+ (void)stopAllAnimations;
+ (void)stopAniamtionWithIdentifier:(NSString *)identifier;

/** 通过唯一标示获取标识对应的动画视图 */
+ (WXAnimationView *)getAnimationByIdentifier:(NSString *)identifier;


#pragma mark - 自管理，随心所欲，想怎么用就怎么用
/** 特别声明：自管理不能使用类方法，必须创建实例对象调用对象方法 */
- (void)playWithJson:(NSString *)json
               speed:(CGFloat)speed
         repeatCount:(NSInteger)repeatCount
          identifier:(NSString *)identifier
              layout:(void (^)(WXAnimationView *aniView))layout
            autoPlay:(BOOL)autoPlay
          completion:(void (^)(BOOL finished))completion;

/// 播放沙盒中动画
/// @param filePath  json文件全路径：/Docoument/xxx/data.json
- (void)playWithFilePath:(NSString *)filePath
                   speed:(CGFloat)speed
             repeatCount:(NSInteger)repeatCount
              identifier:(NSString *)identifier
                  layout:(void (^)(WXAnimationView *aniView))layout
                autoPlay:(BOOL)autoPlay
              completion:(void (^)(BOOL finished))completion;

/// 播放动画(异步加载图片)
/// @param filePath  json文件全路径：/Docoument/xxx/data.json
- (void)asyncPlayWithJson:(NSString *)json
                   speed:(CGFloat)speed
             repeatCount:(NSInteger)repeatCount
              identifier:(NSString *)identifier
                  layout:(void (^)(WXAnimationView *aniView))layout
                autoPlay:(BOOL)autoPlay
              completion:(void (^)(BOOL finished))completion;


/// 播放沙盒中动画(异步加载图片)
/// @param filePath  json文件全路径：/Docoument/xxx/data.json
- (void)asyncPlayWithFilePath:(NSString *)filePath
                   speed:(CGFloat)speed
             repeatCount:(NSInteger)repeatCount
              identifier:(NSString *)identifier
                  layout:(void (^)(WXAnimationView *aniView))layout
                autoPlay:(BOOL)autoPlay
              completion:(void (^)(BOOL finished))completion;


/**
 * @desc 支持直接传入jsonData执行lottie动画
 */
- (void)playWithJsonData:(NSDictionary *)jsonDic
                   speed:(CGFloat)speed
             repeatCount:(NSInteger)repeatCount
              identifier:(NSString *)identifier
                  layout:(void (^)(WXAnimationView *aniView))layout
                autoPlay:(BOOL)autoPlay
              completion:(void (^)(BOOL finished))completion;

/**
 lottie动画 自定义播放时间点 0-1

 @param json lottie资源
 @param speed 速度 没有特殊要求 1
 @param repeatCount 0 不重复播放 intmax无限播放
 @param identifier 和json参数保持一致
 @param fromStartProgress 起始点
 @param toEndProgress 结束点
 @param layout 布局
 @param autoPlay 是否自行播放
 @param completion 完成回调
 */
- (void)playWithJson:(NSString *)json
               speed:(CGFloat)speed
         repeatCount:(NSInteger)repeatCount
          identifier:(NSString *)identifier
    fromProgress:(CGFloat)fromStartProgress
          toProgress:(CGFloat)toEndProgress
              layout:(void (^)(WXAnimationView *aniView))layout
            autoPlay:(BOOL)autoPlay
          completion:(void (^)(BOOL finished))completion;


/**
 lottie动画 自定义帧到帧的动效

 @param json lottie资源名称
 @param speed 默认1
 @param repeatCount 是否重复
 @param identifier 和json参数保持一致
 @param fromStartFrame 起始帧
 @param toEndFrame 结束帧
 @param layout 布局
 @param autoPlay 是否自动播放
 @param completion 结束回调
 */
- (void)playWithJson:(NSString *)json
               speed:(CGFloat)speed
         repeatCount:(NSInteger)repeatCount
          identifier:(NSString *)identifier
           fromFrame:(nonnull NSNumber *)fromStartFrame
             toFrame:(nonnull NSNumber *)toEndFrame
              layout:(void (^)(WXAnimationView *aniView))layout
            autoPlay:(BOOL)autoPlay
          completion:(void (^)(BOOL finished))completion;


- (void)playAllAnimations;
- (void)playWithIdentifier:(NSString *)identifier;
- (void)pauseAllAnimations;
- (void)pauseWithIdentifier:(NSString *)identifier;
- (void)stopAllAnimations;
- (void)stopAniamtionWithIdentifier:(NSString *)identifier;
- (WXAnimationView *)getAnimationByIdentifier:(NSString *)identifier;

@end
