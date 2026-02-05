//
//  WXLottieImageCache.h
//  CommonBusinessKit
//
//  Created by 蔡永浩 on 2021/7/14.
//

#import <Foundation/Foundation.h>
#import "LOTCacheProvider.h"
@class LOTComposition;
@interface WXLottieImageCache : NSObject <LOTImageCache>

- (void)loadImageWithModel:(LOTComposition *)model
             lottieJsonKey:(NSString *)key
                completion:(void(^)(BOOL success))completion;
- (void)removeImageWithLottieJsonKey:(NSString *)key
                          completion:(void(^)(BOOL success))completion;
;

@end

