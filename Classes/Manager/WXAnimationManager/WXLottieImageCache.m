//
//  WXLottieImageCache.m
//  CommonBusinessKit
//
//  Created by 蔡永浩 on 2021/7/14.
//

#import "WXLottieImageCache.h"
#import "LOTComposition.h"
#import "LOTLayerGroup.h"
#import "LOTLayer.h"
#import "LOTAsset.h"
#import "LOTAssetGroup.h"
#import "WXCommonMacro.h"

static NSString * const kWXLottieImageCacheRootDir = @"WXLottieImageCacheRootDir";

@interface WXLottieCacheImageInfo: NSObject
@property (nonatomic, strong) NSDictionary *imageCache;
@property (nonatomic, assign) NSInteger repeatCount;
@end

@interface WXLottieImageCache()

@property (nonatomic, strong) NSMutableDictionary *cacheDict;  //全部图片缓存
@property (nonatomic, strong) NSMutableDictionary <NSString * , WXLottieCacheImageInfo*> *jsonImageCache; //基于jsonkey存储的图片缓存
@property (nonatomic) dispatch_queue_t queue;
@end

@implementation WXLottieImageCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheDict = [NSMutableDictionary dictionary];
        self.jsonImageCache = [NSMutableDictionary dictionary];
        self.queue = dispatch_queue_create("com.xueersi.WXLottieImageCache", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)loadImageWithModel:(LOTComposition *)model
             lottieJsonKey:(NSString *)key
                completion:(void(^)(BOOL success))completion;
{
    if (!key || !model.assetGroup)
    {
        //异步主线程调用，block回调放到下一次runloop执行
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(NO);
            }
        });
        return;
    }
    
    dispatch_async(self.queue, ^{
        WXLottieCacheImageInfo *imageInfo = [self.jsonImageCache objectForKey:key];
        if (imageInfo)
        {
            model.rootDirectory = kWXLottieImageCacheRootDir;
            //存在，则引用计数加1即可
            imageInfo.repeatCount++;
            if (completion)
            {
                [self wx_runBlockInMainThreadFastestLoop:^{
                    
                    completion(YES);
                }];
            }
            return;
        }
        
        NSMutableDictionary *imageCache = [NSMutableDictionary dictionary];
        NSArray *layers = [self getImageAssetWithLayer:model.layerGroup.layers group:model.assetGroup].allValues;
        for (LOTAsset *asset in layers)
        {
                UIImage *image = [self _setImageForAsset:asset];
                NSString *imageKey = [self _getImageKeyForAsset:asset];
                if (image && imageKey)
                {
                    [imageCache setObject:image forKey:imageKey];
                }
        }
        
        if (imageCache.count > 0)
        {
            WXLottieCacheImageInfo *info = [[WXLottieCacheImageInfo alloc]init];
            info.imageCache = imageCache;
            info.repeatCount = 1;
            [self.jsonImageCache setObject:info forKey:key];
            [self.cacheDict addEntriesFromDictionary:imageCache];
            model.rootDirectory = kWXLottieImageCacheRootDir;
        }
        else
        {
            model.rootDirectory = nil;
        }
        if (completion)
        {
            [self wx_runBlockInMainThreadFastestLoop:^{
                
                completion(YES);
            }];
        }
    });
}

//递归获取所有图片资源
- (NSDictionary *)getImageAssetWithLayer:(NSArray *)layers group:(LOTAssetGroup *)assetGroup
{
    NSMutableDictionary *assetLayerDict = [NSMutableDictionary dictionary];
    for (LOTLayer *layer in layers)
     {
        if (layer.layerType == LOTLayerTypeImage)
        {
            [assetLayerDict setObject:layer.imageAsset forKey:layer.imageAsset.imageName];
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

- (void)removeImageWithLottieJsonKey:(NSString *)key
                          completion:(void(^)(BOOL success))completion
{

    if (!key) {
        if (completion)
        {
            completion(NO);
        }
        return;
    }
    
    dispatch_async(self.queue, ^{
        WXLottieCacheImageInfo *imageInfo = [self.jsonImageCache objectForKey:key];
        if (!imageInfo)
        {
            if (completion)
            {
                [self wx_runBlockInMainThreadFastestLoop:^{
                    
                    completion(YES);
                }];
            }
            return;
        }
        
        imageInfo.repeatCount--;
        
        if (imageInfo.repeatCount == 0)
        {
            [self.cacheDict removeObjectsForKeys:imageInfo.imageCache.allKeys];
            [self.jsonImageCache removeObjectForKey:key];
        }
        if (completion)
        {
            [self wx_runBlockInMainThreadFastestLoop:^{
                
                completion(YES);
            }];
        }
    });
    
}

- (UIImage *)imageForKey:(NSString *)key
{
   UIImage *image = [self.cacheDict objectForKey:key];
    if (image) {
    }
    return [self.cacheDict objectForKey:key];
}

- (void)lottie_setImage:(UIImage *)image forKey:(NSString *)key
{
    //不实现填入方法
}

- (UIImage *)_setImageForAsset:(LOTAsset *)asset {
   
    UIImage *image;
    if (asset.imageName) {
        if ([asset.imageName hasPrefix:@"data:"]) {
            // Contents look like a data: URL. Ignore asset.imageDirectory and simply load the image directly.
            NSURL *imageUrl = [NSURL URLWithString:asset.imageName];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            image = [UIImage imageWithData:imageData];
        } else if (asset.rootDirectory.length > 0) {
            NSString *rootDirectory  = asset.rootDirectory;
            if (asset.imageDirectory.length > 0) {
                rootDirectory = [rootDirectory stringByAppendingPathComponent:asset.imageDirectory];
            }
            NSString *imagePath = [rootDirectory stringByAppendingPathComponent:asset.imageName];
            image = [UIImage imageWithContentsOfFile:imagePath];
        } else {
          
            NSString *imagePath = [asset.assetBundle pathForResource:asset.imageName ofType:nil];
            image = [UIImage imageWithContentsOfFile:imagePath];
        }
        if (!image)
        {
            image = [UIImage imageNamed:asset.imageName inBundle: asset.assetBundle compatibleWithTraitCollection:nil];
        }
    }
    return image;
}

- (NSString *)_getImageKeyForAsset:(LOTAsset *)asset
{
    NSString *rootDirectory  = kWXLottieImageCacheRootDir;
    if (asset.imageDirectory.length > 0) {
        rootDirectory = [rootDirectory stringByAppendingPathComponent:asset.imageDirectory];
    }
    NSString *imagePath = [rootDirectory stringByAppendingPathComponent:asset.imageName];
    return imagePath;
}

- (void)wx_runBlockInMainThreadFastestLoop:(void(^)(void))runloop
{
    if ([NSThread currentThread].isMainThread)
    {
        if (runloop)
        {
            runloop();
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (runloop)
            {
                runloop();
            }
        });
    }
}


@end

@implementation WXLottieCacheImageInfo

@end
