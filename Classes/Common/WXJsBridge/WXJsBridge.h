//
//  WXJsBridge.h
//  CommonBusinessKit
//
//  Created by 唐绍禹 on 2021/2/25.
//

#import <Foundation/Foundation.h>
#import "TJSBridge.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WXJsBridgeDelegate <NSObject>

- (void)webViewClose;

- (void)webViewGoBack;

- (void)getWebviewRequestParam:(TJSNativeParam *)param;

- (void)getMomentsGetBackgroundImage:(TJSNativeParam *)param;

@end

@interface WXJsBridge : NSObject

@property(nonatomic, weak)WKWebView *webView;

@property(nonatomic, weak) id <WXJsBridgeDelegate>delegate;
/// 登录后是否自动刷新页面 默认YES
@property (nonatomic, assign) BOOL autoReloadAfterLogin;

#pragma mark - 基本信息Api

///获取设备信息
- (void)deviceInformation:(TJSNativeParam *)param;

///获取用户信息
- (void)userInformation:(TJSNativeParam *)param;
//
///// 获取设备权限
//- (void)deviceAuthorization:(TJSNativeParam *)param;
//
///// 设备是否安装微信
//- (void)wechatHasInstall:(TJSNativeParam *)param;
//
///// 设备是否安装支付宝
//- (void)antHasInstall:(TJSNativeParam *)param;
//
///// 设备是否安装某个App，注意，使用前需要在info.plist中配置
//- (void)appHasInstall:(TJSNativeParam *)param;
//
///// 获取网络状态
//- (void)netWorkStatus:(TJSNativeParam *)param;
//
///// 获取经纬度
//- (void)latitudeAndLongitude:(TJSNativeParam *)param;
//
///// 导航栏相关信息
//- (void)navigationBarInfo:(TJSNativeParam *)param;
//
///// ABC导航栏相关信息
//- (void)navigationABCBarInfo:(TJSNativeParam *)param;
//#pragma mark - 图片相关Api
///// 截屏WebView
//- (void)screenShot:(TJSNativeParam *)param;
//
///// 保存图片
//- (void)saveImage:(TJSNativeParam *)param;
//
///// 图片浏览器
//- (void)previewImage:(TJSNativeParam *)param;
//
//#pragma mark - 测评
/////测评开始
//- (void)startEvaluate:(TJSNativeParam *)param;
//
/////测评结束
//- (void)stopEvaluate:(TJSNativeParam *)param;
//
//#pragma mark - TTS
/////tts转语音
//- (void)textToSpeech:(TJSNativeParam *)param;
//- (void)stopTextToSpeech:(TJSNativeParam *)param;
//
//#pragma mark - STT语音转文字
///// 开始语音转文字
//- (void)startSpeechToText:(TJSNativeParam *)param;
///// 停止语音转文字
//- (void)stopSpeechToText:(TJSNativeParam *)param;
///// 取消语音转文字
//- (void)cancelSpeechToText:(TJSNativeParam *)param;
//
//#pragma mark - 页面跳转Api
///// 打开登录页
//- (void)openLoginPage:(TJSNativeParam *)param;
//
///// 打开系统设置页面
//- (void)openSystemSettingsPage;
//
///// 打开微信扫码页面
//- (void)openWechatScanCodePage;
//
///// 打开微信小程序
//- (void)openWechatApplet:(TJSNativeParam *)param;
//
//// 打开微信客服页面
//- (void)openWechatCustomerServicePage:(TJSNativeParam *)param;
//
///// 打开本地scheme
//- (void)openNativeScheme:(TJSNativeParam *)param;
//
///// 打开支付页面
//- (void)openPaymentPage:(TJSNativeParam *)param;
//
///// 打开IAP支付页面
//- (void)openIAPPaymentPage:(TJSNativeParam *)param;
//
///// 打开订阅支付页面
//- (void)openIAPSubscribePage:(TJSNativeParam *)param;
//
///// 打开app升级弹窗
//- (void)showAppUpdateAlert:(TJSNativeParam *)param;
//
///**
// * @desc 根据配置参数跳转应用或应用市场
// * @param param 入参格式：
// * - appUrl: 应用Scheme（如abcreading://，isJumpApp为YES时必填）
// * - appStoreUrl: 应用市场地址（如itms-apps://...，isJumpApp为NO时必填）
// * - isJumpApp: 布尔值字符串（"true"/"false"，控制跳转目标）
// */
//
//- (void)jumpToApp:(TJSNativeParam *)param;
//
//#pragma mark - 弹框提示Api
///// 普通的toast弹框
//- (void)alert:(TJSNativeParam *)param;
//
///// 弹框选择交互回调
//- (void)alertBySystemWithItems:(TJSNativeParam *)param;
//
//#pragma mark - 交互型Api
///// 关闭所有H5页面
//- (void)closeWebView;
//
///// 所有历史页面
//- (void)webViewHistoryList:(TJSNativeParam *)param;
//
///// 返回历史页面
//- (void)goBack:(TJSNativeParam *)param;
//
///// 关闭弹簧效果
//- (void)webViewBouncesEnable:(TJSNativeParam *)param;
//
//#pragma mark - 导航栏设置Api
///// 设置导航栏样式
//- (void)setNavigationBar:(TJSNativeParam *)param;
//
//#pragma mark - 分享Api
///// 分享
//- (void)share:(TJSNativeParam *)param;
//
//#pragma mark - 获取本次打开webview请求相关的参数
///// 获取本次打开webview请求相关的参数
//- (void)getWebviewRequestParam:(TJSNativeParam *)param;
//
//#pragma mark - 原生方法非JS调用
//- (void)alertAuthorizationWithTpye:(NSInteger)permissionType;

/// 发送消息给Unity
- (void)unityMessageQueue:(TJSNativeParam *)param;

/// 返回unity页面
- (void)backMod:(TJSNativeParam *)param;

@end

NS_ASSUME_NONNULL_END
