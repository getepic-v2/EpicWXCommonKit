//
//  AppInfo.h
//  ParentsCommunity
//
//  Created by leev on 16/9/18.
//  Copyright © 2016年 XES. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject

/**
 * @desc 获取设备id，该设备id卸载重装之后不会发生改变
 */
+ (NSString *)clientId;


/**
 * @desc 获取app版本号信息, eg : 3.15.02
 */
+ (NSString *)appVersion;


/**
 * @desc 获取app名称
 */
+ (NSString *)appName;


/**
 * @desc 获取app版本号, eg : 31500
 */
+ (NSString *)appVersionNumber;


/**
 * @desc 获取系统版本号信息
 */
+ (NSString *)systemVersion;


/**
 * @desc 获取系统信息 (iOS)
 */
+ (NSString *)systemName;


/**
 * @desc 获取设备类型 (iPhone iTouch iPad)
 */
+ (NSString *)deviceModel;


/**
 * @desc 获取机器信息(eg:iPad1,2...)
 */
+ (NSString *)machineInfo;


/**
 * @desc 获取bundleid信息
 */
+ (NSString *)bundleid;


/**
 * 获取运营商信息 eg.中国电信
 */
+ (NSString *)DeviceMno;


/**
* @desc 获取分辨率 eg.1792 * 828
*/
+ (NSString *)DeviceResolution;


/**
* @desc 获取操作语言 eg. ZH
*/
+ (NSString *)DeviceLanguage;


/**
* @desc 获取当前日期 格式：2018/3/27 11:41:52
*/
+ (NSString *)DeviceDate;

/**
* @desc 获取手机具体型号(新设备出来,需要更新该函数,目前已经支持到最新版iPhone 11 Max) eg. iPhone 11
*/
+ (NSString *)DeviceName;

/**
* @desc 获取手机运行内存,单位MB
*/
+ (NSString *)DeviceMemory;

/**
* @desc 获取手机当前剩余内存,单位MB
*/
+ (NSString *)availableMemory;

/**
* @desc 获取设备安装渠道
*/
+ (NSString*)getChannel;

/**
* @desc 获取具体网络类型
*/
+ (NSString *)getNetDetailType;

@end
