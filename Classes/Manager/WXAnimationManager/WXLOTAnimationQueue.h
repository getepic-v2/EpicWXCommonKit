//
//  WXLOTAnimationQueue.h
//  WXAppBase
//
//  Created by 蔡永浩 on 2021/12/14.
//

#import <UIKit/UIKit.h>
#import "WXAnimationView.h"

@class WXLOTAnimationQueueConfig;
@interface WXLOTAnimationQueue : NSObject
@property (nonatomic, strong, readonly) WXLOTAnimationQueueConfig *playingConfig;
@property (nonatomic, strong, readonly)NSArray <WXLOTAnimationQueueConfig *> *configArray;

/**
 播放连续动画
 
 @param  configArray   动画json信息
 @param  layout   界面布局  每个动画加载时，都会回调一次，所以有几个config，就会回调几次。注意block循环引用
 @param  completionBlock 所有动画播放完成。 注意block循环引用
 */
- (void)playWithConfigArray:(NSArray <WXLOTAnimationQueueConfig *> *)configArray
                     layout:(void (^)(WXAnimationView *animationView, WXLOTAnimationQueueConfig *config))layout
            completionBlock:(void(^)(BOOL finished))completionBlock;

- (void)play;
- (void)pause;
- (void)stop;

- (WXAnimationView *)curPlayingAnimationView;

@end

@interface WXLOTAnimationQueueConfig : NSObject
@property (nonatomic, strong) NSString* identifier;  //标识
@property (nonatomic, strong) NSString* jsonPath;    //json路径
@property (nonatomic, assign) CGFloat  speed;        //播放速度。默认1倍
@property (nonatomic, assign) NSInteger repeatCount; //重复次数,默认1次
@property (nonatomic, assign) BOOL autoPlay; //默认YES

/**帧率组合 */
@property (nonatomic, strong) NSNumber *startFrame;

@property (nonatomic, strong) NSNumber *endFrame;

/**进度组合 -当帧率和进度都设置时，以帧率为准*/
@property (nonatomic, assign) CGFloat startProgress;

@property (nonatomic, assign) CGFloat endProgress;

@end

