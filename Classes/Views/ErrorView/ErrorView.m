//
//  ErrorView.m
//  ParentsCommunity
//
//  Created by leev on 16/3/23.
//  Copyright © 2016年 XES. All rights reserved.
//

#import "ErrorView.h"
#import <WXToolKit/WXToolKit.h>
#import <WXToolKit/WXToolKitMacro.h>
#import <Masonry/Masonry.h>

static Class<ErrorViewDataSource> DataSource = nil;

typedef NS_ENUM(NSInteger, WXErrorViewLayoutMode)
{
    WXErrorViewLayoutModeDefault = 0, //默认全屏布局
    WXErrorViewLayoutModeHalf //半屏布局
};

@interface ErrorView ()
{
    WXErrorViewLayoutMode _layoutMode;
}

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *errorImageView;

@property (nonatomic, strong) UILabel *errorLabel;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIButton *backButton;

@end


@implementation ErrorView

#pragma mark - Override

- (id)init
{
    self = [super init];
    if (self)
    {
        _forceErrorContentViewHalfRender = NO;
        self.actionBtnTitles = @[@"重试"];
        [self setupSubviews];
        [self setupSubviewConstraints];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.superview)
    {
        // 获取屏幕高度
        CGFloat screenHeight = [[[UIApplication sharedApplication] keyWindow] wx_height];

        // 获取父视图的高度
        CGFloat parentViewWidth = self.superview.wx_width;
        CGFloat parentViewHeight = self.superview.wx_height;
                
        if (parentViewHeight <= screenHeight * 3 / 4.0 || (!IS_IPAD && parentViewWidth > parentViewHeight) || self.forceErrorContentViewHalfRender)
        {
            _layoutMode = WXErrorViewLayoutModeHalf;
        }
        
        // 默认距屏幕顶部1/3
        CGFloat constant = parentViewHeight / 3.0f;
        NSString *errorImageName = [DataSource errorImageName];

        if (_layoutMode == WXErrorViewLayoutModeHalf)
        {
            // 居中
            constant = (parentViewHeight - _contentView.wx_height) / 2.0f;
            errorImageName = [DataSource smallErrorImageName];
        }
        
        if (constant < 0)
        {
            constant = 0;
        }
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(@(constant));
        }];
        
        if (self.errorImage)
        {
            self.errorImageView.image = self.errorImage;
        }
        else
        {
            self.errorImageView.image = [UIImage imageNamed:errorImageName];
        }
    
        [self reLayout];
    }
}

#pragma mark - Public Method

// 上层配置类，当提供的样式不满足业务使用时需要配置【全局类配置】
+ (void)setDataSourceClass:(Class<ErrorViewDataSource>)dataSourceClass
{
    DataSource = dataSourceClass;
}


+ (ErrorView *)errorView
{
    return [[ErrorView alloc] init];
}

// 返回按钮是否显示,default is NO
- (void)backBtnShouldShow:(BOOL)show
{
    self.backButton.hidden = !show;
}

- (void)setCustomBackgroundColor:(UIColor*)bgColor
{
    self.backgroundColor = bgColor;
    self.contentView.backgroundColor = bgColor;
}

#pragma mark - Private Method

- (void)setupSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    [self addSubview:self.backButton];
    [self.contentView addSubview:self.errorImageView];
    [self.contentView addSubview:self.errorLabel];
    [self.contentView addSubview:self.leftButton];
    [self.contentView addSubview:self.rightButton];
}

- (void)setupSubviewConstraints
{
    @WeakObj(self);
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(8);
        make.width.mas_equalTo(@44);
        make.height.mas_equalTo(@44);
        if (IS_IPHONE_X)
        {
            make.top.mas_offset(40);
        }
        else
        {
            make.top.mas_offset(20);
        }
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(selfWeak.mas_centerX);
        make.width.mas_equalTo(@300);
        make.top.mas_equalTo(@200);
    }];
    
    [self.errorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(selfWeak.contentView.mas_centerX);
        make.top.mas_equalTo(@0);
    }];
    
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(selfWeak.contentView.mas_centerX);
        make.top.mas_equalTo(selfWeak.errorImageView.mas_bottom).offset(12);
        make.width.mas_equalTo(@250);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.errorLabel.mas_bottom).offset(20);
        make.leading.mas_equalTo(@0);
        make.width.mas_equalTo(@140);
        make.height.mas_equalTo(@40);
        make.bottom.mas_equalTo(@0);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.errorLabel.mas_bottom).offset(20);
        make.trailing.mas_equalTo(@0);
        make.width.mas_equalTo(@140);
        make.height.mas_equalTo(@40);
        make.bottom.mas_equalTo(@0);
    }];
}

- (void)reLayout
{
    CGFloat errorLabelTopConstant = 12;
    CGFloat actionBtnTopConstant = 20;
    CGFloat actionBtnHeightConstant = 40;
    if (_layoutMode == WXErrorViewLayoutModeHalf)
    {
        errorLabelTopConstant = 4;
        actionBtnTopConstant = 12;
        actionBtnHeightConstant = 32;
    }
        
    @WeakObj(self);
    [self.errorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.errorImageView.mas_bottom).offset(errorLabelTopConstant);
    }];
    
    [self.leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.errorLabel.mas_bottom).offset(actionBtnTopConstant);
        make.height.mas_equalTo(@(actionBtnHeightConstant));
    }];

    [self.rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.errorLabel.mas_bottom).offset(actionBtnTopConstant);
        make.height.mas_equalTo(@(actionBtnHeightConstant));
    }];
    
    // 圆角设置
    self.leftButton.layer.cornerRadius = actionBtnHeightConstant / 2;
    self.rightButton.layer.cornerRadius = actionBtnHeightConstant / 2;
        
    // 计算actionBtn的宽度
    if (_actionBtnTitles.count == 1)
    {
        // 计算宽度
        NSInteger titleWidth = [[_actionBtnTitles wx_objectAtIndex:0] wx_sizeWithFontCompatible:self.rightButton.titleLabel.font].width;
        CGFloat constant = titleWidth + 40;
        CGFloat minWidthConstant = 140;
        CGFloat maxWidthConstant = 300 - 12;
        if (_layoutMode == WXErrorViewLayoutModeHalf)
        {
            minWidthConstant = 88;
            maxWidthConstant = 250 - 12;
        }
        
        if (constant < minWidthConstant)
        {
            constant = minWidthConstant;
        }
        else if (constant > maxWidthConstant)
        {
            constant = maxWidthConstant;
        }
        
        [self.rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(constant));
            make.trailing.mas_offset(-(selfWeak.contentView.wx_width - constant) / 2);
        }];
    }
}

#pragma mark - Event Handle

// 返回btn对应的action
- (void)backAction:(id)sender
{
    if (_backBlock != NULL)
    {
        _backBlock();
    }
}

// 当有两个btn时leftBtn对应的action
- (IBAction)leftBtnAction:(id)sender
{
    if (_tapBlock != NULL)
    {
        _tapBlock(0);
    }
}

// 当有两个btn时rightBtn对应的action
- (IBAction)rightBtnAction:(id)sender
{
    if (_retryBlock != NULL)
    {
        _retryBlock();
    }
    else if (_tapBlock != NULL)
    {
        if (self.leftButton.hidden)
        {
            _tapBlock(0);
        }
        else
        {
            _tapBlock(1);
        }
    }
}

#pragma mark - Getter

- (UIView *)contentView
{
    if (_contentView == nil)
    {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIImageView *)errorImageView
{
    if (_errorImageView == nil)
    {
        _errorImageView = [[UIImageView alloc] init];
    }
    return _errorImageView;
}

- (UILabel *)errorLabel
{
    if (_errorLabel == nil)
    {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.font = [UIFont wx_fontPingFangSCWithSize:14];
        _errorLabel.textColor = [UIColor wx_FontLightGrayColor];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.numberOfLines = 2;
    }
    return _errorLabel;
}

- (UIButton *)leftButton
{
    if (_leftButton == nil)
    {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.backgroundColor = [UIColor whiteColor];
        _leftButton.layer.borderWidth = 1;
        _leftButton.layer.borderColor = [UIColor wx_ThemeColor].CGColor;
        _leftButton.layer.cornerRadius = 20.0f;
        _leftButton.layer.masksToBounds = YES;
        _leftButton.titleLabel.font = [UIFont wx_fontPingFangSCMediumWithSize:14.0f];
        [_leftButton setTitleColor:[UIColor wx_ThemeColor] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (_rightButton == nil)
    {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.backgroundColor = [UIColor wx_ThemeColor];
        _rightButton.layer.cornerRadius = 20.0f;
        _rightButton.layer.masksToBounds = YES;
        _rightButton.titleLabel.font = [UIFont wx_fontPingFangSCMediumWithSize:14.0f];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UIButton *)backButton
{
    if (_backButton == nil)
    {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.hidden = YES;
        NSString *backIconName = [DataSource backBtnIconName];
        [_backButton setImage:[UIImage imageNamed:backIconName] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _backButton;
}

#pragma mark - Setter

- (void)setErrorTitle:(NSString *)errorTitle
{
    _errorTitle = errorTitle;
    self.errorLabel.text = _errorTitle;
    
    // 计算error文案的高度
    if (_errorTitle.length > 0)
    {
        CGFloat maxWidth = 250;
        CGFloat errrorTitleHeightConstant = 14;
        CGFloat width = [_errorTitle wx_sizeWithFontCompatible:self.errorLabel.font].width;
        if (width > maxWidth || [_errorTitle containsString:@"\n"])
        {
            errrorTitleHeightConstant = 44;
        }
        
        [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(errrorTitleHeightConstant));
        }];
    }
}

- (void)setActionBtnTitles:(NSArray *)actionBtnTitles
{
    _actionBtnTitles = actionBtnTitles;
    
    if (_actionBtnTitles.count == 0)
    {
        self.leftButton.hidden = YES;
        self.rightButton.hidden = YES;
    }
    else if (_actionBtnTitles.count == 1)
    {
        self.leftButton.hidden = YES;
        self.rightButton.hidden = NO;
        [self.rightButton setTitle:[_actionBtnTitles wx_objectAtIndex:0]forState:UIControlStateNormal];
    }
    else
    {
        self.leftButton.hidden = NO;
        self.rightButton.hidden = NO;

        [self.leftButton setTitle:[_actionBtnTitles wx_objectAtIndex:0] forState:UIControlStateNormal];
        [self.rightButton setTitle:[_actionBtnTitles wx_objectAtIndex:1] forState:UIControlStateNormal];
    }
}

@end

