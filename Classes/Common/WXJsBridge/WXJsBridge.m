//
//  WXJsBridge.m
//  CommonBusinessKit
//
//  Created by 唐绍禹 on 2021/2/25.
//

#import "WXJsBridge.h"
#import "EpicUnityBridge.h"
#import <WXToolKit/WXToolKit.h>
#import "AZAppModuleToUnityMQ.h"

@interface WXJsBridge ()

@property (nonatomic,strong)TJSNativeParam *loginParam;
@property (nonatomic, strong) TJSNativeParam *currentEvaluateParam;

@end

@implementation WXJsBridge

- (instancetype)init {
    if (self = [super init]) {
        _autoReloadAfterLogin = YES;
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logInSuccessful:) name:kUserDidLoginSuccessfulNotification object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resignLogin:) name:kUserDidResignLogInNotification object:nil];
    }
    return self;
}

#pragma mark - 基本信息Api
- (void)deviceInformation:(TJSNativeParam *)param {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSString *appVersionNumber = [AppInfo appVersionNumber];
//    NSString *appVersion = [AppInfo appVersion];
//    NSString *systemVersion = [AppInfo systemVersion];
//    NSString *systemName = [AppInfo systemName];
//    NSString *devicename = [AppInfo machineInfo];
//    NSString *deviceMemory = [AppInfo DeviceMemory];
//    NSString *availableMemory = [AppInfo availableMemory];
//    
//    [dict wx_setObject:appVersion          forKey:@"appVersion"];
//    [dict wx_setObject:appVersionNumber    forKey:@"appVersionNumber"];
//    [dict wx_setObject:systemVersion       forKey:@"systemVersion"];
//    [dict wx_setObject:systemName          forKey:@"systemName"];
//    [dict wx_setObject:devicename          forKey:@"devicename"];
//    [dict wx_setObject:@"7"                forKey:@"device"];
//    [dict wx_setObject:deviceMemory forKey:@"deviceMemory"];
//    [dict wx_setObject:availableMemory forKey:@"availableMemory"];
//    [dict wx_setObject:[AppInfo clientId] forKey:@"identifierForClient"];
//    [dict wx_setObject:(IS_IPAD && [UIScreen isIpadLand] == NO)?@"Pad":@"Phone" forKey:@"deviceType"];
    
    if (param.callBackHandler) {
        param.callBackHandler(dict, nil);
    }
}

- (void)userInformation:(TJSNativeParam *)param {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSString *stuId = [MyUserInfoDefaults sharedDefaults].isAlreadyLogIn ? [MyUserInfoDefaults sharedDefaults].myUserEntity.userId : nil;
//    [dict wx_setObject:stuId forKey:@"stuId"];
    
    if (param.callBackHandler) {
        param.callBackHandler(dict, nil);
    }
}
//
//- (void)deviceAuthorization:(TJSNativeParam *)param {
//    
//    NSInteger type = [[param.params wx_numberForKey:@"type"] integerValue];
//    BOOL needAlert = [param.params wx_boolForKey:@"needAlert" defaultValue:NO];
//    if (type == 207) {
//        //推送通知，单独处理
//        NSInteger hasAuthor = [PrivacyManager pushAuthorityIsEnable] ? 1:2;
//        if (param.callBackHandler) {
//            param.callBackHandler(@{@"status":@(hasAuthor)}, nil);
//        }
//        
//        if (hasAuthor == 2 && needAlert) {
//            [self alertAuthorizationWithTpye:type];
//        }
//        
//        return;
//    }
//    
//    if (type == 204)
//    {
//        //定位权限，单独处理
//        [PrivacyManager requestLocationAuthorization:^(BOOL granted) {
//            if (granted)
//            {
//                if (param.callBackHandler) {
//                    param.callBackHandler(@{@"status":@1}, nil);
//                }
//            }
//            else
//            {
//                if (param.callBackHandler) {
//                    param.callBackHandler(@{@"status":@2}, nil);
//                }
//                if (needAlert) {
//                    [self alertAuthorizationWithTpye:type];
//                }
//            }
//        }];
//    }
//    else if (type == 201)
//    {
//        // 相机
//        [PrivacyManager requestCameraAuthorization:^(BOOL granted) {
//            NSInteger hasAuthor = granted ? 1 : 2;
//            if (!granted)
//            {
//                if (needAlert)
//                {
//                    [self alertAuthorizationWithTpye:type];
//                }
//            }
//            if (param.callBackHandler) {
//                param.callBackHandler(@{@"status":@(hasAuthor)}, nil);
//            }
//        }];
//    }
//    else if (type == 202)
//    {
//        // 麦克风
//        [PrivacyManager requestMicroPhoneAuthorization:^(BOOL granted) {
//            NSInteger hasAuthor = granted ? 1 : 2;
//            if (!granted)
//            {
//                if (needAlert)
//                {
//                    [self alertAuthorizationWithTpye:type];
//                }
//            }
//            if (param.callBackHandler) {
//                param.callBackHandler(@{@"status":@(hasAuthor)}, nil);
//            }
//
//        }];
//    }
//    else if (type == 205)
//    {
//        // 相册
//        [PrivacyManager requestPhotoAuthorization:^(BOOL granted) {
//            NSInteger hasAuthor = granted ? 1 : 2;
//            if (!granted)
//            {
//                if (needAlert)
//                {
//                    [self alertAuthorizationWithTpye:type];
//                }
//            }
//            if (param.callBackHandler) {
//                param.callBackHandler(@{@"status":@(hasAuthor)}, nil);
//            }
//
//        }];
//    }
//    else
//    {
//        if (param.callBackHandler)
//        {
//            [self callBackErrorWithParam:param message:@"参数错误"];
//        }
//    }
//}

//- (void)alertAuthorizationWithTpye:(NSInteger)permissionType {
//    
//    NSString *message,*description;
//    switch (permissionType) {
//        case 201://相机
//            message = @"相机权限被禁用了,无法拍照";
//            description = @"去设置打开相机权限";
//            break;
//        case 202://麦克风
//            message = @"麦克风权限被禁用了,无法获取您的声音";
//            description = @"去设置打开麦克风权限";
//            break;
//        case 204://定位
//            message = @"定位服务未开启，无法获取当前地区";
//            description = @"设置打开定位服务";
//            break;
//        case 205://相册
//            message = @"照片权限被禁用了,无法读取或保存";
//            description = @"去设置打开照片权限";
//            break;
//        case 207://通知
//            message = @"通知权限被禁用了,无法接收通知";
//            description = @"去设置打开通知权限";
//            break;
//    }
//    
//    if (message.length > 0) {
//        [NTAlertView showWithTitle:message
//                       description:description
//                 cancelButtonTitle:@"取消"
//                  otherButtonTitle:@"去设置"
//                          tapBlock:^(NSInteger buttonIndex) {
//                              if (buttonIndex == 1){
//                                  // 跳转设置页面
//                                  NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                                  [[UIApplication sharedApplication] openURL:settingURL];
//                              }
//                          }];
//    }else {
//        [WXToastView showToastWithTitle:@"参数错误"];
//    }
//    
//}
//
//- (void)wechatHasInstall:(TJSNativeParam *)param {
//    BOOL install = [WXApi isWXAppInstalled];
//    if (param.callBackHandler) {
//        param.callBackHandler(@{@"status":@(install?1:0)}, nil);
//    }
//}
//
//- (void)antHasInstall:(TJSNativeParam *)param {
//    BOOL install = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tbopen23086819://"]];
//    if (param.callBackHandler) {
//        param.callBackHandler(@{@"status":@(install?1:0)}, nil);
//    }
//}
//
//- (void)appHasInstall:(TJSNativeParam *)param {
//    NSString *schema = [param.params wx_stringForKey:@"schema"];
//    BOOL install = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:schema]];
//    if (param.callBackHandler) {
//        param.callBackHandler(@{@"status":@(install?1:0)}, nil);
//    }
//}
//
//- (void)netWorkStatus:(TJSNativeParam *)param {
//    NSInteger status = [[WXReachabilityManager sharedInstance] getNetWorkCategory];
//    if (param.callBackHandler) {
//        param.callBackHandler(@{@"status":@(status)}, nil);
//    }
//}
//
//- (void)latitudeAndLongitude:(TJSNativeParam *)param {
//    [[AZLocationManager sharedInstance] getLocationOnceWithCompletion:^(BOOL success, CLLocationDegrees latitude, CLLocationDegrees longitude, NSError *error) {
//        if(error){
//            [self callBackErrorWithParam:param message:error.localizedDescription];
//        }else {
//            NSDictionary *gpsInfo = @{@"latitude" : [NSString stringWithFormat:@"%f", latitude], @"longitude" : [NSString stringWithFormat:@"%f", longitude]};
//            if (param.callBackHandler) {
//                param.callBackHandler(gpsInfo, nil);
//            }
//        }
//    }];
//}
//
//- (void)navigationBarInfo:(TJSNativeParam *)param {
//    if (param.callBackHandler) {
//        CGFloat stautsBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//        param.callBackHandler(@{@"height":@(stautsBarHeight + 44),@"stautsBarHeight":@(stautsBarHeight)}, nil);
//    }
//}
//
//- (void)navigationABCBarInfo:(TJSNativeParam *)param {
//    if (param.callBackHandler) {
//        CGFloat stautsBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//        param.callBackHandler(@{@"height":@(stautsBarHeight + (IS_IPHONE_X ? kIphoneXNaviBarHeight : 0)),@"stautsBarHeight":@(stautsBarHeight)}, nil);
//    }
//}
//
//#pragma mark - 图片相关Api
//- (void)screenShot:(TJSNativeParam *)param {
//    
//    NSInteger mode = [[param.params wx_numberForKey:@"mode"] integerValue];
//    if (self.webView) {
//        UIImage *image = [self.imageManager captureWithScrollView:self.webView];
//        if (image) {
//            [self saveImageWithImage:image name:nil mode:mode completion:param.callBackHandler];
//            
//        }
//    }
//}
//
//- (void)saveImage:(TJSNativeParam *)param {
//    NSString *url = [param.params wx_stringForKey:@"url"];
//    NSString *base64 = [param.params wx_stringForKey:@"base64"];
//    NSString *name = [param.params wx_stringForKey:@"name"];
//    NSInteger mode = [[param.params wx_numberForKey:@"mode"] integerValue];
//    
//    if (url.length > 0) {
//        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            if (image) {
//                [self saveImageWithImage:image name:name mode:mode completion:param.callBackHandler];
//            }else {
//                if (param.callBackHandler) {
//                    TJSBridgeError *error = [[TJSBridgeError alloc] initWithErrorCode:1 message:@"图片下载失败"];
//                    param.callBackHandler(@{@"status":@0}, error);
//                }
//            }
//            
//        }];
//    }else if (base64.length > 0) {
//        NSData *imgData = [[base64 componentsSeparatedByString:@","].lastObject wx_base64DecodeData];
//        UIImage *image = [UIImage imageWithData:imgData];
//        if (image) {
//            [self saveImageWithImage:image name:name mode:mode completion:param.callBackHandler];
//        }else {
//            if (param.callBackHandler) {
//                TJSBridgeError *error = [[TJSBridgeError alloc] initWithErrorCode:1 message:@"图片转码失败"];
//                param.callBackHandler(@{@"status":@0}, error);
//            }
//        }
//    }
//}
//
//- (void)saveImageWithImage:(UIImage *)image name:(NSString *)name mode:(NSInteger)mode completion:(THCallBackToJSHandler)completion {
//    
//    if (image == nil) {
//        return;
//    }
//    
//    if (name == nil) {
//        NSString *timeStr = [self timeStringFromDate:[NSDate date]];
//        name = [NSString stringWithFormat:@"%@_xesApp.png",timeStr];
//    }
//    
//    if (mode == 0) {
//        
//        //保存本地
//        NSString *path = [self.imageManager saveImageToLocationTmepWithImage:image andName:name];
//        if (path.length > 0) {
//            if (completion) {
//                completion(@{@"status":@1,@"path":path}, nil);
//            }
//        }else {
//            if (completion) {
//                TJSBridgeError *error = [[TJSBridgeError alloc] initWithErrorCode:1 message:@"保存失败"];
//                completion(@{@"status":@0}, error);
//            }
//        }
//        
//    }else if (mode == 1) {
//        //保存系统相册
//        [self.imageManager setSaveImageCompletion:^(BOOL success) {
//            if (completion) {
//                if (success) {
//                    completion(@{@"status":@1}, nil);
//                }else {
//                    TJSBridgeError *error = [[TJSBridgeError alloc] initWithErrorCode:1 message:@"保存失败"];
//                    completion(@{@"status":@0}, error);
//                }
//            }
//        }];
//        [self.imageManager saveImageToAlbumWithImage:image];
//    }else {
//        //同时保存系统相册和本地
//        __weak typeof(self) weakSelf = self;
//        [self.imageManager setSaveImageCompletion:^(BOOL success) {
//            if (completion) {
//                if (success) {
//                    //保存本地
//                    NSString *path = [weakSelf.imageManager saveImageToLocationTmepWithImage:image andName:name];
//                    if (path.length > 0) {
//                        if (completion) {
//                            completion(@{@"status":@1,@"path":path}, nil);
//                        }
//                    }else {
//                        if (completion) {
//                            TJSBridgeError *error = [[TJSBridgeError alloc] initWithErrorCode:1 message:@"保存系统相册成功，保存本地失败"];
//                            completion(@{@"status":@1}, error);
//                        }
//                    }
//                }else {
//                    TJSBridgeError *error = [[TJSBridgeError alloc] initWithErrorCode:1 message:@"保存失败"];
//                    completion(@{@"status":@0}, error);
//                }
//            }
//        }];
//        [self.imageManager saveImageToAlbumWithImage:image];
//        
//    }
//}
//
//- (void)previewImage:(TJSNativeParam *)param {
//    NSArray *images = [param.params wx_arrayForKey:@"urls"];
//    NSInteger index = [[param.params wx_numberForKey:@"index" defaultValue:@0] integerValue];
//    NSMutableArray *temp = [NSMutableArray array];
//    for (NSString *url in images) {
//        if (url.length > 0) {
//            WXPhoto *photo = [[WXPhoto alloc] init];
//            photo.photoUrl = url;
//            [temp addObject:photo];
//        }
//    }
//    
//    if (index > temp.count) {
//        index = 0;
//    }
//    
//    if (temp.count > 0) {
//        [WXPhotoBrowser showWithPhotos:temp currentPhotoIndex:index];
//    }
//}
//
//#pragma mark - 测评
////- (void)startEvaluate:(TJSNativeParam *)param {
////    NSString *content = [param.params wx_stringForKey:@"content"];
////    @WeakObj(self);
////    if ([PrivacyManager microPhoneAuthorizationStatus] != WXAuthorizationStatusAllowed) {
////        [PrivacyManager requestMicroPhoneAuthorization:^(BOOL granted) {
////            if(granted){
////                [selfWeak _startEvaluate:param];
////            } else {
////                [NTAlertView showWithTitle:@"请在设置中允许访问麦克风"
////                               description:nil
////                         cancelButtonTitle:@"取消"
////                          otherButtonTitle:@"去设置"
////                                  tapBlock:^(NSInteger buttonIndex) {
////                    if (buttonIndex == 1){
////                        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
////                        [[UIApplication sharedApplication] openURL:settingURL options:@{} completionHandler:nil];
////                    }
////                }];
////                [WXLog info:@"AZUnityChatLog" label:@"无麦克风权限" attachment:nil];
////            }
////        }];
////    } else {
////        [self _startEvaluate:param];
////    }
////}
////
////- (void)_startEvaluate:(TJSNativeParam *)param {
////    NSString *content = [param.params wx_stringForKey:@"content"];
////    NTTTSEvaluationConfig *config = [[NTTTSEvaluationConfig alloc] init];
////    [[NTTTSEvaluationManager shareInstance] setupWithConfig:config];
////    [[NTTTSEvaluationManager shareInstance] startEvaluate:content];
////    [NTTTSEvaluationManager shareInstance].delegate = self;
////    self.currentEvaluateParam = param;
////    
////    NSMutableDictionary *logParam = [NSMutableDictionary new];
////    [logParam wx_setObject:content forKey:@"content"];
////    [WXLog info:@"AZJsBridgeLog" label:@"收到H5测评开始" attachmentDic:logParam];
////}
////
////- (void)stopEvaluate:(TJSNativeParam *)param {
////    [[NTTTSEvaluationManager shareInstance] stopEvaluate];
////    
////    NSMutableDictionary *logParam = [NSMutableDictionary new];
////    [WXLog info:@"AZJsBridgeLog" label:@"收到H5测评结束" attachmentDic:logParam];
////}
//
//#pragma mark - 页面跳转Api
//- (void)openLoginPage:(TJSNativeParam *)param
//{
//    [[AppOrientationManager shareManager] lockWithOrientationMask:UIInterfaceOrientationMaskLandscapeRight];
//    _loginParam = param;
//    _autoReloadAfterLogin = param.params?[param.params wx_numberForKey:@"autoReload" defaultValue:@1].integerValue == 1:YES;
//    [VCManager showSignInVC];
//}
//
//- (void)openSystemSettingsPage {
//    NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//    [[UIApplication sharedApplication] openURL:settingURL];
//}
//
//- (void)openWechatApplet:(TJSNativeParam *)param {
//    NSString *appletId = [param.params wx_stringForKey:@"appletId"];
//    NSString *path = [param.params wx_stringForKey:@"path"];
//    WXMiniProgramType programType = [[param.params wx_numberForKey:@"programType"] integerValue];
//    [WeChatShareManager sendLaunchMiniProgramWithName:appletId path:path miniProgramType:programType completion:nil];
//}
//
//- (void)openWechatScanCodePage {
//    if (![WXApi isWXAppInstalled]) {
//        return;
//    }
//    NSURL *settingURL = [NSURL URLWithString:@"weixin://scanqrcode"];
//    [[UIApplication sharedApplication] openURL:settingURL];
//}
//
//- (void)openWechatCustomerServicePage:(TJSNativeParam *)param
//{
//    if (![WXApi isWXAppInstalled])
//    {
//        return;
//    }
//    
//    NSString *url = [param.params wx_stringForKey:@"url"];
//    NSString *corpid = [param.params wx_stringForKey:@"corpid"];
//
//    WXOpenCustomerServiceReq *req = [WXOpenCustomerServiceReq object];
//    req.url = url;
//    req.corpid = corpid;
//    [WXApi sendReq:req completion:^(BOOL success) {
//        // do nothing
//    }];
//}
//
//- (void)openNativeScheme:(TJSNativeParam *)param {
//    NSString *scheme = [param.params wx_stringForKey:@"scheme"];
//    if (scheme.length > 0) {
//        [JumpUrlHandle jumpWithUrlString:scheme extraParams:nil];
//    }
//}
//
///// 打开支付页面
//- (void)openPaymentPage:(TJSNativeParam *)param
//{
//    NSInteger source = [param.params wx_integerForKey:@"source"];
//    NSDictionary *extendParam = [param.params wx_dictionaryForKey:@"extends" defaultValue:@{}];
//    [[AZVipKTManager shareInstance] ktVip:source extendParam:extendParam];
//}
//
//- (void)openIAPPaymentPage:(TJSNativeParam *)param
//{
//    NSDictionary *orderInfo = [param.params wx_dictionaryForKey:@"tal_cashier_pay_req" defaultValue:@{}];
//    [AZTradeManager payWithOrderInfo:orderInfo completeBlock:^(int status, NSString *failReason) {
//        if (status == 1) {
//            param.callBackHandler(@{@"status" : @(1)}, nil);
//        } else {
//            param.callBackHandler(@{@"status" : @(0), @"error" : (failReason ?: @"")}, nil);
//            [WXLog info:@"AZTradeIAPError" label:@"IAP错误" attachment:failReason];
//        }
//    }];
//}
//
//- (void)openIAPSubscribePage:(TJSNativeParam *)param
//{
//    NSDictionary *orderInfo = [param.params wx_dictionaryForKey:@"tal_cashier_pay_req" defaultValue:@{}];
//    [AZTradeManager subscribeWithOrderInfo:orderInfo completeBlock:^(int status, NSString *failReason) {
//        if (status == 1) {
//            param.callBackHandler(@{@"status" : @(1)}, nil);
//        } else {
//            param.callBackHandler(@{@"status" : @(0), @"error" : (failReason ?: @"")}, nil);
//            [WXLog info:@"AZTradeIAPError" label:@"IAP错误" attachment:failReason];
//        }
//    }];
//}
//
///// 打开app升级弹窗
//- (void)showAppUpdateAlert:(TJSNativeParam *)param
//{
//    [[AppUpdateManager sharedManager] checkVersion];
//}
//
///// 跳转其他App
//- (void)jumpToApp:(TJSNativeParam *)param {
//    //解析入参
//    NSString *appUrlStr = [param.params wx_stringForKey:@"appUrl"];
//    NSString *appStoreUrlStr = [param.params wx_stringForKey:@"appStoreUrl"];
//    BOOL isJumpApp = [param.params wx_boolForKey:@"isJumpApp"];
//    
//    NSMutableDictionary *logParam = [NSMutableDictionary dictionary];
//    [logParam wx_setObject:appUrlStr forKey:@"appUrl"];
//    [logParam wx_setObject:appStoreUrlStr forKey:@"appStoreUrl"];
//    [logParam wx_setObject:@(isJumpApp) forKey:@"isJumpApp"];
//    
//    // 根据 isJumpApp 校验对应参数
//    NSString *targetUrlStr;
//    if (isJumpApp) {
//        // 需跳转应用：校验 appUrl
//        if (appUrlStr.length == 0) {
//            [WXLog info:@"AZJsBridgeLog" label:@"跳转应用失败：isJumpApp为YES时，appUrl不可为空" attachmentDic:logParam];
//            [self callBackErrorWithParam:param message:@"isJumpApp为true时，appUrl参数不能为空"];
//            return;
//        }
//        targetUrlStr = appUrlStr;
//    } else {
//        // 需跳转应用市场：校验 appStoreUrl
//        if (appStoreUrlStr.length == 0) {
//            [WXLog info:@"AZJsBridgeLog" label:@"跳转应用市场失败：isJumpApp为NO时，appStoreUrl不可为空" attachmentDic:logParam];
//            [self callBackErrorWithParam:param message:@"isJumpApp为false时，appStoreUrl参数不能为空"];
//            return;
//        }
//        targetUrlStr = appStoreUrlStr;
//    }
//    
//    // 校验目标URL格式
//    NSURL *targetUrl = [NSURL URLWithString:targetUrlStr];
//    if (!targetUrl) {
//        NSString *errorMsg = isJumpApp ?
//        @"appUrl格式错误（需带://，如abcreading://）" :
//        @"appStoreUrl格式错误（如itms-apps://itunes.apple.com/app/id1338646799）";
//        [WXLog info:@"AZJsBridgeLog" label:[NSString stringWithFormat:@"跳转失败：%@", errorMsg] attachmentDic:logParam];
//        [self callBackErrorWithParam:param message:errorMsg];
//        return;
//    }
//    
//    // 执行跳转
//    UIApplication *app = [UIApplication sharedApplication];
//    [app openURL:targetUrl options:@{} completionHandler:^(BOOL success) {
//        NSString *action = isJumpApp ? @"应用" : @"应用市场";
//        [WXLog info:@"AZJsBridgeLog" label:[NSString stringWithFormat:@"跳转%@%@", action, success ? @"成功" : @"失败"] attachmentDic:logParam];
//        
//        if (param.callBackHandler) {
//            if (success) {
//                param.callBackHandler(@{@"status": @1, @"message": [NSString stringWithFormat:@"已成功跳转至%@", action]}, nil);
//            } else {
//                param.callBackHandler(@{@"status": @0, @"message": [NSString stringWithFormat:@"跳转%@失败", action]}, nil);
//            }
//        }
//    }];
//}
//
//#pragma mark - 弹框提示Api
//- (void)alert:(TJSNativeParam *)param {
//    NSString *message = [param.params wx_stringForKey:@"message"];
//    if (message.length > 0) {
//        [WXToastView showToastWithTitle:message];
//    }
//}
//
//- (void)alertBySystemWithItems:(TJSNativeParam *)param {
//    NSInteger alertType = [[param.params wx_numberForKey:@"alertType"] integerValue];
//    NSString *title = [param.params wx_stringForKey:@"title"];
//    NSString *message = [param.params wx_stringForKey:@"message"];
//    NSArray *items = [param.params wx_arrayForKey:@"items"];
//    
//    if (title.length == 0 && message.length == 0) {
//        return;
//    }
//    
//    if (alertType == 99) {
//        //系统弹框
//        UIAlertController *alertVC;
//        if (items.count > 2) {
//            alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
//            for (NSDictionary *dict in items) {
//                if ([dict isKindOfClass:[NSDictionary class]]) {
//                    NSString *name = [dict wx_stringForKey:@"title"];
//                    NSNumber *index = [dict wx_numberForKey:@"index"];
//                    if (name.length > 0) {
//                        [alertVC addAction:[UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                            if (param.callBackHandler) {
//                                param.callBackHandler(@{@"index":index}, nil);
//                            }
//                        }]];
//                    }
//                }
//            }
//            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                if (param.callBackHandler) {
//                    param.callBackHandler(@{@"index":@(-1)}, nil);
//                }
//            }]];
//            
//        }else if (items.count == 0) {
//            alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//            [alertVC addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                if (param.callBackHandler) {
//                    param.callBackHandler(@{@"index":@0}, nil);
//                }
//            }]];
//        }else {
//            alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//            for (NSDictionary *dict in items) {
//                if ([dict isKindOfClass:[NSDictionary class]]) {
//                    NSString *name = [dict wx_stringForKey:@"title"]?:@"取消";
//                    NSNumber *index = [dict wx_numberForKey:@"index"];
//                    if (name.length > 0) {
//                        [alertVC addAction:[UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                            if (param.callBackHandler) {
//                                param.callBackHandler(@{@"index":index}, nil);
//                            }
//                        }]];
//                    }
//                }
//            }
//        }
//        
//        if (alertVC) {
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
//        }
//        
//    } else {
//        //app全局默认弹框
//        NSString *name0 = [[items wx_objectAtIndex:0] wx_stringForKey:@"title"];
//        NSString *name1 = [[items wx_objectAtIndex:1] wx_stringForKey:@"title"];
//        if (name1 == nil) {
//            [NTAlertView showWithTitle:title description:message cancelButtonTitle:name0?:@"知道了" otherButtonTitle:nil tapBlock:^(NSInteger buttonIndex) {
//                NSNumber *index = [[items wx_objectAtIndex:buttonIndex] wx_numberForKey:@"index"];
//                if (param.callBackHandler) {
//                    param.callBackHandler(@{@"index":index?:@0}, nil);
//                }
//           }];
//        }else {
//            [NTAlertView showWithTitle:title description:message cancelButtonTitle:name0?:@"取消" otherButtonTitle:name1?:@"确定" tapBlock:^(NSInteger buttonIndex) {
//                NSNumber *index = [[items wx_objectAtIndex:buttonIndex] wx_numberForKey:@"index"];
//                if (param.callBackHandler) {
//                    param.callBackHandler(@{@"index":index?:@0}, nil);
//                }
//           }];
//        }
//    }
//}
//
//#pragma mark - 交互型Api
///// 关闭所有H5页面
//- (void)closeWebView {
//    if ([self.delegate respondsToSelector:@selector(webViewClose)]) {
//        [self.delegate webViewClose];
//    }
//}
///// 所有历史页面
//- (void)webViewHistoryList:(TJSNativeParam *)param {
//    if (self.webView) {
//        if(self.webView.backForwardList.backList.count > 0) {
//            NSMutableArray *temp = [NSMutableArray array];
//            for (WKBackForwardListItem *backItem in self.webView.backForwardList.backList) {
//                [temp wx_addObject:backItem.URL.absoluteString];
//            }
//            if (param.callBackHandler) {
//                param.callBackHandler(@{@"history":temp}, nil);
//            }
//        }else {
//            [self callBackErrorWithParam:param message:@"暂无历史页面"];
//        }
//    }else {
//        [self callBackErrorWithParam:param message:@"webview为空"];
//    }
//}
//
///// 返回历史页面
//- (void)goBack:(TJSNativeParam *)param {
//    if ([param.params isKindOfClass:[NSDictionary class]] && [((NSDictionary *)param.params).allKeys containsObject:@"index"]) {
//        NSInteger index = [[param.params wx_numberForKey:@"index"] integerValue];
//        WKBackForwardListItem *backItem = [self.webView.backForwardList.backList wx_objectAtIndex:index];
//        if (backItem) {
//            [self.webView goToBackForwardListItem:backItem];
//        }else {
//            if ([self.delegate respondsToSelector:@selector(webViewGoBack)]) {
//                [self.delegate webViewGoBack];
//            }
//        }
//    }else {
//        if ([self.delegate respondsToSelector:@selector(webViewGoBack)]) {
//            [self.delegate webViewGoBack];
//        }
//    }
//}
//
//- (void)webViewBouncesEnable:(TJSNativeParam *)param {
//    BOOL bounces = [[param.params wx_numberForKey:@"bounces" defaultValue:@1] boolValue];
//    self.webView.scrollView.bounces = bounces;
//}
//
//#pragma mark - 分享Api
//
///// 分享
//- (void)share:(TJSNativeParam *)param {
//    WXJsBridgeShareModel *model = [WXJsBridgeShareModel modelWithJSON:param.params];
//    if (model && [model isKindOfClass:[WXJsBridgeShareModel class]]) {
//        
//        if (model.type < 0 || model.type > 3) {
//            model.type = 1;
//        }
//        
//        model.title = [param.params wx_stringForKey:@"title" defaultValue:[AppInfo appName]];
//        model.describe = [param.params wx_stringForKey:@"describe" defaultValue:self.webView.title?:@""];
//        model.shareURL = [param.params wx_stringForKey:@"shareURL" defaultValue:self.webView.URL.absoluteString?:@""];
//        model.scence = [[param.params wx_numberForKey:@"scence" defaultValue:@32] integerValue];
//        
//        [self.shareManager shareWithModel:model andParam:param];
//    }
//}
//
//#pragma mark - 获取本次打开webview请求相关的参数
///// 获取本次打开webview请求相关的参数
//- (void)getWebviewRequestParam:(TJSNativeParam *)param {
//    if ([self.delegate respondsToSelector:@selector(getWebviewRequestParam:)]) {
//        [self.delegate getWebviewRequestParam:param];
//    }
//}
//
//#pragma mark - 业务相关
/////获取朋友圈分享的图片资源
//- (void)getMomentsGetBackgroundImage:(TJSNativeParam *)param
//{
//    if(self.delegate && [self.delegate respondsToSelector:@selector(getMomentsGetBackgroundImage:)]){
//        [self.delegate getMomentsGetBackgroundImage:param];
//    }
//}
//
//
//#pragma mark - 私有工具方法
//
//- (NSString *)timeStringFromDate:(NSDate *)date{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSS"];
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
//    return timeSp;
//}
//
//- (void)callBackErrorWithParam:(TJSNativeParam *)param message:(NSString *)message {
//    if (param.callBackHandler) {
//        TJSBridgeError *error = [[TJSBridgeError alloc] initWithErrorCode:-1 message:message];
//        param.callBackHandler(nil, error);
//    }
//}
//
//#pragma mark - 分享面板代理
//- (void)webViewClose {
//    if ([self.delegate respondsToSelector:@selector(webViewClose)]) {
//        [self.delegate webViewClose];
//    }
//}
//
//- (void)webViewRefresh {
//    [self.webView reload];
//}
//
//#pragma mark - 测评代理
////- (void)evaluateDidStart {
////    if (self.currentEvaluateParam) {
////        self.currentEvaluateParam.continueCallBack = YES;
////        self.currentEvaluateParam.callBackHandler(@{@"startSpeech" : @"true"}, nil);
////        
////        NSMutableDictionary *logParam = [NSMutableDictionary new];
////        [WXLog info:@"AZJsBridgeLog" label:@"H5测评开始录音" attachmentDic:logParam];
////    }
////}
////
////- (void)evaluatingWithResponse:(NSString *)resultJson {
////    if (self.currentEvaluateParam) {
////        self.currentEvaluateParam.continueCallBack = YES;
////        NSMutableDictionary *data = [NSMutableDictionary new];
////        [data wx_setObject:resultJson forKey:@"intermediateResult"];
////        self.currentEvaluateParam.callBackHandler(data, nil);
////    }
////}
////
////- (void)evaluateDidEndWithResponse:(NSString *)resultJson {
////    if (self.currentEvaluateParam) {
////        self.currentEvaluateParam.continueCallBack = NO;
////        NSMutableDictionary *data = [NSMutableDictionary new];
////        [data wx_setObject:resultJson forKey:@"result"];
////        self.currentEvaluateParam.callBackHandler(data, nil);
////        self.currentEvaluateParam = nil;
////        
////        NSMutableDictionary *logParam = [NSMutableDictionary new];
////        [logParam wx_setObject:resultJson forKey:@"result"];
////        [WXLog info:@"AZJsBridgeLog" label:@"H5测评返回结果" attachmentDic:logParam];
////    }
////}
////
////- (void)evaluateDidFailedWithError:(NTTTSEvaluationError *)error {
////    if (self.currentEvaluateParam) {
////        self.currentEvaluateParam.callBackHandler(nil, [[TJSBridgeError alloc] initWithErrorCode:error.errorCode message:error.errMsg]);
////        self.currentEvaluateParam = nil;
////        
////        NSMutableDictionary *logParam = [NSMutableDictionary new];
////        [logParam wx_setObject:error.description forKey:@"error"];
////        [WXLog info:@"AZJsBridgeLog" label:@"H5测评返回错误" attachmentDic:logParam];
////    }
////}
//
//#pragma mark - 登录通知
///// 登录成功通知
//- (void)logInSuccessful:(NSNotification *)notifity {
//    [[AppOrientationManager shareManager] unlock];
//    MyUserInfoEntity *userModel = notifity.object;
//    if (_loginParam && _loginParam.callBackHandler)
//    {
//        // 登录成功
//        self.loginParam.callBackHandler(@{@"status":@(1)}, nil);
//        self.loginParam = nil;
//    }
//}
//
///// 取消登录通知
//- (void)resignLogin:(NSNotificationCenter *)notifity {
//    [[AppOrientationManager shareManager] unlock];
//    if (_loginParam && _loginParam.callBackHandler) {
//        _loginParam.callBackHandler(@{@"status":@0}, nil);
//    }
//}

#pragma mark - Unity通信
// 发送消息给Unity
- (void)unityMessageQueue:(TJSNativeParam *)param {
    NSDictionary *params = param.params;
    if(params && [params isKindOfClass:[NSDictionary class]]){
      NSString *key = [params wx_stringForKey:@"key"];
        NSString *messageParams = [params wx_stringForKey:@"params" defaultValue:@""];
        NSDictionary *messageDic;
        if(messageParams){
            messageDic = [messageParams wx_JSONValue];
        }
        
        if(key){
            [[AZAppModuleToUnityMQ shareInstance] addMessageWithKey:key params:@{@"data":messageDic?:@{}}];
        }
    }
}

/// 返回unity页面
- (void)backMod:(TJSNativeParam *)param {
    BOOL backMain = [param.params wx_boolForKey:@"back_main"];
    if(backMain){
        [[EpicUnityBridgeCore sharedInstance] loadSceneWithId:nil];
    }
//    [[VCManager getAppRootVC] popToRootViewControllerAnimated:NO];
}


#pragma mark - 懒加载

-(void)dealloc {
    //只有英语尝试取消，中文诗词课有一边开webview，一边发起测评的场景
//    if ([NTTTSEvaluationManager shareInstance].config.language == NTTTSEvaluationLanguageEnglish) {
//        [[NTTTSEvaluationManager shareInstance] cancelEvaluate];
//    }
//    XESLog(@"%@----dealloc",NSStringFromClass([self class]));
}
@end
