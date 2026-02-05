//
//  AZAvatarUnityZipDownloadTaskQueue.m
//  AZCommonBusiness
//
//  Created by leev on 2023/9/9.
//

#import "AZAvatarUnityZipDownloadTaskQueue.h"
#import <WXToolKit/WXToolKit.h>

@interface AZAvatarUnityZipDownloadTaskQueue ()

@property (nonatomic, strong) NSMutableArray *taskArray;

@end

@implementation AZAvatarUnityZipDownloadTaskQueue

#pragma mark - Public Method

+ (instancetype)sharedInstance
{
    static AZAvatarUnityZipDownloadTaskQueue *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AZAvatarUnityZipDownloadTaskQueue alloc] init];
    });
    return instance;
}

- (void)downloadUrls:(NSArray *)urls completionHandler:(AZAvatarUnityZipDownloadCompletionHandler)completionHandler
{
    if (urls.count == 0)
    {
        return;
    }
    // 先移除所有的url
    [self.taskArray removeAllObjects];
    // 去重
    NSSet *tempSet = [NSSet setWithArray:urls];
    [self.taskArray addObjectsFromArray:tempSet.allObjects];
    
    NSInteger count = self.taskArray.count;
    // 已完成的任务数
    __block NSInteger finishCount = 0;
    // 拿到第一个下载任务
    NSString *url = [self.taskArray wx_objectAtIndex:0];
    
    [self downloadWithUrl:url completionHandler:^(NSError *error) {
        // 如果有错误，则直接返回
        if (error)
        {
            if (completionHandler)
            {
                completionHandler(error);
            }
            // 移除掉剩下的任务
            [self.taskArray removeAllObjects];
        }
        else
        {
            finishCount++;
            if (finishCount == count)
            {
                // 下载完毕
                completionHandler(nil);
            }
        }
    }];
}

#pragma mark - Private Method

- (void)downloadWithUrl:(NSString *)url completionHandler:(AZAvatarUnityZipDownloadCompletionHandler)completionHandler
{
    [AZAvatarUnityZipDownloadTask downloadUrl:url completionHandler:^(NSError *error) {
        if (error)
        {
            completionHandler(error);
        }
        else
        {
            completionHandler(nil);
            // 删除当前的任务
            if ([self.taskArray containsObject:url])
            {
                [self.taskArray removeObject:url];
            }
            // 取下一个任务
            if (self.taskArray.count > 0)
            {
                NSString *nextUrl = [self.taskArray firstObject];
                [self downloadWithUrl:nextUrl completionHandler:completionHandler];
            }
        }
    }];
}
                                                           

- (NSString *)getNextTaskUrl:(NSInteger)index
{
    if (index >= self.taskArray.count)
    {
        return nil;
    }
    return [self.taskArray wx_objectAtIndex:index];
}

#pragma mark - Getter

- (NSMutableArray *)taskArray
{
    if (_taskArray == nil)
    {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}

@end
