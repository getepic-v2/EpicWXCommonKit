//
//  LoadingView.h
//  ParentsCommunity
//
//  Created by leev on 16/7/1.
//  Copyright © 2016年 XES. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadingViewDataSource <NSObject>

@required
/**
 * @desc loading用到的lottie文件名
 */
+ (NSString *)loadingLottieFileName;


/**
 * @desc 返回按钮icon名称
 */
+ (NSString *)backBtnIconName;


@end

typedef void (^BackActionBlock)(void);

typedef NS_ENUM(NSInteger, BackgroundColorType)
{
    BackgroundColorTypeDefault = 0, //默认背景色(白色)
    BackgroundColorTypeTransparent = 1, //透明
    BackgroundColorTypeTranslucent = 2 //半透明
};

@interface LoadingView : UIView

@property (nonatomic, strong) NSString *loadingText;

@property (nonatomic, strong) NSString *attributeLoadingText;

@property (nonatomic, assign) BackgroundColorType bgColorType;

@property (nonatomic, strong) UIColor *contentViewBgColor; //内容区域背景色，默认为白色

/**
 * @desc 上层配置类，当提供的样式不满足业务使用时需要配置【全局配置】
 */
+ (void)setDataSourceClass:(Class<LoadingViewDataSource>)dataSourceClass;


/**
 * @desc 初始化方法
 *
 * @param loadingText loading提示语,当传nil时,不显示loading文本
 */
+ (instancetype)loadFromNibWithText:(NSString *)loadingText;


/**
 * @desc 开始loading,同时显示,默认和传入的父视图大小一致
 *
 * @param parentView loadingView依附的父视图,
 */
- (void)startLoadingInView:(UIView *)parentView;


/**
 * @desc 开始loading,同时显示,默认和传入的父视图大小一致
 *
 * @param parentView loadingView依附的父视图,
 */
- (void)startLoadingInView:(UIView *)parentView loadingWidth:(CGFloat)width;


/**
 * @desc 开始loading,同时显示,默认和传入的父视图大小一致
 *
 * @param parentView loadingView依附的父视图,
 *
 * @param width loadingView宽度,
 *
 * @param space loadingView左右距离文字间距,
 *
 * @param top loadingView文字距离图像间距,
 *
 */
- (void)startLoadingInView:(UIView *)parentView
              loadingWidth:(CGFloat)width
            LeftRightspace:(CGFloat)space
              textLabelTop:(CGFloat)top;


/**
 * @desc 开始loading同时显示,默认和传入的俯视图大小一致
 *
 * @param parentView loadingView依附的父视图
 *
 * @param backActionBlock 点击返回按钮的触发事件
 */
- (void)startLoadingInView:(UIView *)parentView
                backAction:(BackActionBlock)backActionBlock;



/**
 * @desc 停止loading,同时隐藏
 */
- (void)stopLoading;

@end
