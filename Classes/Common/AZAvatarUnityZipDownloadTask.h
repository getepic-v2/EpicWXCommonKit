//
//  AZAvatarUnityZipDownloadTask.h
//  AZCommonBusiness
//
//  Created by leev on 2023/7/29.
//
/**
 * @desc 专供人物发型、装扮zip包的下载使用
 */
#import <Foundation/Foundation.h>

typedef void(^AZAvatarUnityZipDownloadCompletionHandler)(NSError *error);

@interface AZAvatarUnityZipDownloadTask : NSObject

+ (void)downloadUrl:(NSString *)url completionHandler:(AZAvatarUnityZipDownloadCompletionHandler)completionHandler;

+ (BOOL)cacheIsExist:(NSString *)taskUrl;


@end
