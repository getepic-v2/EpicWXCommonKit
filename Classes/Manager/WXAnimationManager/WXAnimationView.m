//
//  WXAnimationView.m
//  ParentsCommunity
//
//  Created by tianlong on 2018/7/3.
//  Copyright © 2018年 XES. All rights reserved.
//

#import "WXAnimationView.h"
#import <WXToolKit/WXToolKit.h>
#import <Masonry/Masonry.h>
#import "YYWeakProxy.h"
#import "LOTAssetGroup.h"
#import "LOTAsset.h"
#import "LOTLayerGroup.h"
#import "LOTLayer.h"
#import "WXLottieImageCache.h"
#import <WXToolKit/WXToolKitMacro.h>

#define WXAV_CoverViewAlpha 0.6

@interface WXAnimationView ()

@property (nonatomic, strong) NSDictionary *animationJsonData;

@property (nonatomic, assign) NSInteger playedCount;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic,   copy) void (^completion)(BOOL finished);
@property (nonatomic, assign) BOOL isStop;
/** 应用退到后台或回到前台专用 */
@property (assign, nonatomic) BOOL isPause;
@property (assign, nonatomic) BOOL isBackgroundPause;

@property (copy,   nonatomic) NSString *filePath;
@property (nonatomic, strong) NSDictionary <NSString *, LOTAsset *> *lotAssetDict;
@property (nonatomic, strong) WXLottieImageCache *imageCache;
@property (nonatomic, strong) NSString *cacheKey;
@end

@implementation WXAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        id <LOTImageCache> cache = [LOTCacheProvider imageCache];
        self.imageCache = (WXLottieImageCache *)cache;
        if (!cache || ![cache isKindOfClass:[WXLottieImageCache class]])
        {
            self.imageCache = [[WXLottieImageCache alloc]init];
            [LOTCacheProvider setImageCache:self.imageCache];
        }
        self.startProgress=self.endProgress=NSNotFound;
        self.playedCount = 0;
        // 按层级先后创建容器以及其他子视图
        [self setupBottomView];
        [self setupMiddleView];
        [self setupTopView];
        /*
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:)                                              name:UIApplicationDidBecomeActiveNotification object:nil];
        */
    }
    return self;
}

#pragma mark - 前台后台监听
- (void)appWillResignActive:(NSNotification *)note {
    if (self.isAnimating) {
        self.isBackgroundPause = YES;
        [self stopDisplayLink];
        [self.playView pause];
    }
}

- (void)appDidBecomeActive:(NSNotification *)note {
    if (self.isBackgroundPause) {
        self.isBackgroundPause = NO;
        [self play];
    }
}

- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    [self setBottomView:bottomView];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    [backgroundImageView setHidden:YES];
    [bottomView addSubview:backgroundImageView];
    [self setBackgroundImageView:backgroundImageView];
    
    UIImageView *coverView = [[UIImageView alloc] init];
    [coverView setAlpha:WXAV_CoverViewAlpha];
    [coverView setHidden:YES];
    [coverView setBackgroundColor:[UIColor blackColor]];
    [bottomView addSubview:coverView];
    [self setCoverView:coverView];
}

- (void)setupMiddleView {
    UIView *mid = [[UIView alloc] init];
    [self addSubview:mid];
    [self setMiddleView:mid];
}

- (void)setupTopView {
    UIView *topView = [[UIView alloc] init];
    [self addSubview:topView];
    [self setTopView:topView];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn addTarget:self action:@selector(clickedCloseBtn) forControlEvents:UIControlEventTouchDown];
    btn.hidden = YES;
    [btn setImage:[UIImage imageNamed:@"livevideo_alertview_close_bth_normal"] forState:UIControlStateNormal];
    [topView addSubview:btn];
    [self setCloseBtn:btn];
}

#pragma mark - lazyLoad
- (WXLOTAnimationView *)playView{
    if (!_playView) {
        _playView = [[WXLOTAnimationView alloc] init];
        [self.middleView addSubview:_playView];
        [_playView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.offset(0);
        }];
    }
    return _playView;
}

#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.superview != nil) {
        // 底部
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
        
        // 中间
        [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
        
        // 顶部
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.offset(0);
            make.width.height.offset(50);
        }];
    }
}

- (instancetype)initWithJson:(NSString *)json
                       speed:(CGFloat)speed
                 repeatCount:(NSInteger)repeatCount
                  completion:(void (^)(BOOL finished))completion {
    self = [super init];
    if (self) {
        self.animationJson = json;
        self.speed = speed;
        self.repeatCount = repeatCount;
        self.completion = completion;
        [self configAniamtionWithJson:json speed:speed repeatCount:repeatCount completion:completion];
    }
    return self;
}

/// 播放沙盒动画
/// @param filePath  json全路径 /Document/xxxx/data.json
- (instancetype)initWithFilePath:(NSString *)filePath
                           speed:(CGFloat)speed
                     repeatCount:(NSInteger)repeatCount
                      completion:(void (^)(BOOL finished))completion {
    self = [super init];
    if (self) {
        self.speed = speed;
        self.repeatCount = repeatCount;
        self.completion = completion;
        self.filePath = filePath;
        if (!_playView) {
            _playView = [WXLOTAnimationView animationWithFilePath:filePath];
            [self.middleView addSubview:_playView];
            [_playView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.right.offset(0);
            }];
        }
        [self.playView setAnimationSpeed:speed];
        [self.playView forceDrawingUpdate];
        [self.playView setLoopAnimation:NO];
        [self.playView logHierarchyKeypaths];
    }
    return self;
}

- (instancetype)initWithJsonData:(NSDictionary *)jsonDic
                           speed:(CGFloat)speed
                     repeatCount:(NSInteger)repeatCount
                      completion:(void (^)(BOOL finished))completion
{
    self = [super init];
    if (self)
    {
        self.animationJsonData = jsonDic;
        self.speed = speed;
        self.repeatCount = repeatCount;
        self.completion = completion;
        [self configAniamtionWithJsonData:jsonDic speed:speed repeatCount:repeatCount completion:completion];
    }
    return self;
}

/// 播放沙盒动画
/// @param filePath  json全路径 /Document/xxxx/data.json
- (instancetype)initWithFilePath:(NSString *)filePath
                           speed:(CGFloat)speed
                     repeatCount:(NSInteger)repeatCount
                  asyncLoadImage:(void (^)(WXAnimationView *animationView))asyncLoadImage
                      completion:(void (^)(BOOL finished))completion
{
    self = [super init];
    if (self) {
        self.speed = speed;
        self.repeatCount = repeatCount;
        self.completion = completion;
        self.filePath = filePath;
        self.cacheKey = filePath;
        LOTComposition *comp = [LOTComposition animationWithFilePath:filePath];
        [self fixWithComp:comp speed:speed useAsync:YES asyncLoadImage:asyncLoadImage];
    }
    return self;
}

- (void)fixWithComp:(LOTComposition *)comp
              speed:(CGFloat)speed
           useAsync:(BOOL) useAsync
     asyncLoadImage:(void (^)(WXAnimationView *ani))asyncLoadImage
{
    if (useAsync)
    {
        [self configAnimationWithComp:comp speed:speed asyncLoadImage:asyncLoadImage];
    }
    else
    {
        [self configAnimationWithComp:comp speed:speed asyncLoadImage:nil];
        if (asyncLoadImage)
        {
            asyncLoadImage(self);
        }
    }
}

#pragma mark - 播放动画核心代码

-(void)configAnimationWithComp:(LOTComposition *)comp
                         speed:(CGFloat)speed
                asyncLoadImage:(void (^)(WXAnimationView *ani))asyncLoadImage

{
    [self getImageAssetWithLayer:comp.layerGroup.layers group:comp.assetGroup];
    __weak typeof(self) selfWeak = self;
    void (^setupAnimationViewBlock)(void) = ^{
        selfWeak.playView = [[WXLOTAnimationView alloc]initWithModel:comp inBundle:nil];
        [selfWeak.middleView addSubview:selfWeak.playView];
        [selfWeak.playView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.offset(0);
        }];
        [selfWeak.playView setAnimationSpeed:speed];
        [selfWeak.playView forceDrawingUpdate];
        [selfWeak.playView setLoopAnimation:NO];
        [selfWeak.playView logHierarchyKeypaths];
    };
    
    if (asyncLoadImage)
    {
        [selfWeak.imageCache loadImageWithModel:comp lottieJsonKey:self.cacheKey completion:^(BOOL success) {
            setupAnimationViewBlock();
            asyncLoadImage(self);
        }];
    }
    else
    {
        setupAnimationViewBlock();
    }
}


- (void)configAniamtionWithJson:(NSString *)json
               speed:(CGFloat)speed
         repeatCount:(NSInteger)repeatCount
          completion:(void (^)(BOOL finished))completion {
    [self.playView setAnimationNamed:self.animationJson];
    [self.playView setAnimationSpeed:speed];
    [self.playView forceDrawingUpdate];
    [self.playView setLoopAnimation:NO];
    [self.playView logHierarchyKeypaths];
}

- (void)configAniamtionWithJsonData:(NSDictionary *)jsonDic
                              speed:(CGFloat)speed
                        repeatCount:(NSInteger)repeatCount
                         completion:(void (^)(BOOL finished))completion
{
    [self.playView setAnimationFromJSON:jsonDic];
    [self.playView setAnimationSpeed:speed];
    [self.playView forceDrawingUpdate];
    [self.playView setLoopAnimation:NO];
    [self.playView logHierarchyKeypaths];
}

- (void)animationLoopWithRepeatCount:(NSInteger)repeatCount success:(BOOL)success completion:(void (^)(BOOL finished))completion{
    
    [self stopDisplayLink];
    
    if (self.isStop) {
        return;
    }
    
    __weak typeof(self)selfWeak = self;
    
    if (success)
    {
        if (repeatCount <= 0) {
            if (completion) {
                completion(YES);
            }
        }else if(repeatCount > 0) {
            if (self.playedCount == repeatCount) {
                self.playedCount = 0;
                if (completion) {
                    completion(YES);
                }
                return;
            }
            [self play];
            self.playedCount += 1;
        }
    }
    else
    {
        [self.playView setCompletionBlock:^(BOOL animationFinished) {
            if (selfWeak.isStop) {
                [selfWeak stopDisplayLink];
                return;
            }
            [selfWeak animationLoopWithRepeatCount:repeatCount success:animationFinished completion:completion];
        }];
    }
}

- (void)clickedCloseBtn {
    if (self.clickedCloseBlock) {
        self.clickedCloseBlock();
    }
}

- (void)play{
    @WeakObj(self);
    self.isAnimating    = YES;
    self.isStop         = NO;
    self.isPause        = NO;
    if (self.startFrame && self.endFrame)
    {
        [self.playView playFromFrame:self.startFrame toFrame:self.endFrame withCompletion:^(BOOL animationFinished) {
            [selfWeak animationLoopWithRepeatCount:selfWeak.repeatCount success:animationFinished completion:selfWeak.completion];
        }];
    }
    else if (self.startProgress != NSNotFound && self.endProgress != NSNotFound)
    {
        [self.playView playFromProgress:self.startProgress toProgress:self.endProgress withCompletion:^(BOOL animationFinished) {
            [selfWeak animationLoopWithRepeatCount:selfWeak.repeatCount success:animationFinished completion:selfWeak.completion];
        }];
    }
    else
    {
        [self.playView playWithCompletion:^(BOOL animationFinished) {
            [selfWeak animationLoopWithRepeatCount:selfWeak.repeatCount success:animationFinished completion:selfWeak.completion];
        }];
    }
    [self startDisplayLink];
}
- (void)playFromProgress:(CGFloat)fromStartProgress
              toProgress:(CGFloat)toEndProgress{
    self.startProgress = fromStartProgress;
    self.endProgress = toEndProgress;
    [self play];
}
- (void)playFromFrame:(NSNumber *)fromStartFrame toProgress:(NSNumber *)toEndFrame{
    self.startFrame     = fromStartFrame;
    self.endFrame       = toEndFrame;
    [self play];
}

- (void)pause{
    self.isAnimating    = NO;
    self.isStop         = YES;
    self.isPause        = YES;
    self.isBackgroundPause = NO;
    [self stopDisplayLink];
    [self.playView pause];
}

- (void)stop{
    self.isAnimating    = NO;
    self.isStop         = YES;
    self.isPause        = NO;
    self.isBackgroundPause = NO;
    self.playedCount    = 0;
    
    [self stopDisplayLink];
    [self.coverView setHidden:YES];
    [self.backgroundImageView setHidden:YES];
    
    [self.playView stop];
    [self.playView removeFromSuperview];
    self.playView = nil;
}

#pragma mark - 绑定视图到指定路径的图层
- (CGRect)bindingUIView:(UIView *)view
           forKeyPath:(NSString *)keyPath
            imageName:(NSString *)imageName{
    LOTKeypath *keypath = [LOTKeypath keypathWithString:keyPath];
    if (keypath) {
        if (view) {
            [self.playView addSubview:view toKeypathLayer:keypath];
            CGRect frame = [self fetchImageEntityWithImageName:imageName];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left   .offset(frame.origin.x);
                make.top    .offset(frame.origin.y);
                make.width  .offset(frame.size.width);
                make.height .offset(frame.size.height);
            }];
            return frame;
        } else{
            CALayer *layer = [self.playView layerWithKeyPath:keypath];
            [layer removeFromSuperlayer];
        }
    }
    return CGRectZero;
}


- (void)bindingCircleCustomeUIView:(UIView *)view
                        forKeyPath:(NSString *)keyPath
                         imageName:(NSString *)imageName
{
    LOTKeypath *keypath = [LOTKeypath keypathWithString:keyPath];
    if (keypath) {
        if (view) {
            [self.playView addSubview:view toKeypathLayer:keypath];
            CGRect frame = [self fetchImageEntityWithImageName:imageName];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left   .offset(frame.origin.x);
                make.top    .offset(frame.origin.y);
                make.width  .offset(frame.size.width);
                make.height .offset(frame.size.height);
            }];
            view.layer.cornerRadius = frame.size.width/2.0;
            view.layer.masksToBounds = YES;
        }
    }
}



- (CGRect)fetchImageEntityWithImageName:(NSString *)imageName
{
    CGRect rect = CGRectZero;
   
    if (!self.lotAssetDict)
    {
        self.lotAssetDict = [self getImageAssetWithLayer:self.playView.sceneModel.layerGroup.layers group:self.playView.sceneModel.assetGroup];
    }
    
    LOTAsset *asset = [self.lotAssetDict wx_objectForKey:imageName];
    if (asset)
    {
        rect.size.width = [asset.assetWidth floatValue];
        rect.size.height = [asset.assetHeight floatValue];
    }

    return rect;
}

//递归获取所有图片资源
- (NSDictionary *)getImageAssetWithLayer:(NSArray *)layers group:(LOTAssetGroup *)assetGroup
{
    NSMutableDictionary *assetLayerDict = [NSMutableDictionary dictionary];
    for (LOTLayer *layer in layers)
     {
        if (layer.layerType == LOTLayerTypeImage)
        {
            [assetLayerDict wx_setObject:layer.imageAsset forKey:layer.imageAsset.imageName];
        }
        else if(layer.layerType == LOTLayerTypePrecomp)
        {
            LOTAsset *asset = [assetGroup assetModelForID:layer.referenceID];
            NSDictionary *newAssetDict = [self getImageAssetWithLayer:asset.layerGroup.layers group:assetGroup];
            [assetLayerDict addEntriesFromDictionary:newAssetDict];
        }
     }
    return assetLayerDict;
 }


#pragma mark - 通过json获取动画layer层的数组
- (NSDictionary *)getAnimationInfoWithJsonName:(NSString *)jsonName {
    NSError *error;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    if (@available(iOS 9.0, *)) {
        if (!jsonData) {
            jsonData = [[NSDataAsset alloc] initWithName:jsonName].data;
        }
    }
    NSDictionary *jsonObject = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData
                                                                          options:0 error:&error] : nil;
    return jsonObject;
}

#pragma mark - 动画播放过程中实时调用
- (void)startDisplayLink{
    if (self.delegate) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self]
                                                       selector:@selector(handleDisplayLink:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSDefaultRunLoopMode];
    }
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink{
    
    if (self.isStop) {
        [self stopDisplayLink];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(animationViewDidPlay:)]) {
        [self.delegate animationViewDidPlay:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(animationViewDidPlay:jsonName:)]) {
        [self.delegate animationViewDidPlay:self jsonName:self.animationJson];
    }
}

- (void)stopDisplayLink{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark - 转换动画中指定元素的layer的frame到animtionView的layer上
/**
 转换动画中指定元素的layer的frame到animtionView的layer上
 方便添加自定义控件，以及通过动画的实时方法来达到自定义控件与动画中指定元素layer的frame保持一致，从而达到自定义控件与其动画效果一致，并且可以交互。
 @param elementLayer 必须与动画中的图层绑定，例如：与[self.animationView addSubview:elementLayerInView toKeypathLayer:keypath] 这个方法中的keypath绑定
 */
- (CGRect)convertElementLayerFrameToAnimationLayer:(CALayer *)elementLayer{
    [self.playView layoutIfNeeded];
    CGRect convertF = [elementLayer convertRect:elementLayer.frame toLayer:self.playView.layer];
    return convertF;
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    [_imageCache removeImageWithLottieJsonKey:self.cacheKey completion:nil];
    [_playView removeFromSuperview];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@implementation WXLOTAnimationView
- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
