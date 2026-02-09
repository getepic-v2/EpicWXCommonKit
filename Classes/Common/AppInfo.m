//
//  AppInfo.m
//  ParentsCommunity
//
//  Created by leev on 16/9/18.
//  Copyright © 2016年 XES. All rights reserved.
//

#import "AppInfo.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "WXSSKeyChain.h"
#import <sys/sysctl.h>
#import <mach/mach.h>


#import <WXToolKit/WXToolKit.h>


#define kAppUniqueClientId              @"ParentsCommunityAppClientId"
static NSString *appUniqueClientId;

@implementation AppInfo

// 获取设备id，该设备id卸载重装之后不会发生改变
+ (NSString *)clientId
{
    // 如果已经有值，直接return，避免每次都从钥匙串访问
    if (appUniqueClientId.length > 0)
    {
        return appUniqueClientId;
    }
    
    // 先从钥匙串里面取
    NSString *service = [AppInfo bundleid];
    NSString *clientId = [WXSSKeyChain passwordForService:service account:@"clientId"];
    
    // 如果钥匙串取不到则从UserDefaults中取
    if (clientId.length <= 0)
    {
        clientId = [[NSUserDefaults standardUserDefaults] objectForKey:kAppUniqueClientId];
    }
    else
    {
        // 老版本兼容 - 如果clientId已存在，UserDefaults中不存在，则先存储一份
        NSString *tmpClientId = [[NSUserDefaults standardUserDefaults] objectForKey:kAppUniqueClientId];
        if (tmpClientId.length <= 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:clientId forKey:kAppUniqueClientId];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    // 都没有则重新生成clientId
    if (clientId.length <= 0)
    {
        // 如果没有,则生成一个clientId并存入钥匙串
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        NSString *uuid = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        
        // 额外添加当前时间戳并做MD5(纯大写)
        clientId = [[[NSString stringWithFormat:@"%@_%f", uuid, [[NSDate date] timeIntervalSince1970]] wx_md5String] uppercaseString];
        
        // 生成clientId, 并存入钥匙串
        [WXSSKeyChain setPassword:clientId forService:service account:@"clientId"];
        [[NSUserDefaults standardUserDefaults] setObject:clientId forKey:kAppUniqueClientId];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    appUniqueClientId = clientId;
    return appUniqueClientId;
}


// 获取app版本号信息
+ (NSString *)appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

// 获取app名称
+ (NSString *)appName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

// 获取版本号
+ (NSString *)appVersionNumber
{
    NSString *appVersionStr = [self appVersion];
    NSString *appVersionNum = [appVersionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    #if ENABLE_DEBUG_MOD
    if ([WXDebugManager isDebugRunning]) {
        if ([WXDebugManager customAppVersion].length > 0) {
            return [WXDebugManager customAppVersion];
        } else {
            return appVersionNum;
        }
    }
    #endif
    return appVersionNum;
}


// 获取系统版本号信息
+ (NSString *)systemVersion
{
    return [AppInfo systemVersion];
}


// 获取系统信息
+ (NSString *)systemName
{
    return @"iOS";
}
//
//// 获取设备类型 (iPhone iTouch iPad)
//+ (NSString *)deviceModel
//{
//    return [AppInfo deviceModel];
//}


// 获取机器信息(eg:iPad1,2...)
+ (NSString *)machineInfo
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineInfo = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return machineInfo;
}


// 获取bundleid信息
+ (NSString *)bundleid
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

/**
* @desc 获取运营商
*/
+ (NSString *)DeviceMno{
    CTTelephonyNetworkInfo *info = [self telephonyNetworkInfo];
      CTCarrier *carrier = [info subscriberCellularProvider];
      //当前手机所属运营商名称
      NSString *mobile;
      //先判断有没有SIM卡，如果没有则不获取本机运营商(这种情况根据在页面具体分析,可能就是iPad)
      if (!carrier.isoCountryCode)
      {
          mobile = @"no sim card";
      }
      else
      {
          mobile = [carrier carrierName] ? : @"";
      }
      return mobile;
}


/**
* @desc 获取分辨率
*/
+ (NSString *)DeviceResolution{
    
    NSString *resolution = [NSString stringWithFormat:@"%f*%f", [UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width];
    return resolution;
}

/**
* @desc 获取操作语言
*/
+ (NSString *)DeviceLanguage
{
    NSArray *languageArray = [NSLocale preferredLanguages];
    if (languageArray.count > 0)
    {
        return [languageArray firstObject];
    }
    else
    {
        return @"";
    }
}

/**
* @desc 获取当前日期
*/
+ (NSString *)DeviceDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;
}

/**
* @desc 获取手机型号
*/
+ (NSString *)DeviceName{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S"; /*基本没用*/
    
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)"; /*基本很少用*/
    
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString  isEqualToString:@"iPhone9,1"])   return @"iPhone 7";
    if ([deviceString  isEqualToString:@"iPhone9,2"])   return @"iPhone 7 Plus";
    if ([deviceString  isEqualToString:@"iPhone10,1"])  return @"iPhone 8";
    if ([deviceString  isEqualToString:@"iPhone10,4"])  return @"iPhone 8";
    if ([deviceString  isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString  isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString  isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString  isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString  isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceString  isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString  isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceString  isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)"; /*基本没用*/
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])     return @"iPad 5";
    if ([deviceString isEqualToString:@"iPad6,12"])     return @"iPad 5";
    if ([deviceString isEqualToString:@"iPad7,11"])     return @"iPad 6";
    if ([deviceString isEqualToString:@"iPad7,12"])     return @"iPad 6";
    if ([deviceString isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9-inch 2";
    if ([deviceString isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9-inch 2";
    if ([deviceString isEqualToString:@"iPad7,3"])      return @"iPad Pro 10.5-inch";
    if ([deviceString isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5-inch";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}

+ (NSString *)DeviceMemory {
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    return [NSString stringWithFormat:@"%.llu",[NSProcessInfo processInfo].physicalMemory/MB];
}

+ (NSString *)availableMemory {
    double total = [NSProcessInfo processInfo].physicalMemory;
    vm_statistics64_data_t vminfo;
    mach_msg_type_number_t count = HOST_VM_INFO64_COUNT;
    host_statistics64(mach_host_self(), HOST_VM_INFO64, (host_info64_t)&vminfo,&count);
    uint64_t total_used_count = (total / PAGE_SIZE) - (vminfo.free_count - vminfo.speculative_count) - vminfo.external_page_count - vminfo.purgeable_count;
    uint64_t free_size = ((total / PAGE_SIZE) -total_used_count) * PAGE_SIZE;
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    return [NSString stringWithFormat:@"%.llu",free_size/MB];
}

+ (CTTelephonyNetworkInfo *)telephonyNetworkInfo{
    static CTTelephonyNetworkInfo *telephonyInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    });
    return telephonyInfo;
}

// 渠道
+ (NSString*)getChannel
{
    NSString *channelStr = @"appstore";
#if ENABLE_DEBUG_MOD
    channelStr = @"DEBUG";
#endif
    return channelStr;
}


/** 获取具体网络类型 */
+ (NSString *)getNetDetailType
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *netconnType = @"";
    NSString *currentStatus = @"";
    
    if (@available(iOS 12.0, *)) {
        if ([info respondsToSelector:@selector(serviceCurrentRadioAccessTechnology)]) {
            NSDictionary *technologyDict = info.serviceCurrentRadioAccessTechnology;
            if (technologyDict && technologyDict.count > 0) {
                currentStatus = [[technologyDict allValues] firstObject];
            }
        }
    } else {
        currentStatus = info.currentRadioAccessTechnology;
    }
    
    if ([currentStatus isEqualToString:CTRadioAccessTechnologyGPRS]) {
        netconnType = @"GPRS";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyEdge]) {
        netconnType = @"2.75G EDGE";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyWCDMA]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSDPA]){
        netconnType = @"3.5G HSDPA";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSUPA]){
        netconnType = @"3.5G HSUPA";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMA1x]){
        netconnType = @"2G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyeHRPD]){
        netconnType = @"HRPD";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyLTE]){
        netconnType = @"4G";
    }
    return netconnType;
}

@end
