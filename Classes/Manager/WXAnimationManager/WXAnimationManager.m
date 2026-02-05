//
//  WXAnimationManager.m
//  ParentsCommunity
//
//  Created by tianlong on 2018/7/5.
//  Copyright © 2018年 XES. All rights reserved.
//

#import "WXAnimationManager.h"
#import <WXToolKit/WXToolKitMacro.h>

#define AniamtionManager [WXAnimationManager defaultManager]

@interface WXAnimationManager ()
@property (nonatomic, strong) NSMutableArray *animates;
@end

@implementation WXAnimationManager

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - 全局管理
static WXAnimationManager *_instance;
+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[WXAnimationManager alloc] init];
        }
    });
    return _instance;
}

/*
+(instancetype)defaultManager {return [[self alloc]init];}
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}
-(instancetype)copyWithZone:(NSZone *)zone {return _instance;}
-(instancetype)mutableCopyWithZone:(NSZone *)zone {return _instance;}
*/

+ (void)playWithJson:(NSString *)json
              speed:(CGFloat)speed
        repeatCount:(NSInteger)repeatCount
         identifier:(NSString *)identifier
             layout:(void (^)(WXAnimationView *aniView))layout
           autoPlay:(BOOL)autoPlay
         completion:(void (^)(BOOL finished))completion; {
    [AniamtionManager playWithJson:json speed:speed repeatCount:repeatCount identifier:identifier layout:layout autoPlay:autoPlay completion:completion];
}

+ (WXAnimationView *)getAnimationByIdentifier:(NSString *)identifier {
    return [AniamtionManager getAnimationByIdentifier:identifier];
}

+ (void)playAllAnimations {
    [AniamtionManager playAllAnimations];
}
+ (void)playWithIdentifier:(NSString *)identifier {
    [AniamtionManager playWithIdentifier:identifier];
}

+ (void)pauseAllAnimations {
    [AniamtionManager pauseAllAnimations];
}
+ (void)pauseWithIdentifier:(NSString *)identifier {
    [AniamtionManager pauseWithIdentifier:identifier];
}

+ (void)stopAniamtionWithIdentifier:(NSString *)identifier {
    [AniamtionManager stopAniamtionWithIdentifier:identifier];
}
+ (void)stopAllAnimations {
    [AniamtionManager stopAllAnimations];
}


#pragma mark - 自管理，实例方法
- (void)playWithJson:(NSString *)json
              speed:(CGFloat)speed
        repeatCount:(NSInteger)repeatCount
         identifier:(NSString *)identifier
             layout:(void (^)(WXAnimationView *aniView))layout
           autoPlay:(BOOL)autoPlay
         completion:(void (^)(BOOL finished))completion; {
    if(json==nil||[json isEqualToString:@""]) {
        XESLog(@"lot -- 动画json为空！！！！");
        return;
    }
    // 先布局动画才能正常结束
    if (layout) {
        WXAnimationView *ani = [[WXAnimationView alloc] initWithJson:json speed:speed repeatCount:repeatCount completion:completion];
        ani.identifier = identifier;
        layout(ani);
        [self.animates addObject:ani];
        if (autoPlay) {
            [ani play];
        }
    }
}

- (void)playWithFilePath:(NSString *)filePath
               speed:(CGFloat)speed
         repeatCount:(NSInteger)repeatCount
          identifier:(NSString *)identifier
              layout:(void (^)(WXAnimationView *aniView))layout
            autoPlay:(BOOL)autoPlay
              completion:(void (^)(BOOL finished))completion {
    if(filePath==nil||[filePath isEqualToString:@""]) {
        XESLog(@"lot -- 动画filePath为空！！！！");
        return;
    }
    // 先布局动画才能正常结束
    if (layout) {
        WXAnimationView *ani = [[WXAnimationView alloc] initWithFilePath:filePath speed:speed repeatCount:repeatCount completion:completion];
        ani.identifier = identifier;
        layout(ani);
        [self.animates addObject:ani];
        if (autoPlay) {
            [ani play];
        }
    }
}

/// 播放动画(异步加载图片)
/// @param filePath  json文件全路径：/Docoument/xxx/data.json
- (void)asyncPlayWithJson:(NSString *)json
                   speed:(CGFloat)speed
             repeatCount:(NSInteger)repeatCount
              identifier:(NSString *)identifier
                  layout:(void (^)(WXAnimationView *aniView))layout
                autoPlay:(BOOL)autoPlay
              completion:(void (^)(BOOL finished))completion
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:json ofType:@"json"];
    if(filePath==nil||[filePath isEqualToString:@""]) {
        XESLog(@"lot -- 动画filePath为空！！！！");
        if (completion) {
            completion(NO);
        }
        return;
    }
    // 先布局动画才能正常结束
    if (layout) {
        WXAnimationView *ani = [[WXAnimationView alloc] initWithFilePath:filePath speed:speed repeatCount:repeatCount asyncLoadImage:^(WXAnimationView *animationView) {
        
            layout(animationView);
            if (autoPlay) {
                [animationView play];
            }
        } completion:completion];
        ani.identifier = identifier;
        ani.animationJson = json;
        [self.animates addObject:ani];
    }
}

/// 播放沙盒中动画(异步加载图片)
/// @param filePath  json文件全路径：/Docoument/xxx/data.json
- (void)asyncPlayWithFilePath:(NSString *)filePath
                   speed:(CGFloat)speed
             repeatCount:(NSInteger)repeatCount
              identifier:(NSString *)identifier
                  layout:(void (^)(WXAnimationView *aniView))layout
                autoPlay:(BOOL)autoPlay
              completion:(void (^)(BOOL finished))completion
{
    if(filePath==nil||[filePath isEqualToString:@""]) {
        XESLog(@"lot -- 动画filePath为空！！！！");
        if (completion) {
            completion(NO);
        }
        return;
    }
    // 先布局动画才能正常结束
    if (layout) {
        WXAnimationView *ani = [[WXAnimationView alloc] initWithFilePath:filePath speed:speed repeatCount:repeatCount asyncLoadImage:^(WXAnimationView *animationView) {
        
            layout(animationView);
            if (autoPlay) {
                [animationView play];
            }
        } completion:completion];
        ani.identifier = identifier;
        [self.animates addObject:ani];
    }
}


// 支持直接传入jsonData执行lottie动画
- (void)playWithJsonData:(NSDictionary *)jsonDic
                   speed:(CGFloat)speed
             repeatCount:(NSInteger)repeatCount
              identifier:(NSString *)identifier
                  layout:(void (^)(WXAnimationView *aniView))layout
                autoPlay:(BOOL)autoPlay
              completion:(void (^)(BOOL finished))completion
{
    if(!jsonDic) {
        XESLog(@"lot -- 动画Dict为空！！！！");
        return;
    }
    // 先布局动画才能正常结束
    if (layout) {
        WXAnimationView *ani = [[WXAnimationView alloc] initWithJsonData:jsonDic speed:speed repeatCount:repeatCount completion:completion];
        ani.identifier = identifier;
        layout(ani);
        [self.animates addObject:ani];
        if (autoPlay) {
            [ani play];
        }
    }
}

- (void)playWithJson:(NSString *)json
               speed:(CGFloat)speed
         repeatCount:(NSInteger)repeatCount
          identifier:(NSString *)identifier
        fromProgress:(CGFloat)fromStartProgress
          toProgress:(CGFloat)toEndProgress
              layout:(void (^)(WXAnimationView *aniView))layout
            autoPlay:(BOOL)autoPlay
          completion:(void (^)(BOOL finished))completion{
    if(json==nil||[json isEqualToString:@""]) {
        XESLog(@"lot -- 动画json为空！！！！");
        return;
    }
    // 先布局动画才能正常结束
    if (layout) {
        WXAnimationView *ani = [[WXAnimationView alloc] initWithJson:json speed:speed repeatCount:repeatCount completion:completion];
        ani.identifier = identifier;
        layout(ani);
        [self.animates addObject:ani];
        if (autoPlay) {
            [ani playFromProgress:fromStartProgress toProgress:toEndProgress];
        }
    }
}

- (void)playWithJson:(NSString *)json
               speed:(CGFloat)speed
         repeatCount:(NSInteger)repeatCount
          identifier:(NSString *)identifier
           fromFrame:(nonnull NSNumber *)fromStartFrame
             toFrame:(nonnull NSNumber *)toEndFrame
              layout:(void (^)(WXAnimationView *aniView))layout
            autoPlay:(BOOL)autoPlay
          completion:(void (^)(BOOL finished))completion{
    if(json==nil||[json isEqualToString:@""]) {
        XESLog(@"lot -- 动画json为空！！！！");
        return;
    }
    // 先布局动画才能正常结束
    if (layout) {
        WXAnimationView *ani = [[WXAnimationView alloc] initWithJson:json speed:speed repeatCount:repeatCount completion:completion];
        ani.identifier = identifier;
        layout(ani);
        [self.animates addObject:ani];
        if (autoPlay) {
            [ani playFromFrame:fromStartFrame toProgress:toEndFrame];
        }
    }
}
- (WXAnimationView *)getAnimationByIdentifier:(NSString *)identifier {
    for (WXAnimationView *obj in self.animates) {
        if ([obj.identifier isEqualToString:identifier]) {
            return obj;
        }
    }
    return nil;
}

- (void)playAllAnimations {
    for (WXAnimationView *obj in self.animates) {
        [obj play];
    }
}

- (void)playWithIdentifier:(NSString *)identifier {
    for (WXAnimationView *obj in self.animates) {
        if ([obj.identifier isEqualToString:identifier]) {
            [obj play];
            break;
        }
    }
}

- (void)pauseAllAnimations {
    for (WXAnimationView *obj in self.animates) {
        [obj pause];
    }
}

- (void)pauseWithIdentifier:(NSString *)identifier {
    for (WXAnimationView *obj in self.animates) {
        if ([obj.identifier isEqualToString:identifier]) {
            [obj pause];
            break;
        }
    }
}

- (void)stopAniamtionWithIdentifier:(NSString *)identifier {
    NSMutableArray *dataM = [NSMutableArray arrayWithArray:self.animates];
    for (WXAnimationView *obj in dataM) {
        if ([obj.identifier isEqualToString:identifier]) {
            [obj stop];
            [self removeSubViewsFromView:obj];
            [obj removeFromSuperview];
            [dataM removeObject:obj];
            XESLog(@"stopAniamtionWithIdentifier===============%@",identifier);
            break;
        }
    }
    self.animates = [NSMutableArray arrayWithArray:dataM];
}

- (void)stopAllAnimations {
    NSMutableArray *dataM = [NSMutableArray arrayWithArray:self.animates];
    for (WXAnimationView *obj in dataM) {
        [obj stop];
        [self removeSubViewsFromView:obj];
        [obj removeFromSuperview];
        XESLog(@"stopAllAnimations===============%@",obj.animationJson);
    }
    self.animates = [NSMutableArray arrayWithArray:dataM];
    [self.animates removeAllObjects];
}


- (void)removeSubViewsFromView:(UIView *)view {
    for (id sub in view.subviews) {
        if ([sub isKindOfClass:[UIView class]]) {
            [(UIView *)sub removeFromSuperview];
        }
    }
}

#pragma mark - lazyLoad
- (NSMutableArray *)animates {
    if (!_animates) {
        _animates = [NSMutableArray array];
    }
    return _animates;
}

@end
