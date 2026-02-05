//
//  WXLOTAnimationQueueView.m
//  WXAppBase
//
//  Created by 蔡永浩 on 2021/12/14.
//

#import "WXLOTAnimationQueue.h"
#import <WXToolKit/WXToolKitMacro.h>

@interface WXLOTAnimationQueue()
@property (nonatomic, strong, readwrite) WXLOTAnimationQueueConfig *playingConfig;
@property (nonatomic, strong) WXAnimationView *playingAnimationView;
@property (nonatomic, strong) WXAnimationView *lastPlayingAnimationView;
@property (nonatomic, strong) NSMutableArray <WXAnimationView *>*animationViewArray;
@property (nonatomic, copy) void (^layout)(WXAnimationView *animationView, WXLOTAnimationQueueConfig *config);
@property (nonatomic, copy) void (^completionBlock)(BOOL finished);

@end

@implementation WXLOTAnimationQueue

- (instancetype)init
{
    if (self = [super init])
    {
        self.animationViewArray = [NSMutableArray array];
    }
    return self;
}

- (void)playWithConfigArray:(NSArray <WXLOTAnimationQueueConfig *> *)configArray
                     layout:(void (^)(WXAnimationView *animationView, WXLOTAnimationQueueConfig *config))layout
            completionBlock:(void(^)(BOOL finished))completionBlock
{
    if (_playingConfig)
    {
        WXAnimationView *animationView = self.playingAnimationView;
        [animationView stop];
        [animationView removeFromSuperview];
        _playingConfig = nil;
        self.playingAnimationView = nil;
        self.lastPlayingAnimationView = nil;
    }
    _configArray = configArray;
    if (configArray.count > 0)
    {
        self.layout = layout;
        self.completionBlock = completionBlock;
        WXLOTAnimationQueueConfig *config = [_configArray firstObject];
        [self playAnimationViewWithConfig:config layout:layout completionBlock:completionBlock];
    }
    else
    {
        if (completionBlock)
        {
            completionBlock(NO);
        }
    }
}

- (WXAnimationView *)curPlayingAnimationView
{
    return self.playingAnimationView;
}

- (void)play
{
    if (self.playingAnimationView.isAnimating)
    {
        return;
    }
    if(self.playingAnimationView && self.playingConfig)
    {
        [self.playingAnimationView play];
    }
    else
    {
        [self playWithConfigArray:self.configArray layout:self.layout completionBlock:self.completionBlock];
    }
}

- (void)pause
{
    if (!self.playingAnimationView.isAnimating)
    {
        return;
    }
    [self.playingAnimationView pause];
}

- (void)stop
{
    [self.playingAnimationView stop];
    self.playingAnimationView = nil;
    self.playingConfig = nil;
}

- (void)playAnimationViewWithConfig:(WXLOTAnimationQueueConfig *)config
                             layout:(void (^)(WXAnimationView *animationView, WXLOTAnimationQueueConfig *config))layout
                    completionBlock:(void(^)(BOOL finished))completionBlock
{
    self.playingConfig = config;
    @WeakObj(self)
    WXAnimationView *aniView = [[WXAnimationView alloc]initWithFilePath:config.jsonPath speed:config.speed repeatCount:config.repeatCount asyncLoadImage:^(WXAnimationView *animationView) {
        
        if (config.autoPlay) {
            [animationView play];
        }
        if (layout) {
            layout(animationView, config);
        }
        
        //新视图加到界面上再移除旧的
        if (selfWeak.lastPlayingAnimationView)
        {
            [selfWeak.lastPlayingAnimationView stop];
            [selfWeak.lastPlayingAnimationView removeFromSuperview];
            selfWeak.lastPlayingAnimationView = nil;
        }
    } completion:^(BOOL finished) {
       
        NSInteger index = [self.configArray indexOfObject:config];
        
        if (index == self.configArray.count -1)
        {
            if (completionBlock) {
                completionBlock(finished);
            }
        }
        else
        {
            WXLOTAnimationQueueConfig *newConfig = [self.configArray objectAtIndex:index+1];
            [self playAnimationViewWithConfig:newConfig layout:layout completionBlock:completionBlock];
        }
        
    }];
    aniView.identifier = config.identifier;
    aniView.startFrame = config.startFrame;
    aniView.endFrame = config.endFrame;
    aniView.startProgress = config.startProgress;
    aniView.endProgress = config.endProgress;
    self.lastPlayingAnimationView = self.playingAnimationView;
    self.playingAnimationView = aniView;
}

@end

@implementation WXLOTAnimationQueueConfig
-(instancetype)init
{
    if (self=[super init])
    {
        self.speed = 1;
        self.repeatCount = 0;
        self.autoPlay = YES;
        self.startProgress = self.endProgress = NSNotFound;
    }
    return self;
}
@end
