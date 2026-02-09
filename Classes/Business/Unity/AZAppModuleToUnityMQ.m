//
//  AZAppModuleToUnityMQ.m
//  AZCommonBusiness
//
//  Created by 蔡永浩 on 2023/11/9.
//

#import "AZAppModuleToUnityMQ.h"
#import <WXToolKit/WXToolKit.h>
#import "AZAppModuleToUnityMQ+BusinessPrivate.h"

@interface AZAppModuleToUnityMQ()
@end

@implementation AZAppModuleToUnityMQ

static AZAppModuleToUnityMQ * kModuleToUntiyMQ = nil;


+(instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        kModuleToUntiyMQ = [[AZAppModuleToUnityMQ alloc]init];
    });
    return kModuleToUntiyMQ;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.queque = [NSMutableArray array];
    }
    return self;
}

- (void)addMessageWithKey:(NSString *)key params:(NSDictionary *)params {
    if(key == nil || key.length == 0){
        return;
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    if(!params){
        params = @{};
    }
    [info wx_setObject:params forKey:key];
    [self.queque addObject:info];
}

- (void)clear {
    [self.queque removeAllObjects];
}

@end
