//
//  WXMediaPlayer.h
//  EpicWXCommonKit
//
//  Created by TAL on 2026/2/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WXMediaPlayerEngineType) {
    
    WXMediaPlayerEngineTypePSIJKPlayer,
    WXMediaPlayerEngineTypeAVPlayer,
};

@protocol WXMediaPlayerDelegate <NSObject>

@end

@interface WXMediaPlayer : NSObject
@property (nonatomic, weak) id<WXMediaPlayerDelegate> delegate;

+(instancetype)playerWithPlayView:(UIView *)playerView
                          playerType:(WXMediaPlayerEngineType)playerType;
- (void)playWithVideoURL:(NSURL *)videoURL;
    
/**
 播放视频
 
 @param  videoURL   视频地址
 @param  bid              业务id。仅ijk播放器生效
 */
- (void)playWithVideoURL:(NSURL *)videoURL bid:(int)bid;


- (void)play;
    
- (void)pause;
    
- (void)stop;
@end

NS_ASSUME_NONNULL_END
