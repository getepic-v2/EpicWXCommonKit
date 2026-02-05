//
//  AZAvatarUnityZipDownloadTaskQueue.h
//  AZCommonBusiness
//
//  Created by leev on 2023/9/9.
//

#import <Foundation/Foundation.h>
#import "AZAvatarUnityZipDownloadTask.h"

@interface AZAvatarUnityZipDownloadTaskQueue : NSObject

+ (instancetype)sharedInstance;

- (void)downloadUrls:(NSArray *)urls completionHandler:(AZAvatarUnityZipDownloadCompletionHandler)completionHandler;

@end
