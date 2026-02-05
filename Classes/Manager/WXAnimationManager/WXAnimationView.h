//
//  WXAnimationView.h
//  ParentsCommunity
//
//  Created by tianlong on 2018/7/3.
//  Copyright © 2018年 XES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <lottie-ios/Lottie/Lottie.h>

typedef NS_ENUM(NSInteger, WXAnimationType) {
    WXAnimationTypeDefault,
    WXAnimationTypeAlert,
};

@class WXAnimationView;
@protocol WXAnimationDelegate <NSObject>
@optional
/**
 动画从开始到结束会频繁的调用该方法，1秒60次
 */
- (void)animationViewDidPlay:(WXAnimationView *)animationView;
- (void)animationViewDidPlay:(WXAnimationView *)animationView jsonName:(NSString *)jsonName;
@end

@class WXLOTAnimationView;
@interface WXAnimationView : UIView
@property (nonatomic,   copy) NSString *animationJson;
@property (nonatomic,   copy) void (^clickedCloseBlock)(void);
@property (nonatomic,   weak) UIButton *closeBtn;
@property (nonatomic,   weak) UIImageView *backgroundImageView;
@property (nonatomic,   weak) UIImageView *coverView;

@property (nonatomic,   weak) UIView *bottomView;
@property (nonatomic,   weak) UIView *middleView;
@property (nonatomic,   weak) UIView *topView;

@property (nonatomic,   weak) id<WXAnimationDelegate> delegate;
@property (nonatomic, strong) WXLOTAnimationView *playView;
@property (nonatomic, assign) BOOL isAnimating;
/** 动画标识,如果同时用同一种动画展示不同的内存,这个时候可以通过唯一标识来区分你要找的动画 */
@property (nonatomic,   copy) NSString *identifier;

@property (nonatomic, assign) CGFloat speed; //速度
@property (nonatomic, assign) CGFloat repeatCount; //重复次数

@property (nonatomic, strong) NSNumber *startFrame;

@property (nonatomic, strong) NSNumber *endFrame;

@property (nonatomic, assign) CGFloat startProgress;

@property (nonatomic, assign) CGFloat endProgress;

/**
 @param repeatCount 重复次数，大于等于
 @param json 动画json
 @param speed 播放速度，默认1
 @param completion 完成回调
 */
- (instancetype)initWithJson:(NSString *)json
                       speed:(CGFloat)speed
                 repeatCount:(NSInteger)repeatCount
                  completion:(void (^)(BOOL finished))completion;


/**
 @param jsonDic 动画jsonDic
 @param speed 播放速度，默认1
 @param repeatCount 重复次数，大于等于
 @param completion 完成回调
 */
- (instancetype)initWithJsonData:(NSDictionary *)jsonDic
                           speed:(CGFloat)speed
                     repeatCount:(NSInteger)repeatCount
                      completion:(void (^)(BOOL finished))completion;

/// 播放沙盒动画
/// @param filePath  json全路径 /Document/xxxx/data.json
- (instancetype)initWithFilePath:(NSString *)filePath
                           speed:(CGFloat)speed
                     repeatCount:(NSInteger)repeatCount
                      completion:(void (^)(BOOL finished))completion;


/// 播放动画
/// @param filePath  json全路径 /Document/xxxx/data.json
- (instancetype)initWithFilePath:(NSString *)filePath
                           speed:(CGFloat)speed
                     repeatCount:(NSInteger)repeatCount
                  asyncLoadImage:(void (^)(WXAnimationView *animationView))asyncLoadImage
                      completion:(void (^)(BOOL finished))completion;

- (void)play;
- (void)pause;
- (void)stop;

/**
 自定义播放时间段

 @param fromStartProgress 开始点
 @param toEndProgress 结束点
 */
- (void)playFromProgress:(CGFloat)fromStartProgress
              toProgress:(CGFloat)toEndProgress;


/**
 自定义播放帧

 @param fromStartFrame 开始帧
 @param toEndFrame 结束帧
 */
- (void)playFromFrame:(nonnull NSNumber *)fromStartFrame
              toProgress:(nonnull NSNumber *)toEndFrame;
/**
 绑定视图到动画指定路径的图层上
 */
- (CGRect)bindingUIView:(UIView *)view
           forKeyPath:(NSString *)keyPath
            imageName:(NSString *)imageName;


- (void)bindingCircleCustomeUIView:(UIView *)view
                        forKeyPath:(NSString *)keyPath
                         imageName:(NSString *)imageName;

/**
 通过json获取动画中图层名称的集合
 */
- (NSDictionary *)getAnimationInfoWithJsonName:(NSString *)jsonName;

/**
 转换动画中指定元素的layer的frame到animtionView的layer上
 */
- (CGRect)convertElementLayerFrameToAnimationLayer:(CALayer *)elementLayer;

@end


@interface WXLOTAnimationView : LOTAnimationView
@end

