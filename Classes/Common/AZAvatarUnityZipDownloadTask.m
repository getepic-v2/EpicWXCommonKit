//
//  AZAvatarUnityZipDownloadTask.m
//  AZCommonBusiness
//
//  Created by leev on 2023/7/29.
//

#import "AZAvatarUnityZipDownloadTask.h"
#import "WXPreloadMgr.h"
#import <WXToolKit/WXToolKit.h>
#import <SSZipArchive/SSZipArchive.h>
#import <NTUnityIn/NTUnityInSDK.h>
@implementation AZAvatarUnityZipDownloadTask

#pragma mark - Public Method

+ (void)downloadUrl:(NSString *)url completionHandler:(AZAvatarUnityZipDownloadCompletionHandler)completionHandler
{
    // zip包的cache路径
    NSString *zipCachePath = [self zipCachePath:url];
    // 解压之后的文件是否存在
    BOOL cacheExist = [self cacheIsExist:url];
    // 先判断是否有缓存
    if (cacheExist)
    {
        if (completionHandler)
        {
            // 直接解压
            BOOL result = [SSZipArchive unzipFileAtPath:zipCachePath toDestination:[self unZipDestinationPath:url]];
            if (result)
            {
                completionHandler(nil);
            }
            else
            {
                NSError *error = [NSError errorWithDomain:@"UnZipError" code:10032 userInfo:@{NSLocalizedDescriptionKey:@"资源解压失败"}];
                completionHandler(error);
            }
        }
    }
    else
    {
        [[WXPreloadMgr sharedInstance] insertPreloadUrl:url Priority:PreloadPriority_Highest fileSavePath:zipCachePath businessType:0 completionBlock:^(NSInteger responseCode, NSError * _Nullable error) {
            if (completionHandler)
            {
                if (error)
                {
                    // 下载失败
                    completionHandler(error);
                }
                else
                {
                    BOOL result = [SSZipArchive unzipFileAtPath:zipCachePath toDestination:[self unZipDestinationPath:url]];
                    if (result)
                    {
                        completionHandler(nil);
                        // 删除zip包缓存路径
                        [[NSFileManager defaultManager] removeItemAtPath:zipCachePath error:nil];
                    }
                    else
                    {
                        NSError *error = [NSError errorWithDomain:@"UnZipError" code:10032 userInfo:@{NSLocalizedDescriptionKey:@"资源解压失败"}];
                        completionHandler(error);
                    }
                }
            }
        }];
    }
}

+ (BOOL)cacheIsExist:(NSString *)taskUrl
{
    BOOL cacheExist = [[NSFileManager defaultManager] fileExistsAtPath:[self unZipDestinationPath:taskUrl]];
    return cacheExist;
}

#pragma mark - Private Method

// 解压目的路径
+ (NSString *)unZipDestinationPath:(NSString *)taskUrl
{
    NSString *lastPathComponent = [self getLastPathName:taskUrl];
    NSString *unZipFileName = [[lastPathComponent componentsSeparatedByString:@"."] firstObject];
    
    return [NSString stringWithFormat:@"%@/%@/%@", [NTUnityInSDK getSceneResCacheDir], @"unity3dRes", unZipFileName];
}

// 下载路径
+ (NSString *)zipCachePath:(NSString *)taskUrl
{
    NSString *skinDownloadTempPath = [NSString stringWithFormat:@"%@/%@", [NSFileManager wx_documentFilePath], @"AZAvatarZipDownloadTemp"];
    return [NSString stringWithFormat:@"%@/%@", skinDownloadTempPath, [self getLastPathName:taskUrl]];
}


+ (NSString *)getLastPathName:(NSString *)taskUrl
{
    NSURL *url = [NSURL URLWithString:taskUrl];
    return [url lastPathComponent];
}

@end
