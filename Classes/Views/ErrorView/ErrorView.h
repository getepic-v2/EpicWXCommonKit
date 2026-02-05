//
//  ErrorView.h
//  ParentsCommunity
//
//  Created by leev on 16/3/23.
//  Copyright © 2016年 XES. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ErrorViewDataSource <NSObject>

/**
 * @desc 全屏失败时的image名称
 */
+ (NSString *)errorImageName;


/**
 * @desc 半屏失败时的image名称
 */
+ (NSString *)smallErrorImageName;


/**
 * @desc 返回按钮icon名称
 */
+ (NSString *)backBtnIconName;

@end


typedef void (^RetryBlock) (void);
typedef void (^ErrorViewBackBlock) (void);
typedef void (^ErrorViewTapBlock) (NSInteger index);

@interface ErrorView : UIView

@property (nonatomic, strong) UIImage *errorImage; //失败时的图片

@property (nonatomic, strong) NSString *errorTitle; //失败时的文案

@property (nonatomic, copy) RetryBlock retryBlock; //失败时重试block

@property (nonatomic, copy) ErrorViewBackBlock backBlock; //失败时返回block

@property (nonatomic, strong) NSArray *actionBtnTitles; //actionBtn文案，顺序赋值，最多支持两个title，当传入为nil时，不展示actionButton

@property (nonatomic, copy) ErrorViewTapBlock tapBlock; //失败时点击按钮时的block（当按钮为两个时使用，同时兼容按钮为一个的情况）

@property (nonatomic, assign) BOOL forceErrorContentViewHalfRender; //强制errorr内容区域半屏渲染，default is NO，该属性适用于希望强制半屏渲染error内容区域时使用【默认内部会根据依附的父试图自动选择全屏渲染or半屏渲染】

/**
 * @desc 上层配置类，当提供的样式不满足业务使用时需要配置【全局类配置】
 */
+ (void)setDataSourceClass:(Class<ErrorViewDataSource>)dataSourceClass;


+ (ErrorView *)errorView;

// 返回按钮是否显示,default is NO
- (void)backBtnShouldShow:(BOOL)show;
// 设置自定义背景色
- (void)setCustomBackgroundColor:(UIColor*)bgColor;

@end

